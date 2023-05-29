import Foundation
import Socket
import Dispatch
import Common

class WorldServer : Server {

  override func processClient(socket: Socket) -> Common.SocketHandler {
    let client = WorldServerClient(worldServer: self)
    client.with(socket: socket)
    return client
  }

  func findClientsNearby(client: WorldServerClient) -> [WorldServerClient] {
    return self.clients.map { $0.value as! WorldServerClient }.filter { $0.character != nil && $0.socket.socketfd != client.socket.socketfd }
  }
}

class WorldServerClient : Common.SocketHandler {
  let worldServer: WorldServer
  var character: Character!

  init(worldServer: WorldServer) {
    self.worldServer = worldServer

    super.init()
    packetHandlers[Packets.CHAR_LIST_REQUEST] = charListPacket
    packetHandlers[Packets.JOIN_WORLD_REQUEST] = enterWorldPacket

    packetHandlers[Packets.START_MOVING_REQUEST] = startMovingPacket
    packetHandlers[Packets.MOVING_REQUEST] = movingPacket
    packetHandlers[Packets.END_MOVING_REQUEST] = endMovingPacket
  }

  func charListPacket(_ bytes: UnsafePointer<UInt8>) {
    Common.Logger.debug("Packet: CHARACTER LIST")
    let chars = [Character(id: 1, name: "Char1", map: 1, x: 1, y: 1), Character(id: 2, name: "Char2", map: 1, x: 1, y: 1)]
    var buff = [UInt8]()
    buff.append(UInt8(chars.count))
    for char in chars {
      buff += char.id.toByteArray()
      buff.append(UInt8(char.name.utf8.count))
      buff += char.name.utf8
    }
    self.send(type: Packets.CHAR_LIST_RESPONSE, buff: buff)
  }

  func enterWorldPacket(_ bytes: UnsafePointer<UInt8>) {
    Common.Logger.debug("Packet: ENTER WORLD FROM CHAR SELECT")
    self.send(type: Packets.JOIN_WORLD_RESPONSE)
    
    let char = Character(id: 1, name: "Char1", map: 1, x: 100, y: 100)
    self.character = char
    var charBuff = [UInt8]()
    charBuff += char.id.toByteArray()
    charBuff.append(UInt8(char.name.utf8.count))
    charBuff += char.name.utf8
    charBuff.append(char.map)
    charBuff += char.x.toByteArray()
    charBuff += char.y.toByteArray()

    self.send(type: Packets.CHAR_DATA_RESPONSE, buff: charBuff)

    var buff = [UInt8]()
    let inventory = [Item(id: 1), Item(id: 2)]
    buff.append(UInt8(inventory.count))
    for item in inventory {
      buff += item.id.toByteArray()
    }
    self.send(type: Packets.INVENTORY_RESPONSE, buff: buff)
  }

  func startMovingPacket(_ bytes: UnsafePointer<UInt8>) {
    Common.Logger.debug("Packet: START MOVE")

    let nearby = worldServer.findClientsNearby(client: self)
    var buff = [UInt8]()
    buff += character.id.toByteArray()
    nearby.forEach { client in
      client.send(type: Packets.START_MOVING_RESPONSE, buff: buff)
    }
  }

  func movingPacket(_ bytes: UnsafePointer<UInt8>) {
    Common.Logger.debug("Packet: MOVE")

    let nearby = worldServer.findClientsNearby(client: self)
    var buff = [UInt8]()
    buff += character.id.toByteArray()
    nearby.forEach { client in
      client.send(type: Packets.MOVING_RESPONSE, buff: buff)
    }
  }

  func endMovingPacket(_ bytes: UnsafePointer<UInt8>) {
    Common.Logger.debug("Packet: END MOVE")

    let nearby = worldServer.findClientsNearby(client: self)
    var buff = [UInt8]()
    buff += character.id.toByteArray()
    nearby.forEach { client in
      client.send(type: Packets.END_MOVING_RESPONSE, buff: buff)
    }
  }
}
