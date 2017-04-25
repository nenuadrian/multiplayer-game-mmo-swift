import Foundation
import Socket
import Dispatch


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
    packetHandlers[1] = authPacket
    packetHandlers[2] = serverListPacket
    packetHandlers[3] = joinWorldPacket
  }

  func authPacket(_ bytes: UnsafePointer<UInt8>) {
    print("AUTH")
    let username = bytes.getNSString(lengthOffsetPosition: 0)!
    let pOffset = 1 + Int(bytes[1])
    let password = NSString(bytes: bytes + pOffset + 1, length: Int(bytes[pOffset]), encoding: String.Encoding.utf8.rawValue)!
    print("\(username) - \(password)")

    var buff = [UInt8]()
    buff.append(1)
    self.send(type: 1, buff: buff)
  }

  func serverListPacket(_ bytes: UnsafePointer<UInt8>) {
    print("SERVER LIST")
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
    print("JOIN SERVER")
    var buff = [UInt8]()
    buff.append(UInt8(1))
    self.send(type: 3, buff: buff)
  }
}
