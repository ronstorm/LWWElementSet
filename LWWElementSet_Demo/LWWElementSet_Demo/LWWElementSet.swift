//
//  LWWElementSet.swift
//  LWWElementSet_Demo
//
//  Created by Amit on 30.09.23.
//

import Foundation

/// An implementation of Last-Writer-Wins Element Set (LWW-Element-Set) with thread safety.
class LWWElementSet<T: Hashable> {
    
    // Store additions and removals with their respective timestamps
    private var additions: [T: Timestamp] = [:]
    private var removals: [T: Timestamp] = [:]
    
    // Queue to ensure thread safety when modifying `additions` and `removals`
    private var queue: DispatchQueue = DispatchQueue(label: "com.lwwElementSet.queue", attributes: .concurrent)
    
    /// Adds an element with a given timestamp.
    func add(element: T, timestamp: Timestamp) {
        queue.async(flags: .barrier) {
            if let existingTimestamp = self.additions[element] {
                if timestamp > existingTimestamp {
                    self.additions[element] = timestamp
                }
            } else {
                self.additions[element] = timestamp
            }
        }
    }
    
    /// Removes an element with a given timestamp.
    func remove(element: T, timestamp: Timestamp) {
        queue.async(flags: .barrier) {
            if let existingTimestamp = self.removals[element] {
                if timestamp > existingTimestamp {
                    self.removals[element] = timestamp
                }
            } else {
                self.removals[element] = timestamp
            }
        }
    }
    
    /// Checks if the set contains an element.
    func contains(element: T) -> Bool {
        return queue.sync {
            if let addTimestamp = self.additions[element], let removeTimestamp = self.removals[element] {
                return addTimestamp > removeTimestamp
            } else if let _ = self.additions[element] {
                return true
            } else {
                return false
            }
        }
    }
    
    /// Retrieves all elements currently in the set.
    func elements() -> [T] {
        return queue.sync {
            return additions.filter { element, _ in
                if let addTimestamp = additions[element], let removeTimestamp = removals[element] {
                    return addTimestamp >= removeTimestamp
                } else if let _ = additions[element] {
                    return true
                } else {
                    return false
                }
            }.map { element, _ in element }
        }
    }
    
    /// Merges another LWWElementSet into this one.
    func merge(with otherSet: LWWElementSet<T>) {
        queue.sync {
            for (element, timestamp) in otherSet.additions {
                if let existingTimestamp = additions[element] {
                    if timestamp > existingTimestamp {
                        additions[element] = timestamp
                    }
                } else {
                    additions[element] = timestamp
                }
            }
            
            for (element, timestamp) in otherSet.removals {
                if let existingTimestamp = removals[element] {
                    if timestamp > existingTimestamp {
                        removals[element] = timestamp
                    }
                } else {
                    removals[element] = timestamp
                }
            }
        }
    }
    
    /// Clears all elements from the set.
    func clear() {
        queue.sync {
            additions = [:]
            removals = [:]
        }
    }
    
    /// Executes a given closure for each element in the set.
    func forEach(_ body: (T) -> Void) {
        for element in elements() {
            body(element)
        }
    }
}
