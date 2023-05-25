import Foundation
import Socket
import Dispatch
import Common

class LoginServer : Server {
  override func processClient(socket: Socket) -> Common.SocketHandler {
    let client = LoginServerClient()
    client.with(socket: socket)
    return client
  }
}

class LoginServerClient : Common.SocketHandler {
   override init() {
    super.init()
    packetHandlers[1] = authPacket
    packetHandlers[2] = serverListPacket
    packetHandlers[3] = joinWorldPacket
  }

  func authPacket(_ bytes: UnsafePointer<UInt8>) {
    Common.Logger.debug("Packet: AUTH")
    let username = bytes.getString(lengthOffsetPosition: 0)!
    let offset = Int(bytes[0]) + 1
    let password = bytes.toArray(offset: offset + 1, length: Int(bytes[offset]))
    Common.Logger.debug("Packet: \(username) - \(password)")

    var buff = [UInt8]()
    buff.append(1)
    self.send(type: 1, buff: buff)
  }

  func serverListPacket(_ bytes: UnsafePointer<UInt8>) {
    Common.Logger.debug("Packet: SERVER LIST")
    let servers = [(1, "World 1".utf8, 1), (2, "World 2".utf8, 1)]
    var buff = [UInt8]()
    buff.append(UInt8(servers.count))
    for srv in servers {
      buff.append(UInt8(srv.0))
      buff.append(UInt8(srv.1.count))
      buff += srv.1
      buff.append(UInt8(srv.2))
    }
    self.send(type: 2, buff: buff)
  }

  func joinWorldPacket(_ bytes: UnsafePointer<UInt8>) {
    Common.Logger.debug("Packet: JOIN SERVER")
    var buff = [UInt8]()
    buff.append(UInt8(1))
    self.send(type: 3, buff: buff)
  }
}
