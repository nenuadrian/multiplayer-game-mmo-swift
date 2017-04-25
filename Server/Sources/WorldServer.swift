import Foundation
import Socket
import Dispatch

class WorldServer : Server {
  override func processClient(socket: Socket) -> SocketHandler {
    let client = WorldServerClient(socket: socket)
    return client
  }
}

class WorldServerClient : SocketHandler {
  override func handlePacket(bytes: UnsafePointer<UInt8>) {
    if bytes[0] == 1 {
      print("CHARACTER LIST")
      let chars = [Character(id: 1, name: "Char1"), Character(id: 2, name: "Char2")]
      var buff = [UInt8]()
      buff.append(UInt8(chars.count))
      for char in chars {
        buff += char.id.toByteArray()
        buff.append(UInt8(char.name.utf8.count))
        buff += char.name.utf8
      }
      self.send(type: 1, buff: buff)

    } else if bytes[0] == 2 {
      print("ENTER WORLD FROM CHAR SELECT")
      self.send(type: 2)
    } else {
      print("UNKNOWN PACKET TYPE")
    }
  }
}
