import Foundation
import Socket

/*
let loginHandler = LoginServerHandler()
loginHandler.with(port: 38101)
loginHandler.login(username: "test", password: "1234")
self.serverList()
self.joinServer(server: 1)
*/

let worldHandler = WorldServerHandler()
worldHandler.with(port: 38102)
worldHandler.characterList()
worldHandler.enterWorld(char: 1)

repeat {} while true
