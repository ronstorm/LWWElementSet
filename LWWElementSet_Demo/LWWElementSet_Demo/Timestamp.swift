//
//  Timestamp.swift
//  LWWElementSet_Demo
//
//  Created by Amit on 30.09.23.
//

import Foundation

/// Represents a unique timestamp with a replica ID and a counter.
struct Timestamp: Comparable {
    let replicaID: String
    let counter: Int
    let uuid: UUID
    let date: Date
    
    init(replicaID: String, counter: Int) {
        self.replicaID = replicaID
        self.counter = counter
        self.uuid = UUID()
        self.date = Date()
    }
    
    static func < (lhs: Timestamp, rhs: Timestamp) -> Bool {
        if lhs.replicaID == rhs.replicaID {
            return lhs.counter < rhs.counter
        }
        return lhs.date < rhs.date
    }
    
    static func == (lhs: Timestamp, rhs: Timestamp) -> Bool {
        return lhs.replicaID == rhs.replicaID &&
               lhs.counter == rhs.counter &&
               lhs.uuid == rhs.uuid &&
               lhs.date == rhs.date
    }
}

extension Timestamp {
    func toString() -> String {
        return "\(counter) : \(date.formattedMinuteSecond())"
    }
}

extension Date {
    func formattedMinuteSecond() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "mm:ss"
        return formatter.string(from: self)
    }
}
