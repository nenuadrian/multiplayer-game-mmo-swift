import Common
import ArgumentParser

@main
struct Servers: ParsableCommand {
  @Argument(help: "Login Server port")
  var loginServerPort = 38101

  @Argument(help: "World Server port")
  var worldServerPort = 38102

  mutating func run() throws {
    Common.Logger.initiate()

    let server = LoginServer(name: "Login Server", port: loginServerPort)
    server.run()

    let worldServer = WorldServer(name: "World Server", port: worldServerPort)
    worldServer.run()

    repeat {} while true
  }
}
