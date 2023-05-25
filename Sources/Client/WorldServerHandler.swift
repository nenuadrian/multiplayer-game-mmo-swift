import Common
import Foundation
import Socket

class WorldServerPacketHandler: Common.SocketHandler {
  override init() {
    super.init()
    packetHandlers[Packets.CHAR_LIST_RESPONSE] = characterListPacket
    packetHandlers[Packets.JOIN_WORLD_RESPONSE] = joinedWorldPacket
    packetHandlers[Packets.CHAR_DATA_RESPONSE] = charDataPacket
    packetHandlers[Packets.INVENTORY_RESPONSE] = inventoryPacket

    packetHandlers[Packets.START_MOVING_RESPONSE] = charStartMovingPacket
    packetHandlers[Packets.MOVING_RESPONSE] = charMovingPacket
    packetHandlers[Packets.END_MOVING_RESPONSE] = charEndMovingPacket

    packetHandlers[Packets.CHARS_AROUND_RESPONSE] = charsAroundPacket
  }

  func charsAroundPacket(_ bytes: UnsafePointer<UInt8>) {
    let count = UInt16.fromUnsafePointer(bytes)
    var offset = 1
    for i in 0...count - 1 {

    }
  }

  func charStartMovingPacket(_ bytes: UnsafePointer<UInt8>) {
    let _ = Int.fromUnsafePointer(bytes)
  }

  func charMovingPacket(_ bytes: UnsafePointer<UInt8>) {
    let _ = Int.fromUnsafePointer(bytes)
  }

  func charEndMovingPacket(_ bytes: UnsafePointer<UInt8>) {
    let _ = Int.fromUnsafePointer(bytes)
  }

  func characterListPacket(_ bytes: UnsafePointer<UInt8>) {
    print("CHARACTER LIST")
    let count = bytes[0]
    var offset = 1
    for _ in 0...count - 1 {
      let id = Int.fromUnsafePointer(bytes + offset)
      offset += 8
      let name = bytes.getString(lengthOffsetPosition: offset)!
      offset += Int(bytes[offset] + 1)

      let char = Character(id: id, name: name, map: 1, x: 1, y: 1)
      print("char \(id) \(name)")
    }
  }

  func joinedWorldPacket(_ bytes: UnsafePointer<UInt8>) {
    print("JOINED WORLD")
  }

  func charDataPacket(_ bytes: UnsafePointer<UInt8>) {
    print("CHAR DATA")
    let id = Int.fromUnsafePointer(bytes)
    let name = bytes.getString(lengthOffsetPosition: 8)!
    print("char \(id) \(name)")
  }

  func inventoryPacket(_ bytes: UnsafePointer<UInt8>) {
    print("INVENTORY DATA")
    let count = bytes[0]
    var offset = 1
    for _ in 0...count - 1 {
      let item = PacketParser.item(bytes.toArray(offset: offset, length: 2))
      offset += 2

      print("item \(item.id)")
    }
  }
}

class WorldServerHandler: WorldServerPacketHandler {

  func characterList() {
    send(type: Packets.CHAR_LIST_REQUEST)
  }

  func enterWorld(char: Int) {
    var buff = [UInt8]()
    buff += char.toByteArray()
    send(type: Packets.JOIN_WORLD_REQUEST, buff: buff)
  }

  func startMoving() {
    send(type: Packets.START_MOVING_REQUEST)
  }

  func moveTo() {
    send(type: Packets.MOVING_REQUEST)
  }

  func stopMoving() {
    send(type: Packets.END_MOVING_REQUEST)
  }
}
