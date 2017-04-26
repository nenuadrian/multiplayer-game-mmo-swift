import Foundation

class PacketParser {
  static func character(bytes: [UInt8]) -> Character {
    return Character(id: 1, name: "sd", map: 1, x: 1, y: 1)
  }

  static func item(_ bytes: [UInt8]) -> Item {
    let id = UInt16.fromByteArray(bytes)

    return Item(id: id)
  }
}
