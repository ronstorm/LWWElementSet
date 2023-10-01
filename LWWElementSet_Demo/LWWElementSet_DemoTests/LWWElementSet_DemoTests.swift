//
//  LWWElementSet_DemoTests.swift
//  LWWElementSet_DemoTests
//
//  Created by Amit on 30.09.23.
//

import XCTest
@testable import LWWElementSet_Demo

final class LWWElementSet_DemoTests: XCTestCase {
    
    /// Tests the addition of an element to the set.
    func testAddition() {
        // Initialize a new LWWElementSet
        let set = LWWElementSet<Int>()
        
        // Add element with updated timestamp
        let timestamp = Timestamp(replicaID: "A", counter: 1)
        set.add(element: 1, timestamp: timestamp)
        
        // Assert that the element was successfully added
        XCTAssertTrue(set.contains(element: 1))
        
        // Assert that an element not added is not in the set
        XCTAssertFalse(set.contains(element: 2))
    }
    
    /// Tests the removal of an element from the set.
    func testRemoval() {
        // Initialize set
        let set = LWWElementSet<Int>()
        
        // Add element
        let addTimestamp = Timestamp(replicaID: "A", counter: 1)
        set.add(element: 1, timestamp: addTimestamp)
        
        // Remove element with updated timestamp
        let removeTimestamp = Timestamp(replicaID: "A", counter: 2)
        set.remove(element: 1, timestamp: removeTimestamp)
        
        // Assert that the element was successfully removed
        XCTAssertFalse(set.contains(element: 1))
    }
    
    /// Tests conflict resolution in cases where the add and remove timestamps are the same.
    func testConflictResolution() {
        // Initialize set
        let set = LWWElementSet<Int>()
        
        // Add and immediately remove the element with the same timestamp
        let timestamp = Timestamp(replicaID: "A", counter: 1)
        set.add(element: 1, timestamp: timestamp)
        set.remove(element: 1, timestamp: timestamp)
        
        // Assert that the element is not in the set due to conflict resolution
        XCTAssertFalse(set.contains(element: 1))
    }
    
    /// Tests the merging of two different sets.
    func testMerge() {
        // Initialize two different sets
        let set1 = LWWElementSet<Int>()
        let set2 = LWWElementSet<Int>()

        // Add elements to both sets
        let timestamp1 = Timestamp(replicaID: "A", counter: 1)
        let timestamp2 = Timestamp(replicaID: "B", counter: 1)
        
        set1.add(element: 1, timestamp: timestamp1)
        set2.add(element: 2, timestamp: timestamp2)

        // Merge the two sets
        set1.merge(with: set2)

        // Assert that elements from both sets are present after the merge
        XCTAssertTrue(set1.contains(element: 1))
        XCTAssertTrue(set1.contains(element: 2))
    }
}
