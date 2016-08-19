import Foundation

struct Device {

  // http://stackoverflow.com/a/30284266/2066546
  static var isSimulator: Bool {
    return TARGET_OS_SIMULATOR != 0
  }

}