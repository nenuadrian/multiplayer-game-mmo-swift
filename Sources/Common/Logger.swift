import SwiftyBeaver

public class Logger {
  static let log: SwiftyBeaver.Type = SwiftyBeaver.self
  public static func initiate() {
    let console: ConsoleDestination = ConsoleDestination()  // log to Xcode Console
    console.format = "[$C$L$c][$DHH:mm:ss$d] $M"
    log.addDestination(console)
  }

  public static func verbose(_ data: Any) {
    log.verbose(data)
  }

  public static func debug(_ data: Any) {
    log.debug(data)
  }

  public static func info(_ data: Any) {
    log.info(data)
  }

  public static func warning(_ data: Any) {
    log.warning(data)
  }

  public static func error(_ data: Any) {
    log.error(data)
  }
}
