

let server = LoginServer(port: 38101)
server.run()

let worldServer = WorldServer(port: 38102)
worldServer.run()


repeat {} while true
