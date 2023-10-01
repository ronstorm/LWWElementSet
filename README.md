# LWW-Element-Set with SwiftUI

## Overview

This repository contains an example implementation of a **Last-Write-Wins Element Set** (`LWW-Element-Set`) in **Swift**, integrated with a **SwiftUI** interface for basic simulations.

---

## Features

- **LWW-Element-Set CRDT**: Implemented in Swift
- **SwiftUI Interface**: For basic element addition and removal simulations for two users
- **Timestamp-Based Conflict Resolution**
- **Element List View**: Showing elements added by each user with timestamp

---

## Getting Started

### Prerequisites

- **Swift 5.0** or later
- **Xcode 12.0** or later

---

### Installation

1. **Clone the Repository**

    ```bash
    git clone https://github.com/ronstorm/LWWElementSet.git
    ```

2. **Open the Project in Xcode**

3. **Build and Run** the project on a simulator or real device

---

## Usage

### Basic Usage

- To **Add an Element** to the `LWW-Element-Set` for a particular user:

    ```swift
    let element = ElementWithUser(element: "Example", user: "UserA")
    let timestamp = Timestamp(replicaID: "UserA", counter: 1)
    elementSet.add(element: element, timestamp: timestamp)
    ```

- To **Remove an Element**:

    ```swift
    elementSet.remove(element: element, timestamp: newerTimestamp)
    ```

---

### Simulation

- In the SwiftUI interface, you can **start and stop timers** for two users (`User A` and `User B`). Each timer simulates adding random elements to the `LWW-Element-Set`.

---

### Viewing Added Elements

- You can view the added elements in a **SwiftUI List**. Each element is tagged with the user who added it and the timestamp.

    ```swift
    List(elements, id: \.self) { element in
        Text("\(element.element) (\(element.user))")
    }
    ```

---

### Conflict Resolution

- The `LWW-Element-Set` implementation in this project handles **conflict resolution** based on timestamps, ensuring that the last-written element wins.

    ```swift
    if addSet[element]! > removeSet[element]! {
        // Element is considered to be in the set
    }
    ```

---

## License

- This project is licensed under the **MIT License**.

---

## Contributing

- For contributions, please **open an issue first** to discuss what you would like to change.
