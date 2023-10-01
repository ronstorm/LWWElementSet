//
//  ContentView.swift
//  LWWElementSet_Demo
//
//  Created by Amit on 30.09.23.
//

import SwiftUI

struct ElementWithUser: Hashable {
    let element: String
    let user: String
    let timestamp: String // We'll store the timestamp as a string for UI presentation
}

// Global LWWElementSet instances to store elements with user titles
var elementSetA = LWWElementSet<ElementWithUser>()
var elementSetB = LWWElementSet<ElementWithUser>()

var counterA: Int = 0
var counterB: Int = 0

struct ContentView: View {
    var body: some View {
        NavigationView {
            NavigationLink(destination: ElementListView()) {
                Text("View Elements")
                    .font(.title)
                    .padding()
            }
            .navigationBarTitle("LWW-Element-Set App")
        }
    }
}

struct ElementListView: View {
    @State private var elements: [ElementWithUser] = []
    @State private var timerA: Timer? = nil
    @State private var timerB: Timer? = nil
    @State private var isTimerARunning: Bool = false
    @State private var isTimerBRunning: Bool = false
    
    var body: some View {
        VStack {
            Text("LWW-Element-Set Elements")
                .font(.largeTitle)
                .padding()
            
            // Timer Toggle Button for User A
            Button(isTimerARunning ? "Stop Timer for User A" : "Start Timer for User A") {
                toggleTimer(for: .userA)
            }
            .padding()
            
            // Timer Toggle Button for User B
            Button(isTimerBRunning ? "Stop Timer for User B" : "Start Timer for User B") {
                toggleTimer(for: .userB)
            }
            .padding()
            
            // List View to show elements
            List(elements, id: \.self) { element in
                HStack {
                    Text(element.element)
                    Spacer()
                    Text(element.user)
                    Spacer()
                    Text(element.timestamp)
                }
            }
            .padding()
        }
        .navigationBarTitle("Element List")
    }
    
    // Enum to distinguish users
    enum User {
        case userA
        case userB
    }
    
    // Toggle timer
    func toggleTimer(for user: User) {
        if user == .userA {
            isTimerARunning ? timerA?.invalidate() : startTimer(for: .userA)
            isTimerARunning.toggle()
        } else {
            isTimerBRunning ? timerB?.invalidate() : startTimer(for: .userB)
            isTimerBRunning.toggle()
        }
    }
    
    // Start Timer
    func startTimer(for user: User) {
        let timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            let randomElement = "Element \(Int.random(in: 1...10))"
            let userTitle = user == .userA ? "UserA" : "UserB"
            
            let timestamp: Timestamp

            if user == .userA {
                counterA += 1
                timestamp = Timestamp(replicaID: "UserA", counter: counterA)
            } else {
                counterB += 1
                timestamp = Timestamp(replicaID: "UserB", counter: counterB)
            }
            
            let elementWithUser = ElementWithUser(element: randomElement, user: userTitle, timestamp: timestamp.toString())
            
            let elementSet = user == .userA ? elementSetA : elementSetB
            elementSet.add(element: elementWithUser, timestamp: timestamp)
            
            // Merging the sets
            elementSetA.merge(with: elementSetB)
            elementSetB.merge(with: elementSetA)
            
            elements = elementSetA.elements()
        }
        
        if user == .userA {
            timerA = timer
        } else {
            timerB = timer
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
