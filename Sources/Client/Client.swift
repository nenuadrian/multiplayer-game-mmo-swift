import ArgumentParser
import Common
import Foundation
import Socket

@main
struct Client: ParsableCommand {
  @Argument(help: "Login Server port")
  var loginServerPort = 38101

  @Argument(help: "World Server port")
  var worldServerPort = 38102

  mutating func run() throws {
    Common.Logger.initiate()

    /*
        let loginHandler = LoginServerHandler()
        loginHandler.with(port: loginServerPort)
        loginHandler.login(username: "test", password: "1234")
        self.serverList()
        self.joinServer(server: 1)
        */

    let worldHandler: WorldServerHandler = WorldServerHandler()
    worldHandler.with(port: worldServerPort)
    worldHandler.characterList()
    worldHandler.enterWorld(char: 1)

    worldHandler.startMoving()
    worldHandler.moveTo()
    worldHandler.stopMoving()

    repeat {} while true
  }
}
