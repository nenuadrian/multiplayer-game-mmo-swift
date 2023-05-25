import ArgumentParser
import Common
import Foundation
import Socket
import SwiftUI

@available(macOS 11.0, *)
@main
struct Client: App {

  var body: some Scene {
    WindowGroup {
      ContentView()
    }
  }

}

/*
 Common.Logger.initiate()


        let loginHandler = LoginServerHandler()
        loginHandler.with(port: loginServerPort)
        loginHandler.login(username: "test", password: "1234")
        self.serverList()
        self.joinServer(server: 1)

    let worldHandler: WorldServerHandler = WorldServerHandler()
    worldHandler.with(port: worldServerPort)
    worldHandler.characterList()
    worldHandler.enterWorld(char: 1)

    worldHandler.startMoving()
    worldHandler.moveTo()
        
worldHandler.stopMoving()

*/
