import Foundation
import Socket


class WorldServerHandler : SocketHandler {
  override func handlePacket(bytes: UnsafePointer<UInt8>) {
    if bytes[0] == 1 {
      print("CHARACTER LIST")
      let charCount = bytes[1]
      var offset = 2
      for _ in 0...charCount-1 {
        let id = Int.fromByteArray(bytes.splice(offset: offset, length: 8))
        offset += 8
        let name = bytes.getNSString(lengthOffsetPosition: offset)!
        offset += Int(bytes[offset] + 1)

        print("char \(id) \(name)")
      }
    } else if bytes[0] == 2 {
      print("JOINED WORLD")
    } else {
      print("UNKNOWN PACKET TYPE")
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
