class Character {
  let id: Int
  let name: String

  init(id: Int, name: String) {
    self.id = id
    self.name = name
  }
}

class Item {
  let id: UInt16
  init(id: UInt16) {
    self.id = id
  }
}
