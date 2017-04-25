# multiplayer-game-mmo-swift
A research experiment aiming to figure out the intricacies of MMO servers and clients &amp; Swift, using IBM BlueSocket library as a base for socket handling


# packet structure
Every packet starts with an UInt16 representing its length (excluding the length needed to store the UInt16)

The next UInt8 after the length represents the op code.

Everything else is op specific.
