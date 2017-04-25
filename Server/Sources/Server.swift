import Foundation
import Socket
import Dispatch


class Server {
  var listenSocket: Socket? = nil
  var connectedSockets = [Int32: SocketHandler]()
  let socketLockQueue: DispatchQueue

  init(port: Int) {
    socketLockQueue = DispatchQueue(label: "com.ibm.serverSwift.socketLockQueue\(port)")
    do {
      try self.listenSocket = Socket.create(family: .inet6)
      try listenSocket!.listen(on: port)
      print("Listening.. ")
    } catch _ {
      print("Unexpected error...")
    }
  }

  func addNewConnection(socket: Socket) {
      socketLockQueue.sync { [unowned self, socket] in
        self.connectedSockets[socket.socketfd] = self.processClient(socket: socket)
      }
  }

  func processClient(socket: Socket) -> SocketHandler {
    let client = SocketHandler(socket: socket)
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
              guard error is Socket.Error else {
                  print("Unexpected error...")
                  return
              }


          }
      }
  }

  deinit {
      self.listenSocket?.close()
  }
}
