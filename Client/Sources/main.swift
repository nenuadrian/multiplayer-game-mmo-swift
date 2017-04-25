import Foundation
import Socket


//let loginHandler = LoginServerHandler(port: 38101)
//loginHandler.login(username: "test", password: "1234")

let worldHandler = WorldServerHandler(port: 38102)
worldHandler.characterList()
worldHandler.enterWorld(char: 1)

repeat {} while true
