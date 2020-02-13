(deftemplate MODELER::consumed-end
    (slot end-fact (type FACT-ADDRESS))
    (slot rule-system-serial (type INTEGER))
    (slot output-table (type INTEGER))
)
(defrule MODELER::purge-consumed-ends
    ?f <- (consumed-end)  ;; clean up all transient facts for the next RECORDER pass
    =>
    (retract ?f)
)

(deftemplate MODELER::open-start-interval
    (slot time (type INTEGER))
    (slot identifier (type INTEGER))
    (slot subsystem (type STRING))
    (slot category (type STRING))
    (slot name (type STRING))
    (slot thread (type EXTERNAL-ADDRESS SYMBOL) (allowed-symbols sentinel) (default ?NONE))
    (slot process (type EXTERNAL-ADDRESS SYMBOL) (allowed-symbols sentinel) (default ?NONE))
    (multislot message$)
    (slot message (type EXTERNAL-ADDRESS SYMBOL) (allowed-symbols sentinel) (default sentinel))
    (slot user-backtrace (type EXTERNAL-ADDRESS SYMBOL) (allowed-symbols sentinel))
    (slot rule-system-serial (type INTEGER))
    (slot output-table (type INTEGER))
    (multislot layout-category (default ?NONE))
    (slot layout-id (type INTEGER SYMBOL) (allowed-symbols sentinel) (default sentinel))
)
(deftemplate MODELER::matched-interval
    (slot open-fact (type FACT-ADDRESS))
    (slot end-fact (type FACT-ADDRESS))
    (slot rule-system-serial (type INTEGER))
    (slot output-table (type INTEGER))
)

(defrule MODELER::layout-new-interval
    (declare (salience -10)) ;; Allow the new intervals to be asserted before trying to lay out
    (open-start-interval (layout-id sentinel) (time ?start) (layout-category $?layout-cat))
    =>
    (assert (open-layout-reservation (start ?start) (category $?layout-cat)))
)
(defrule MODELER::assign-layout-id
    ?f <- (open-start-interval (time ?time) (layout-category $?layout-cat) (layout-id sentinel))
    (layout-reservation (start ?time) (category $?layout-cat) (id ?layout-id))
    =>
    (modify ?f (layout-id ?layout-id))
)

(defrule MODELER::start-interval-for-system-1 
    (table-attribute (table-id ?autoOutput_) (has schema subscriptions-schema))
    (table (table-id ?autoOutput_) (side append))
    (or (table-attribute (table-id ?autoOutput_) (has target-pid ?target-pid))
        (and (not (table-attribute (table-id ?autoOutput_) (has target-pid $?)))
             (modeler-constants (sentinel-symbol ?target-pid))
        )
    )
    (os-signpost 
        (category "DynamicStackTracing")
        (thread ?autoThreadBinding_)
        (time ?autoStartTimeBinding_&~0)
        (subsystem "tools.timelane.subscriptions")
        (message$ "subscribe:" ?subscription-name "###source:" ?source "###id:" ?subscription-id)
        (identifier ?autoSignpostIdentifier_)
        (process ?autoProcessBinding_)
        (name "subscriptions")
        (event-type "Begin")
    )

    =>

    (bind ?autoLayoutCat_ (create$ global ?autoOutput_))
    (assert (open-start-interval 
               (category "DynamicStackTracing")
               (thread ?autoThreadBinding_)
               (time ?autoStartTimeBinding_)
               (subsystem "tools.timelane.subscriptions")
               (message$ ?subscription-name ?source ?subscription-id)
               (identifier ?autoSignpostIdentifier_)
               (process ?autoProcessBinding_)
               (name "subscriptions")
               (rule-system-serial 1)
               (output-table ?autoOutput_)
               (layout-category ?autoLayoutCat_)
            ))
)

(defrule RECORDER::end-interval-for-system-1 
    (table (table-id ?autoOutput_) (side append))
    (or (table-attribute (table-id ?autoOutput_) (has target-pid ?target-pid))
        (and (not (table-attribute (table-id ?autoOutput_) (has target-pid $?)))
             (modeler-constants (sentinel-symbol ?target-pid))
        )
    )
    ?o <- (open-start-interval 
                (category "DynamicStackTracing")
                (thread ?autoThreadBinding_)
                (time ?autoStartTimeBinding_)
                (subsystem "tools.timelane.subscriptions")
                (message$ ?subscription-name ?source ?subscription-id)
                (identifier ?autoSignpostIdentifier_)
                (process ?autoProcessBinding_)
                (name "subscriptions")
                (rule-system-serial 1)
                (layout-id ?layout-id_&~sentinel)
                (layout-category $?autoLayoutCat_)
                (output-table ?autoOutput_)
    )
    ?f <- (os-signpost 
        (event-type "End")
        (subsystem "tools.timelane.subscriptions")
        (message$ "completion:" ?completion ",error:###" ?error-message "###")
        (identifier ?autoSignpostIdentifier_)
        (name "subscriptions")
        (category "DynamicStackTracing")
        (time ?autoEndTimeBinding_&~0)
    )
    (not (consumed-end (end-fact ?f) (output-table ?autoOutput_) (rule-system-serial 1)))
    (matched-interval (rule-system-serial 1) (open-fact ?o) (end-fact ?f) (output-table ?autoOutput_))

    =>

    (retract ?o)
    (assert (consumed-end (end-fact ?f) (output-table ?autoOutput_) (rule-system-serial 1)))
    ;; close-layout-reservation will be handled before the input fact removal causes a lack of support
    (assert (close-layout-reservation (id ?layout-id_) (start ?autoStartTimeBinding_) (category ?autoLayoutCat_) (end (- ?autoEndTimeBinding_ 1))))
    (create-new-row ?autoOutput_)

    (set-column span-start ?autoStartTimeBinding_)
    (set-column span-duration (- ?autoEndTimeBinding_ ?autoStartTimeBinding_))
    (set-column layout-qualifier ?layout-id_)
    (set-column countable-col (+ 1 0))
    (set-column span-name-col ?subscription-name)
    (set-column status-color-col (switch ?completion (case 1 then "Orange")(case 2 then "Red")(default "Blue")))
    (set-column completion-col ?completion)
    (set-column source-col ?source)
    (set-column subscription-id-col ?subscription-id)
    (set-column status-name-col (switch ?completion (case 1 then "Cancelled")(case 2 then (str-cat "Error(" ?error-message ")"))(default "Completed")))
)

(defrule RECORDER::speculation-for-system-1
    (speculate (event-horizon ?autoHorizonBinding_))
    (open-start-interval (output-table ?autoOutput_) (layout-id ?autoLayoutID_&~sentinel)
                         (category "DynamicStackTracing")
                         (thread ?autoThreadBinding_)
                         (time ?autoStartTimeBinding_)
                         (subsystem "tools.timelane.subscriptions")
                         (message$ ?subscription-name ?source ?subscription-id)
                         (identifier ?autoSignpostIdentifier_)
                         (process ?autoProcessBinding_)
                         (name "subscriptions")
                         (rule-system-serial 1)
    )
    =>
    (create-new-row ?autoOutput_)
    (set-column span-start ?autoStartTimeBinding_)
    (set-column span-duration (- ?autoHorizonBinding_ ?autoStartTimeBinding_))
    (set-column layout-qualifier ?autoLayoutID_)
    (set-column status-name-col (if (not (not ?source)) then "Active"))
    (set-column source-col ?source)
    (set-column status-color-col (if (not (not ?source)) then "Green"))
    (set-column countable-col (+ 1 0))
    (set-column span-name-col ?subscription-name)
    (if (< ?autoStartTimeBinding_ ?*modeler-horizon*) then (bind ?*modeler-horizon* ?autoStartTimeBinding_))
)

(defrule MODELER::signpost-match-detected-1
    (logical ?o <- (open-start-interval (time ?start) (rule-system-serial 1) (thread ?thread) (process ?proc)
                                        (name ?name) (identifier ?signpost-id) (output-table ?autoOutput_)
          )
    (or
      (and ?f <- (os-signpost (time ?end&~?start) (name ?name) (identifier ?signpost-id) (event-type "End") (scope "Thread") (thread ?thread))
           (not (open-start-interval (time ?other-start&:(> ?other-start ?start)) (name ?name) (identifier ?signpost-id) (rule-system-serial 1)
                                     (output-table ?autoOutput_) (thread ?thread)))
      )
      (and ?f <- (os-signpost (time ?end&~?start) (name ?name) (identifier ?signpost-id) (event-type "End") (scope "Process"|"") (process ?process))
           (not (open-start-interval (time ?other-start&:(> ?other-start ?start)) (name ?name) (identifier ?signpost-id) (rule-system-serial 1)
                                     (output-table ?autoOutput_) (process ?proc)))
      )
      (and ?f <- (os-signpost (time ?end&~?start) (name ?name) (identifier ?signpost-id) (event-type "End") (scope "System"))
           (not (open-start-interval (time ?other-start&:(> ?other-start ?start)) (name ?name) (identifier ?signpost-id) (rule-system-serial 1)
                                     (output-table ?autoOutput_)))
      )
    ))
    (not (matched-interval (rule-system-serial 1) (open-fact ?o) (output-table ?autoOutput_)))
    =>
    (assert (matched-interval (rule-system-serial 1) (open-fact ?o) (end-fact ?f) (output-table ?autoOutput_)))
)

(defrule RECORDER::record-point-for-system-2 
    (table-attribute (table-id ?autoOutput_) (has schema events-schema))
    (table (table-id ?autoOutput_) (side append))
    (os-signpost 
            (category "subscriptions")
            (subsystem "tools.timelane.subscriptions")
            (time ?autoPointTimeBinding_&~0)
            (event-type "Event")
            (message$ "subscription:" ?subscription "###type:" ?event-type "###value:" ?value "###source:" ?source "###id:" ?subscription-id)
            (identifier ?autoSignpostIdentifier_)
            (name "subscriptions")
    )

    =>

    (create-new-row ?autoOutput_)

    (set-column event-time-col ?autoPointTimeBinding_)
    (set-column source-col ?source)
    (set-column subscription-col ?subscription)
    (set-column subscription-id-col ?subscription-id)
    (set-column event-type-col ?event-type)
    (set-column value-col (switch ?event-type (case "Completed" then "Done.")(default ?value)))
    (set-column event-color-col (switch ?event-type (case "Error" then "Red")(case "Output" then "Blue")(case "Completed" then "Green")(default "Grey")))
)

(defrule RECORDER::record-point-for-system-3 
    (table-attribute (table-id ?autoOutput_) (has schema version-schema))
    (table (table-id ?autoOutput_) (side append))
    (os-signpost 
            (category "subscriptions")
            (subsystem "tools.timelane.subscriptions")
            (time ?autoPointTimeBinding_&~0)
            (event-type "Event")
            (message$ "version:" ?version)
            (identifier ?autoSignpostIdentifier_)
            (name "subscriptions")
    )

    =>

    (create-new-row ?autoOutput_)

    (set-column timestamp ?autoPointTimeBinding_)
    (set-column version-col ?version)
    (set-column version-color-col (switch ?version (case 1 then "Green")(default "Red")))
    (set-column version-message-col (switch ?version (case 1 then "Correct Timelane client version")(default "Incorrect Timelane code client - expected Timelane protocol 1 but got a different version")))
)

