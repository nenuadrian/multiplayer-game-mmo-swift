# Light MMO experiment

This research experiment focuses on investigating the complexities of MMO (Massively Multiplayer Online) servers and clients, specifically using the Swift programming language. The experiment utilizes the IBM BlueSocket library as the foundation for socket handling, which is crucial for establishing communication between the server and clients.

It is important to note that this experiment is not intended to be used as production-ready code for an MMO server or client. Instead, its purpose is to explore and gain insights into the intricacies of MMO architecture and network communication within the Swift programming environment.

# Packet structure

In the given protocol, each packet consists of a series of UInt8 bytes. The first two UInt8 bytes (UInt16) indicate the length of the packet, excluding the bytes required to store the length itself.

Following the length bytes, the next UInt8 byte represents the operation code (op code) that specifies the type of packet being transmitted.

The remaining bytes in the packet, excluding the length byte, are specific to the operation being performed and can vary depending on the op code.

# Test

```
./test.sh
```

# Servers
```
./build.sh
.build/debug/Server
```

## Common

Packet handling library to be used by servers and clients.

## Login Server


## World Server


# Client Test Game

Metal rendering based. Leverages the Common library from `server/Sources/Common`

```
xcodebuild test -project UI.xcodeproj -scheme UI
```