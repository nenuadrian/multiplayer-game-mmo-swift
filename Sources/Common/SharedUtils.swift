import Foundation
import Foundation
import Socket

public protocol ByteManipulations {}

public extension ByteManipulations {
    func toByteArray() -> [UInt8] {
        var value: Self = self
        return withUnsafeBytes(of: &value) { Array($0) }
    }

    static func fromByteArray(_ value: [UInt8]) -> Self {
        return value.withUnsafeBytes {
            $0.baseAddress!.load(as: Self.self)
        }
    }

    static func fromUnsafePointer(_ value: UnsafePointer<UInt8>) -> Self {
        return fromByteArray(value.toArray(offset: 0, length: sizeOf()))
    }

    static func sizeOf() -> Int {
        return MemoryLayout<Self>.size
    }
}

/* Given a byte UInt8 array it considers given the offset, the first position to
  be the string byte length and then uses the bytes to build an NSString */
public extension UnsafePointer where Pointee == UInt8 {
  func getString(lengthOffsetPosition: Int) -> String? {
    let length = Int(self[lengthOffsetPosition])
    let str = NSString(bytes: self + lengthOffsetPosition + 1, length: length, encoding: String.Encoding.utf8.rawValue) as String?
    return str
  }

  func toArray(offset: Int, length: Int) -> [UInt8] {
    let buffer = UnsafeBufferPointer(start: self + offset, count: length);
    return Array(buffer)
  }
}

extension UInt16 : ByteManipulations {}
extension Int : ByteManipulations {}


open class SocketHandler {
  public var socket: Socket!
  public var packetHandlers: [UInt8 : (_: UnsafePointer<UInt8>) -> Void] = [:]

  public init() {

  }

  public func with(socket: Socket) {
    self.socket = socket
    self.listen()
  }

  public func with(port: Int32) {
    do {
      self.socket = try Socket.create()
      self.socket.readBufferSize = 32768
      try socket.connect(to: "localhost", port: port)
      self.listen()
    } catch _ { }
  }

  public func send(type: UInt8, buff: [UInt8] = [UInt8]()) {
    do {
      let packetLength = UInt16(buff.count + 1)
      let packet = packetLength.toByteArray() + [type] + buff
      Logger.debug("Sending packet \(type) of size \(packetLength) \(packet.count)")
      try socket.write(from: packet, bufSize: packet.count)
    } catch _ { }
  }

  public func listen() {
    let queue = DispatchQueue.global(qos: .default)

    queue.async { [unowned self, socket] in
        var shouldKeepRunning = true
        var readData = Data(capacity: 4096)

        do {
            repeat {
                let bytesRead = try socket!.read(into: &readData)

                if bytesRead > 0 {
                    readData.withUnsafeBytes {(bytes: UnsafePointer<UInt8>)->Void in
                      var offset = 0
                      var length: UInt16 = 0
                      repeat {
                        length = UInt16.fromByteArray(bytes.toArray(offset: offset, length: 2))
                        if length == 0 {
                          break
                        }
                        let op = bytes[offset + 2]
                        Logger.debug("Packet of type \(op)")
                        Logger.debug("Packet of length \(length)")
                        if let handler: (UnsafePointer<UInt8>) -> Void = self.packetHandlers[op] {
                          let packet = bytes.toArray(offset: offset + 3, length: Int(length) - 1)
                          handler(packet)
                        } else {
                          Logger.debug("Unknown packet op \(op)")
                        }
                        offset += Int(length) + 2
                      } while bytesRead - offset >= 2
                    }
                }

                if bytesRead == 0 {
                    shouldKeepRunning = false
                    break
                }

                readData.count = 0

            } while shouldKeepRunning

            Logger.debug("Socket: \(self.socket.remoteHostname):\(self.socket.remotePort) closed...")

        }
        catch let error {
            guard  error is Socket.Error else {
                Logger.debug("Unexpected error by connection at \(self.socket.remoteHostname):\(self.socket.remotePort)...")
                return
            }
        }
    }
  }

  public func close() {
    self.socket!.close()
    /*  self.socketLockQueue.sync { [unowned self, self.socket] in
          self.connectedSockets[socket.socketfd] = nil
      }*/
  }

  deinit {
    self.close()
  }
}
