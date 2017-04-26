import SwiftyBeaver

class Logger {
  static let log = SwiftyBeaver.self
  static func initiate() {
    let console = ConsoleDestination()  // log to Xcode Console
    console.format = "[$C$L$c][$DHH:mm:ss$d] $M"
    log.addDestination(console)
  }

  static func verbose(_ data: Any) {
    log.verbose(data)
  }

  static func debug(_ data: Any) {
    log.debug(data)
  }

  static func info(_ data: Any) {
    log.info(data)
  }

  static func warning(_ data: Any) {
    log.warning(data)
  }

  static func error(_ data: Any) {
    log.error(data)
  }
}
