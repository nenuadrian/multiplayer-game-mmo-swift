import Foundation
import Socket
import Dispatch

class WorldServer : Server {

  override func processClient(socket: Socket) -> SocketHandler {
    let client = WorldServerClient()
    client.with(socket: socket)
    return client
  }
}

class WorldServerClient : SocketHandler {

  override init() {
    super.init()
    packetHandlers[1] = charListPacket
    packetHandlers[2] = enterWorldPacket
  }

  func charListPacket(_ bytes: UnsafePointer<UInt8>) {
    Logger.debug("Packet: CHARACTER LIST")
    let chars = [Character(id: 1, name: "Char1", map: 1, x: 1, y: 1), Character(id: 2, name: "Char2", map: 1, x: 1, y: 1)]
    var buff = [UInt8]()
    buff.append(UInt8(chars.count))
    for char in chars {
      buff += char.id.toByteArray()
      buff.append(UInt8(char.name.utf8.count))
      buff += char.name.utf8
    }
    self.send(type: 1, buff: buff)
  }

  func enterWorldPacket(_ bytes: UnsafePointer<UInt8>) {
    Logger.debug("Packet: ENTER WORLD FROM CHAR SELECT")
    self.send(type: 2)
    let char = Character(id: 1, name: "Char1", map: 1, x: 100, y: 100)
    var charBuff = [UInt8]()
    charBuff += char.id.toByteArray()
    charBuff.append(UInt8(char.name.utf8.count))
    charBuff += char.name.utf8
    charBuff.append(char.map)
    charBuff += char.x.toByteArray()
    charBuff += char.y.toByteArray()

    self.send(type: 3, buff: charBuff)

    var buff = [UInt8]()
    let inventory = [Item(id: 1), Item(id: 2)]
    buff.append(UInt8(inventory.count))
    for item in inventory {
      buff += item.id.toByteArray()
    }
    self.send(type: 4, buff: buff)
  }
}
