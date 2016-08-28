import Foundation

class Config {
  var entryPointUrl: NSURL!

  init() {
    let bundle = NSBundle.mainBundle()
    entryPointUrl = NSURL(string: bundle.objectForInfoDictionaryKey("EntryPointUrl")! as! String)
  }

//    let infoPlistName = "Dev.Info"
//    NSBundle.mainBundle().objectForInfoDictionaryKey(<#T##key: String##String#>)
//
//    let configPath = NSBundle.mainBundle().pathForResource(infoPlistName, ofType: "plist")
//    self.plist = NSDictionary(contentsOfFile: configPath!)
//  }
//
//  func entryPointUrl() -> NSURL {
//    return NSURL(string: plist!["EntryPointUrl"] as! String)!
//  }

}