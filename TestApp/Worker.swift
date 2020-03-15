//
//  Worker.swift
//  TimelaneTestApp
//
//  Created by Marin Todorov on 1/25/20.
//  Copyright © 2020 Underplot ltd. All rights reserved.
//

import Foundation
import Combine

extension Publishers {
    class WorkerSubscription: Subscription {
        func request(_ demand: Subscribers.Demand) { }
        func cancel() { }
    }
    
    class Worker: Publisher {
        typealias Output = String
        typealias Failure = Error
        
        let duration: TimeInterval
        let error: Error?
        
        init(duration: TimeInterval, error: Error? = nil) {
            self.duration = duration
            self.error = error
        }
        
        func receive<S>(subscriber: S) where S : Subscriber, Publishers.Worker.Failure == S.Failure, Publishers.Worker.Output == S.Input {
            _ = subscriber.receive("Hello")
            let error = self.error
            
            subscriber.receive(subscription: WorkerSubscription())
            
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                if let error = error {
                    subscriber.receive(completion: .failure(error))
                } else {
                    subscriber.receive(completion: .finished)
                }
            }
        }
    }
}
