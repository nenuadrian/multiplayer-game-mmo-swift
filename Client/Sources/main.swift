import Foundation
import Socket

class ServerHandler {
  var socket: Socket!

  init(port: Int32) {
    do {
      socket = try Socket.create()
      socket.readBufferSize = 32768
      try socket.connect(to: "localhost", port: port)
      listen()
    } catch let error { }
  }

  func send(type: UInt8, buff: [UInt8]) {
    do {
      try socket.write(from: [type] + buff, bufSize: buff.count)
    } catch let error { }
  }

  func listen() {
    let queue = DispatchQueue.global(qos: .default)

    queue.async { [unowned self, socket] in

        //var authDone = false

        var shouldKeepRunning = true

        var readData = Data(capacity: 4096)

        do {
            repeat {
                let bytesRead = try socket!.read(into: &readData)

                if bytesRead > 0 {
                    readData.withUnsafeBytes {(bytes: UnsafePointer<UInt8>)->Void in
                      print("GOT PACKET TYPE \(bytes[0])")
                      self.handlePacket(bytes: bytes)
                    }

                }

                if bytesRead == 0 {
                    shouldKeepRunning = false
                    break
                }

                readData.count = 0

            } while shouldKeepRunning

            print("Socket: \(self.socket.remoteHostname):\(self.socket.remotePort) closed...")
          /*  self.socketLockQueue.sync { [unowned self, self.socket] in
                self.connectedSockets[socket.socketfd] = nil
            }*/

        }
        catch let error {
            guard let socketError = error as? Socket.Error else {
                print("Unexpected error by connection at \(self.socket.remoteHostname):\(self.socket.remotePort)...")
                return
            }
        }
    }
  }

  func handlePacket(bytes: UnsafePointer<UInt8>) {}

  func close() {
    self.socket!.close()
  }

  deinit {
    self.close()
  }
}

class LoginServerHandler : ServerHandler {
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
      for i in 0...serverListCount-1 {
        let nameLength = Int(bytes[offset + 1])
        let name = NSString(bytes: bytes + offset + 2, length: nameLength, encoding: String.Encoding.utf8.rawValue)
        servers.append((bytes[offset], name!, bytes[offset + 2 + nameLength ]))
        offset = offset + 2 + nameLength + 1
      }
      print(servers)
      self.joinServer(server: 1)
    } else if bytes[0] == 3 {
      print("JOINED WORLD")
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
    send(type: 2, buff: [UInt8]())
  }

  func joinServer(server: UInt8) {
    var buff = [UInt8]()
    buff.append(server)
    send(type: 3, buff: buff)
  }
}

class WorldServerHandler : ServerHandler {
  override func handlePacket(bytes: UnsafePointer<UInt8>) {
    if bytes[0] == 1 {

    } else {
      print("UNKNOWN PACKET TYPE")
    }
  }
}

let loginHandler = LoginServerHandler(port: 38101)
loginHandler.login(username: "test", password: "1234")

let worldHandler = WorldServerHandler(port: 38102)

repeat { } while true
