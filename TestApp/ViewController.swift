//
//  ViewController.swift
//  TimelaneTestApp
//
//  Created by Marin Todorov on 1/25/20.
//  Copyright © 2020 Underplot ltd. All rights reserved.
//

import UIKit
import Combine
import TimelaneCombine

class ViewController: UITableViewController {
    enum MyError: Error {
        case test
    }
    
    var subscriptions = Set<AnyCancellable>()
    
    @IBOutlet var failingSpinner: UIActivityIndicatorView!
    @IBAction func doFailingSubscription(_ sender: Any) {
        failingSpinner.isHidden = false
        Publishers.Worker(duration: 3.0, error: MyError.test)
            .lane("Will Fail", filter: [.subscription])
            .sink(receiveCompletion: { [weak self] completion in
                NSLog("\(completion)")
                self?.failingSpinner.isHidden = true
            }) { value in
                NSLog("output: \(value)")
            }
            .store(in: &subscriptions)
    }

    @IBOutlet var completingSpinner: UIActivityIndicatorView!
    @IBAction func doCompletingSubscription(_ sender: Any) {
        completingSpinner.isHidden = false
        Publishers.Worker(duration: 2.0)
            .lane("Will Complete", filter: [.subscription])
            .sink(receiveCompletion: { [weak self] completion in
                NSLog("\(completion)")
                self?.completingSpinner.isHidden = true
            }) { value in
                NSLog("output: \(value)")
            }
            .store(in: &subscriptions)
    }
    
    @IBOutlet var cancellingSpinner: UIActivityIndicatorView!
    @IBAction func doCancellingSubscription(_ sender: Any) {
        cancellingSpinner.isHidden = false
        var willCancel: AnyCancellable? = Publishers.Worker(duration: 3.0)
            .lane("Will Cancel", filter: [.subscription])
            .sink(receiveCompletion: { completion in
                NSLog("\(completion)")
            }) { value in
                NSLog("output: \(value)")
            }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            willCancel?.cancel()
            willCancel = nil
            self?.cancellingSpinner.isHidden = true
        }
    }
    
    let countdownSubject = CurrentValueSubject<Int, Never>(3)
    @IBOutlet var countdownButton: UIButton!
    var sub: AnyCancellable?
    
    @IBOutlet var counterButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        countdownSubject
            .lane("Countdown", filter: [.event])
            .map { "Tap me \($0) more times" }
            .sink(receiveCompletion: {
                [weak self] _ in self?.countdownButton.setTitle("Finished", for: .normal)
            }, receiveValue: {
                [weak self] in self?.countdownButton.setTitle($0, for: .normal)
            })
            .store(in: &subscriptions)
        
        $counter
            .map { "Counter is at \($0)" }
            .receive(on: DispatchQueue.main)
            .sink { [weak self ] value in
                self?.counterButton.setTitle(value, for: .normal)
            }
            .store(in: &subscriptions)
    }
    
    @IBAction func doEvent(_ sender: Any) {
        guard countdownSubject.value > 0 else { return }
        guard countdownSubject.value > 1 else {
            countdownSubject.send(completion: .finished)
            return
        }
        countdownSubject.value -= 1
    }
    
    @PublishedOnLane("Counter") var counter = 1
    
    @IBAction func doCounter(_ sender: Any) {
        counter += 1
    }
}
