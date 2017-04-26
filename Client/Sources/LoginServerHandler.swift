import Foundation
import Socket
import CryptoSwift

class LoginServerHandler : SocketHandler {
  override init() {
    super.init()
    packetHandlers[1] = authResultPacket
    packetHandlers[2] = serverListPacket
    packetHandlers[3] = joinWorldPacket
  }

  func authResultPacket(_ bytes: UnsafePointer<UInt8>) {
    print("AUTH RESULT")
    let result = bytes[0]
    print(result)
  }

  func serverListPacket(_ bytes: UnsafePointer<UInt8>) {
    print("SERVER LIST RESULT")
    let serverListCount = bytes[0]
    var servers: [(UInt8, NSString, UInt8)] = []
    var offset = 1
    for _ in 0...serverListCount-1 {
      let name = bytes.getNSString(lengthOffsetPosition: offset + 1)
      servers.append((bytes[offset], name!, bytes[offset + 2 + Int(bytes[offset + 1])]))
      offset = offset + 2 + Int(bytes[offset + 1] + 1)
    }
    print(servers)
  }

  func joinWorldPacket(_ bytes: UnsafePointer<UInt8>) {
    print("CAN GO TO WORLD SERVER")
  }

  func login(username: String, password: String) {
    let usernameU8 = username.utf8
    let passwordU8 = Data(bytes: Array(password.utf8)).sha256()
    var buff = [UInt8]()
    buff.append(UInt8(usernameU8.count))
    buff += usernameU8
    buff.append(UInt8(passwordU8.count))
    buff += passwordU8
    print(buff)

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
