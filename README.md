# LWW-Element-Set with SwiftUI

## Overview
This repository contains an example implementation of a Last-Write-Wins Element Set (LWW-Element-Set) in Swift, with a SwiftUI interface for basic simulations.

## Features

- LWW-Element-Set CRDT implemented in Swift
- SwiftUI interface to simulate element addition and removal for two users
- Timestamp-based conflict resolution
- Element list view showing elements added by each user along with the timestamp

## Getting Started

### Prerequisites

- Swift 5.0 or later
- Xcode 12.0 or later

### Installation

1. Clone the repository: https://github.com/ronstorm/LWWElementSet.git
2. Open the project in Xcode
3. Build and run the project on a simulator or real device

## Usage

### Simulation

You can start and stop timers for two users (User A and User B). Each timer simulates adding elements to the LWW-Element-Set.

### Viewing Added Elements

You can view the added elements in a list, each tagged with the user who added it and the timestamp of the addition.

### Conflict Resolution

The LWW-Element-Set implementation in this project handles conflict resolution based on timestamps, ensuring that the last-written element wins.

## License

MIT

## Contributing

For contributions, please open an issue first to discuss what you would like to change.

