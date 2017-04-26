import Foundation

public protocol ByteManipulations {}

public extension ByteManipulations {

  func toByteArray() -> [UInt8] {
    var value = self
    return withUnsafeBytes(of: &value) { Array($0) }
  }

  static func fromByteArray(_ value: [UInt8]) -> Self {
    return value.withUnsafeBytes {
        $0.baseAddress!.load(as: Self.self)
    }
  }
}

/* Given a byte UInt8 array it considers given the offset, the first position to
  be the string byte length and then uses the bytes to build an NSString */
public extension UnsafePointer where Pointee == UInt8 {
  func getNSString(lengthOffsetPosition: Int) -> NSString? {
    let length = Int(self[lengthOffsetPosition])
    let str = NSString(bytes: self + lengthOffsetPosition + 1, length: length, encoding: String.Encoding.utf8.rawValue)
    return str
  }

  func splice(offset: Int, length: Int) -> [UInt8] {
    let msgData = NSData(bytes: self + offset, length: length)
    var msgDataBytes = [UInt8](repeating: 0, count: msgData.length)
    msgData.getBytes(&msgDataBytes, length: msgDataBytes.count)
    return msgDataBytes
  }
}

extension UInt16 : ByteManipulations {}
extension Int : ByteManipulations {}


import Foundation
import Socket

public class SocketHandler {
  var socket: Socket!
  var packetHandlers: [UInt8 : (_: UnsafePointer<UInt8>) -> Void] = [:]

  func with(socket: Socket) {
    self.socket = socket
    self.listen()
  }

  func with(port: Int32) {
    do {
      self.socket = try Socket.create()
      self.socket.readBufferSize = 32768
      try socket.connect(to: "localhost", port: port)
      self.listen()
    } catch _ { }
  }

  func send(type: UInt8, buff: [UInt8] = [UInt8]()) {
    do {
      let packetLength = UInt16(buff.count + 1)
      let packet = packetLength.toByteArray() + [type] + buff
      print("Sending packet \(type) of size \(packetLength) \(packet.count)")
      try socket.write(from: packet, bufSize: packet.count)
    } catch _ { }
  }

  func listen() {
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
                length = UInt16.fromByteArray(bytes.splice(offset: offset, length: 2))
                if length == 0 {
                  break
                }
                let packet = bytes.splice(offset: offset + 3, length: Int(length) - 1)
                let op = bytes[offset + 2]
                if let handler = self.packetHandlers[op] {
                  handler(packet)
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

      print("Socket: \(self.socket.remoteHostname):\(self.socket.remotePort) closed...")
      }
      catch let error {
        guard  error is Socket.Error else {
            print("Unexpected error by connection at \(self.socket.remoteHostname):\(self.socket.remotePort)...")
            return
        }
      }
    }
  }

  func close() {
    self.socket!.close()
    /*  self.socketLockQueue.sync { [unowned self, self.socket] in
          self.connectedSockets[socket.socketfd] = nil
      }*/
  }

  deinit {
    self.close()
  }
}
