# multiplayer-game-mmo-swift
A research experiment aiming to figure out the intricacies of MMO servers and clients &amp; Swift, using IBM BlueSocket library as a base for socket handling


Disclaimer: this of course does not aim to be production code for an MMO server and/or client

# packet structure
Every packet of UInt8 bytes starts with an UInt16 (2 UInt8 bytes) representing its length (excluding the length needed to store the UInt16).

The next UInt8 after the 2 length bytes represents the code operation the packet represents, op code (type of packet).

Everything else (length - 1) is op specific.

# servers

## Login Server


## World Server


# client
