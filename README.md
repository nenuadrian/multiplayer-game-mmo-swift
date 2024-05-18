# Light MMO experiment

## Overview
This research experiment investigates the complexities of MMO (Massively Multiplayer Online) servers and clients using the Swift programming language. The experiment leverages the IBM BlueSocket library for socket handling, which is essential for establishing communication between the server and clients.

### Purpose
This experiment is not intended to serve as production-ready code for an MMO server or client. Instead, it aims to explore and gain insights into the intricacies of MMO architecture and network communication within the Swift programming environment.

## Packet Structure

In this protocol, each packet consists of a series of `UInt8` bytes:
- The first two `UInt8` bytes (`UInt16`) indicate the length of the packet, excluding the bytes required to store the length itself.
- The next `UInt8` byte represents the operation code (op code) that specifies the type of packet being transmitted.
- The remaining bytes in the packet are specific to the operation being performed and can vary depending on the op code.


## Testing

```
./test.sh
```

## Servers
```
./build.sh
.build/debug/Server
```

### Common

Packet handling library to be used by servers and clients.

### Login Server


### World Server


## Client Test Game

Metal rendering based. Leverages the Common library from `server/Sources/Common`

```
xcodebuild test -project UI.xcodeproj -scheme UI
```

## Disclaimer
This project is an experimental research endeavor and was conducted to explore MMO server and client architecture within Swift. It is not intended for production use.

