import Foundation
import Socket

class LoginServerHandler : SocketHandler {
  override func handlePacket(bytes: UnsafePointer<UInt8>) {
    if bytes[0] == 1 {
      print("AUTH RESULT")
      let result = bytes[1]
      print(result)
      self.serverList()
    } else if bytes[0] == 2 {
      print("SERVER LIST RESULT")
      let serverListCount = bytes[1]
      var servers: [(UInt8, NSString, UInt8)] = []
      var offset = 2
      for _ in 0...serverListCount-1 {
        let name = bytes.getNSString(lengthOffsetPosition: offset + 1)
        servers.append((bytes[offset], name!, bytes[offset + 2 + Int(bytes[offset + 1])]))
        offset = offset + 2 + Int(bytes[offset + 1] + 1)
      }
      print(servers)
      self.joinServer(server: 1)
    } else if bytes[0] == 3 {
      print("CAN GO TO WORLD SERVER")
    }else {
      print("UNKNOWN PACKET TYPE")
    }
  }

  func login(username: String, password: String) {
    let usernameU8 = username.utf8
    let passwordU8 = password.utf8
    var buff = [UInt8]()
    buff.append(UInt8(usernameU8.count))
    buff += usernameU8
    buff.append(UInt8(passwordU8.count))
    buff += passwordU8

    send(type: 1, buff: buff)
  }

  func serverList() {
    send(type: 2)
  }

  func joinServer(server: UInt8) {
    var buff = [UInt8]()
    buff.append(server)
    send(type: 3, buff: buff)
  }
}
