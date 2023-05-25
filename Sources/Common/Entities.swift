public class Character {
  public let id: Int
  public let name: String
  public var map: UInt8
  public var x: UInt16
  public var y: UInt16

  public init(id: Int, name: String, map: UInt8, x: UInt16, y: UInt16) {
    self.id = id
    self.name = name
    self.map = map
    self.x = x
    self.y = y

  }
}

public class Item {
  public let id: UInt16
  public init(id: UInt16) {
    self.id = id
  }
}
