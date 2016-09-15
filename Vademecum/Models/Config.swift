import Foundation

class Config {
  var entryPointUrl: URL!

  init() {
    let bundle = Bundle.main
    entryPointUrl = URL(string: bundle.object(forInfoDictionaryKey: "EntryPointUrl")! as! String)
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
