import Foundation
import Socket
import Dispatch


class Server {
  var listenSocket: Socket? = nil
  var clients = [Int32: SocketHandler]()
  let socketLockQueue: DispatchQueue
  let name: String

  init(name: String, port: Int) {
    self.name = name
    Logger.info("Starting server \(name) on port \(port)")
    socketLockQueue = DispatchQueue(label: "com.ibm.serverSwift.socketLockQueue\(port)")
    do {
      try self.listenSocket = Socket.create(family: .inet6)
      try listenSocket!.listen(on: port)
      Logger.info("Listening for \(name)")
    } catch _ {
      Logger.error("Listening for \(name)")
    }
  }

  func addNewConnection(socket: Socket) {
      socketLockQueue.sync { [unowned self, socket] in
        self.clients[socket.socketfd] = self.processClient(socket: socket)
      }
  }

  func processClient(socket: Socket) -> SocketHandler {
    let client = SocketHandler()
    client.with(socket: socket)
    return client
  }

  func run() {
      let queue = DispatchQueue.global(qos: .userInteractive)

      queue.async { [unowned self] in
          do {
              repeat {
                  let newSocket = try self.listenSocket!.acceptClientConnection()
                  Logger.debug("Accepted connection: \(newSocket.remoteHostname) on port \(newSocket.remotePort)")
                  self.addNewConnection(socket: newSocket)
              } while true
          }
          catch let error {
              guard error is Socket.Error else {
                  Logger.error("Unexpected socket error...")
                  return
              }
          }
      }
  }

  deinit {
      self.listenSocket?.close()
  }
}
