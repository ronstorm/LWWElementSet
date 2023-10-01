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
        let group = DispatchGroup()
        
        let setA = LWWElementSet<String>()
        let setB = LWWElementSet<String>()
        
        let element1 = "apple"
        let element2 = "banana"
        
        let timestamp1 = Timestamp(replicaID: "A", counter: 1)
        let timestamp2 = Timestamp(replicaID: "B", counter: 2)
        
        // Initially add elements
        setA.add(element: element1, timestamp: timestamp1)
        setB.add(element: element2, timestamp: timestamp2)
        
        var mergedSet = LWWElementSet<String>()
        
        // Merge A and B into a new set
        group.enter()
        DispatchQueue.global().async {
            mergedSet = setA
            mergedSet.merge(with: setB)
            group.leave()
        }
        
        // Wait for merges to complete
        group.wait()
        
        // Check if the merged set contains elements from both sets
        XCTAssertTrue(mergedSet.contains(element: element1), "Merged set should contain element from setA")
        XCTAssertTrue(mergedSet.contains(element: element2), "Merged set should contain element from setB")
    }
    
    // Test for Commutativity: A merged with B should equal B merged with A
    func testCommutativity() {
        let group = DispatchGroup()
        
        let setA = LWWElementSet<String>()
        let setB = LWWElementSet<String>()
        
        let element1 = "apple"
        let element2 = "banana"
        
        let timestamp1 = Timestamp(replicaID: "A", counter: 1)
        let timestamp2 = Timestamp(replicaID: "B", counter: 2)
        
        // Initially add elements
        setA.add(element: element1, timestamp: timestamp1)
        setB.add(element: element2, timestamp: timestamp2)
        
        var setAB = LWWElementSet<String>()
        var setBA = LWWElementSet<String>()
        
        // Merge A into B
        group.enter()
        DispatchQueue.global().async {
            setAB = setA
            setAB.merge(with: setB)
            group.leave()
        }
        
        // Merge B into A
        group.enter()
        DispatchQueue.global().async {
            setBA = setB
            setBA.merge(with: setA)
            group.leave()
        }
        
        // Wait for merges to complete
        group.wait()
        
        // Now, setAB should be equal to setBA if the merge operation is commutative
        XCTAssertTrue(setAB.elements() == setBA.elements(), "Merge operation is not commutative")
    }
    
    // Test for Associativity: (A merged with B) merged with C should equal A merged with (B merged with C)
    func testAssociativity() {
        let group = DispatchGroup()
        
        let setA = LWWElementSet<String>()
        let setB = LWWElementSet<String>()
        let setC = LWWElementSet<String>()
        
        let element1 = "apple"
        let element2 = "banana"
        let element3 = "cherry"
        
        let timestamp1 = Timestamp(replicaID: "A", counter: 1)
        let timestamp2 = Timestamp(replicaID: "B", counter: 2)
        let timestamp3 = Timestamp(replicaID: "C", counter: 3)
        
        // Initially add elements
        setA.add(element: element1, timestamp: timestamp1)
        setB.add(element: element2, timestamp: timestamp2)
        setC.add(element: element3, timestamp: timestamp3)
        
        var setAB = LWWElementSet<String>()
        var setBC = LWWElementSet<String>()
        
        // Merge A and B
        group.enter()
        DispatchQueue.global().async {
            setAB = setA
            setAB.merge(with: setB)
            group.leave()
        }
        
        // Merge B and C
        group.enter()
        DispatchQueue.global().async {
            setBC = setB
            setBC.merge(with: setC)
            group.leave()
        }
        
        // Wait for merges to complete
        group.wait()
        
        // Now merge (A merged with B) with C
        let setABC1 = setAB
        setABC1.merge(with: setC)
        
        // And also merge A with (B merged with C)
        let setABC2 = setA
        setABC2.merge(with: setBC)
        
        // Now, setABC1 should be equal to setABC2 if the merge operation is associative
        XCTAssertTrue(setABC1.elements() == setABC2.elements(), "Merge operation is not associative")
    }
    
    
    // Test for Idempotence: Merging a set with itself should not change the set
    func testIdempotence() {
        let setA = LWWElementSet<String>()
        
        setA.add(element: "apple", timestamp: Timestamp(replicaID: "A", counter: 1))
        let elementsBefore = setA.elements()
        
        setA.merge(with: setA)
        
        let elementsAfter = setA.elements()
        
        XCTAssertEqual(elementsBefore, elementsAfter)
    }
}
