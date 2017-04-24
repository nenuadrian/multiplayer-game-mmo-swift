import Foundation
import Socket
import Dispatch

class Client {
  let socket: Socket
  init(socket: Socket) {
      self.socket = socket
      listen()
  }

  func send(type: UInt8, buff: [UInt8]) {
    do {
      try socket.write(from: [type] + buff, bufSize: buff.count)
    } catch let error { }
  }

  func listen() {
    // Get the global concurrent queue...
    let queue = DispatchQueue.global(qos: .default)

    // Create the run loop work item and dispatch to the default priority global queue...
    queue.async { [unowned self, socket] in

        //var authDone = false

        var shouldKeepRunning = true

        var readData = Data(capacity: 4096)

        do {
            repeat {
              let bytesRead = try socket.read(into: &readData)

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
            self.close()
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
    self.socket.close()
  }

  deinit {
    self.close()
  }
}



class Server {
  var listenSocket: Socket? = nil
  var connectedSockets = [Int32: Client]()
  let socketLockQueue: DispatchQueue

  init(port: Int) {
    socketLockQueue = DispatchQueue(label: "com.ibm.serverSwift.socketLockQueue\(port)")
    do {
      try self.listenSocket = Socket.create(family: .inet6)
      try listenSocket!.listen(on: port)
      print("Listening.. ")
    } catch let error {
      print("Unexpected error...")
    }
  }

  func addNewConnection(socket: Socket) {
      // Add the new socket to the list of connected sockets...
      socketLockQueue.sync { [unowned self, socket] in
        self.connectedSockets[socket.socketfd] = self.processClient(socket: socket)
      }
  }

  func processClient(socket: Socket) -> Client {
    let client = Client(socket: socket)
    return client
  }

  func run() {
      let queue = DispatchQueue.global(qos: .userInteractive)

      queue.async { [unowned self] in
          do {
              repeat {
                  let newSocket = try self.listenSocket!.acceptClientConnection()
                  print("Accepted connection from: \(newSocket.remoteHostname) on port \(newSocket.remotePort)")
                  self.addNewConnection(socket: newSocket)
              } while true
          }
          catch let error {
              guard let socketError = error as? Socket.Error else {
                  print("Unexpected error...")
                  return
              }


          }
      }
      //dispatchMain()
  }

  deinit {
      self.listenSocket?.close()
  }
}


class LoginServer : Server {
  override func processClient(socket: Socket) -> Client {
    let client = LoginServerClient(socket: socket)
    return client
  }
}

class LoginServerClient : Client {
  override func handlePacket(bytes: UnsafePointer<UInt8>) {
      if bytes[0] == 1 {
        print("AUTH")
        let username = NSString(bytes: bytes + 2, length: Int(bytes[1]), encoding: String.Encoding.utf8.rawValue)
        let pOffset = 2 + Int(bytes[1])
        let password = NSString(bytes: bytes + pOffset + 1, length: Int(bytes[pOffset]), encoding: String.Encoding.utf8.rawValue)

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

class WorldServer : Server {
  override func processClient(socket: Socket) -> Client {
    let client = WorldServerClient(socket: socket)
    return client
  }
}

class WorldServerClient : Client {
  override func handlePacket(bytes: UnsafePointer<UInt8>) {
    if bytes[0] == 1 {
      print("CHARACTER LIST")

    } else if bytes[0] == 2 {
      print("ENTER WORLD FROM CHAR SELECT")

    } else {
      print("UNKNOWN PACKET TYPE")
    }
  }
}

let server = LoginServer(port: 38101)
server.run()

let worldServer = WorldServer(port: 38102)
worldServer.run()

repeat {} while true
