import Foundation
import Socket
import Dispatch
import Common

class LoginServer : Server {
  override func processClient(socket: Socket) -> SocketHandler {
    let client = LoginServerClient()
    client.with(socket: socket)
    return client
  }
}

class LoginServerClient : SocketHandler {
   override init() {
    super.init()
    packetHandlers[Packets.LOGIN_REQUEST] = authPacket
    packetHandlers[Packets.SERVER_LIST_REQUEST] = serverListPacket
    packetHandlers[Packets.JOIN_SERVER_REQUEST] = joinServerPacket
  }

  func authPacket(_ bytes: UnsafePointer<UInt8>) {
    Logger.debug("Packet: AUTH")
    let username = bytes.getString(lengthOffsetPosition: 0)!
    let offset = Int(bytes[0]) + 1
    let password = bytes.toArray(offset: offset + 1, length: Int(bytes[offset]))
    Logger.debug("Packet: \(username) - \(password)")

    var buff = [UInt8]()
    buff.append(1)
    self.send(type: Packets.LOGIN_RESPONSE, buff: buff)
  }

  func serverListPacket(_ bytes: UnsafePointer<UInt8>) {
    Logger.debug("Packet: SERVER LIST")
    let servers = [(1, "World 1".utf8, 1), (2, "World 2".utf8, 1)]
    var buff = [UInt8]()
    buff.append(UInt8(servers.count))
    for srv in servers {
      buff.append(UInt8(srv.0))
      buff.append(UInt8(srv.1.count))
      buff += srv.1
      buff.append(UInt8(srv.2))
    }
    self.send(type: Packets.SERVER_LIST_RESPONSE, buff: buff)
  }

  func joinServerPacket(_ bytes: UnsafePointer<UInt8>) {
    Logger.debug("Packet: JOIN SERVER")
    var buff = [UInt8]()
    buff.append(UInt8(1))
    self.send(type: Packets.JOIN_SERVER_RESPONSE, buff: buff)
  }
}
