(deftemplate modeler-instance (slot instance))
(deftemplate modeler-instance-binding (slot instance) (slot rule))
(deftemplate modeler-instance-bound-watchable (slot instance) (slot table-id) (slot watch-id))
(deftemplate modeler-instance-param (slot instance) (slot name) (multislot value))

(defrule binding-rule-1
    (declare (salience 160))
    (unbound-table-instance (table-id ?t0__) (has schema subscriptions-schema))
    (unbound-table-instance (table-id ?t0__) (has target-pid $?target-pid))
    ?mod-inst-fact__ <- (modeler-instance (instance ?instance__))
    (not (modeler-instance-param (instance ?instance__) (name target-pid) (value ~$?target-pid)))
    =>
    (if (eq ?instance__ FALSE) then (bind ?instance__ (create-modeler-instance)) (modify ?mod-inst-fact__ (instance ?instance__)) else (set-modeler-instance-to ?instance__))
    (assert (modeler-instance-binding (instance ?instance__) (rule 1)))
    (bind-output-table ?t0__)
    (bind-input-table os-signpost (attribute subsystem "tools.timelane.subscriptions") (attribute category DynamicStackTracing) (attribute target-pid $?target-pid))
    (assert (modeler-instance-param (instance ?instance__) (name target-pid) (value ?target-pid)))
)
(defrule bootstrap-rule-1
    (declare (salience -100))
    (not (modeler-instance (instance FALSE)))
    (unbound-table-instance (table-id ?t0__) (has schema subscriptions-schema))
    (unbound-table-instance (table-id ?t0__) (has target-pid $?target-pid))
    =>
    (assert (modeler-instance (instance FALSE)))
)
(defrule binding-rule-2
    (declare (salience 150))
    (unbound-table-instance (table-id ?t0__) (has schema subscriptions-schema))
    ?mod-inst-fact__ <- (modeler-instance (instance ?instance__))
    =>
    (if (eq ?instance__ FALSE) then (bind ?instance__ (create-modeler-instance)) (modify ?mod-inst-fact__ (instance ?instance__)) else (set-modeler-instance-to ?instance__))
    (assert (modeler-instance-binding (instance ?instance__) (rule 2)))
    (bind-output-table ?t0__)
    (bind-input-table os-signpost (attribute category DynamicStackTracing) (attribute subsystem "tools.timelane.subscriptions"))
)
(defrule bootstrap-rule-2
    (declare (salience -100))
    (not (modeler-instance (instance FALSE)))
    (unbound-table-instance (table-id ?t0__) (has schema subscriptions-schema))
    =>
    (assert (modeler-instance (instance FALSE)))
)
(defrule binding-rule-3
    (declare (salience 140))
    (unbound-table-instance (table-id ?t0__) (has schema events-schema))
    (unbound-table-instance (table-id ?t0__) (has target-pid $?target-pid))
    ?mod-inst-fact__ <- (modeler-instance (instance ?instance__))
    (not (modeler-instance-param (instance ?instance__) (name target-pid) (value ~$?target-pid)))
    =>
    (if (eq ?instance__ FALSE) then (bind ?instance__ (create-modeler-instance)) (modify ?mod-inst-fact__ (instance ?instance__)) else (set-modeler-instance-to ?instance__))
    (assert (modeler-instance-binding (instance ?instance__) (rule 3)))
    (bind-output-table ?t0__)
    (bind-input-table os-signpost (attribute category DynamicStackTracing) (attribute target-pid $?target-pid) (attribute subsystem "tools.timelane.subscriptions"))
    (assert (modeler-instance-param (instance ?instance__) (name target-pid) (value ?target-pid)))
)
(defrule bootstrap-rule-3
    (declare (salience -100))
    (not (modeler-instance (instance FALSE)))
    (unbound-table-instance (table-id ?t0__) (has schema events-schema))
    (unbound-table-instance (table-id ?t0__) (has target-pid $?target-pid))
    =>
    (assert (modeler-instance (instance FALSE)))
)
(defrule binding-rule-4
    (declare (salience 130))
    (unbound-table-instance (table-id ?t0__) (has schema events-schema))
    ?mod-inst-fact__ <- (modeler-instance (instance ?instance__))
    =>
    (if (eq ?instance__ FALSE) then (bind ?instance__ (create-modeler-instance)) (modify ?mod-inst-fact__ (instance ?instance__)) else (set-modeler-instance-to ?instance__))
    (assert (modeler-instance-binding (instance ?instance__) (rule 4)))
    (bind-output-table ?t0__)
    (bind-input-table os-signpost (attribute category DynamicStackTracing) (attribute subsystem "tools.timelane.subscriptions"))
)
(defrule bootstrap-rule-4
    (declare (salience -100))
    (not (modeler-instance (instance FALSE)))
    (unbound-table-instance (table-id ?t0__) (has schema events-schema))
    =>
    (assert (modeler-instance (instance FALSE)))
)
(defrule binding-rule-5
    (declare (salience 120))
    (unbound-table-instance (table-id ?t0__) (has schema version-schema))
    (unbound-table-instance (table-id ?t0__) (has target-pid $?target-pid))
    ?mod-inst-fact__ <- (modeler-instance (instance ?instance__))
    (not (modeler-instance-param (instance ?instance__) (name target-pid) (value ~$?target-pid)))
    =>
    (if (eq ?instance__ FALSE) then (bind ?instance__ (create-modeler-instance)) (modify ?mod-inst-fact__ (instance ?instance__)) else (set-modeler-instance-to ?instance__))
    (assert (modeler-instance-binding (instance ?instance__) (rule 5)))
    (bind-output-table ?t0__)
    (bind-input-table os-signpost (attribute category DynamicStackTracing) (attribute target-pid $?target-pid) (attribute subsystem "tools.timelane.subscriptions"))
    (assert (modeler-instance-param (instance ?instance__) (name target-pid) (value ?target-pid)))
)
(defrule bootstrap-rule-5
    (declare (salience -100))
    (not (modeler-instance (instance FALSE)))
    (unbound-table-instance (table-id ?t0__) (has schema version-schema))
    (unbound-table-instance (table-id ?t0__) (has target-pid $?target-pid))
    =>
    (assert (modeler-instance (instance FALSE)))
)
(defrule binding-rule-6
    (declare (salience 110))
    (unbound-table-instance (table-id ?t0__) (has schema version-schema))
    ?mod-inst-fact__ <- (modeler-instance (instance ?instance__))
    =>
    (if (eq ?instance__ FALSE) then (bind ?instance__ (create-modeler-instance)) (modify ?mod-inst-fact__ (instance ?instance__)) else (set-modeler-instance-to ?instance__))
    (assert (modeler-instance-binding (instance ?instance__) (rule 6)))
    (bind-output-table ?t0__)
    (bind-input-table os-signpost (attribute subsystem "tools.timelane.subscriptions") (attribute category DynamicStackTracing))
)
(defrule bootstrap-rule-6
    (declare (salience -100))
    (not (modeler-instance (instance FALSE)))
    (unbound-table-instance (table-id ?t0__) (has schema version-schema))
    =>
    (assert (modeler-instance (instance FALSE)))
)
