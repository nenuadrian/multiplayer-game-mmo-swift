class Character {
  let id: Int
  let name: String
  var map: UInt8
  var x: UInt16
  var y: UInt16

  init(id: Int, name: String, map: UInt8, x: UInt16, y: UInt16) {
    self.id = id
    self.name = name
    self.map = map
    self.x = x
    self.y = y

  }
}

class Item {
  let id: UInt16
  init(id: UInt16) {
    self.id = id
  }
}
