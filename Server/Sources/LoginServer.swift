import Foundation
import Socket
import Dispatch


class LoginServer : Server {
  override func processClient(socket: Socket) -> SocketHandler {
    let client = LoginServerClient(socket: socket)
    return client
  }
}

class LoginServerClient : SocketHandler {
  override func handlePacket(bytes: UnsafePointer<UInt8>) {
      if bytes[0] == 1 {
        print("AUTH \(bytes[1])")
        let username = bytes.getNSString(lengthOffsetPosition: 1)!
        let pOffset = 2 + Int(bytes[1])
        let password = NSString(bytes: bytes + pOffset + 1, length: Int(bytes[pOffset]), encoding: String.Encoding.utf8.rawValue)!
        print("\(username) - \(password)")

        var buff = [UInt8]()
        buff.append(1)
        self.send(type: 1, buff: buff)
      } else if bytes[0] == 2 {
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
      } else if bytes[0] == 3 {
        print("JOIN SERVER")
        var buff = [UInt8]()
        buff.append(UInt8(1))
        self.send(type: 3, buff: buff)
      } else {
        print("UNKNOWN PACKET TYPE")
      }
  }

}
