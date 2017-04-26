
Logger.initiate()

let server = LoginServer(name: "Login Server", port: 38101)
server.run()

let worldServer = WorldServer(name: "World Server", port: 38102)
worldServer.run()

repeat {} while true
