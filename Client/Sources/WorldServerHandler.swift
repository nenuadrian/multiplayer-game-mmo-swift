import Foundation
import Socket


class WorldServerHandler : SocketHandler {
  override init() {
    super.init()
    packetHandlers[1] = characterListPacket
    packetHandlers[2] = joinedWorldPacket
    packetHandlers[3] = charDataPacket
    packetHandlers[4] = inventoryPacket
  }

  func characterListPacket(_ bytes: UnsafePointer<UInt8>) {
    print("CHARACTER LIST")
    let count = bytes[0]
    var offset = 1
    for _ in 0...count-1 {
      let id = Int.fromByteArray(bytes.splice(offset: offset, length: 8))
      offset += 8
      let name = bytes.getNSString(lengthOffsetPosition: offset)!
      offset += Int(bytes[offset] + 1)

      print("char \(id) \(name)")
    }
  }

  func joinedWorldPacket(_ bytes: UnsafePointer<UInt8>) {
    print("JOINED WORLD")
  }

  func charDataPacket(_ bytes: UnsafePointer<UInt8>) {
    print("CHAR DATA")
    let id = Int.fromByteArray(bytes.splice(offset: 0, length: 8))
    let name = bytes.getNSString(lengthOffsetPosition: 8)!
    print("char \(id) \(name)")
  }

  func inventoryPacket(_ bytes: UnsafePointer<UInt8>) {
    print("INVENTORY DATA")
    let count = bytes[0]
    var offset = 1
    for _ in 0...count-1 {
      let item = PacketParser.item(bytes.splice(offset: offset, length: 2))
      offset += 2

      print("item \(item.id)")
    }
  }

  func characterList() {
    send(type: 1)
  }

  func enterWorld(char: Int) {
    var buff = [UInt8]()
    buff += char.toByteArray()
    send(type: 2, buff: buff)
  }
}
