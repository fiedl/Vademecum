import WebKit

class ContactsViewController: VisitableViewController {

  let searchController = UISearchController(searchResultsController: nil)
  let searchBar = UISearchBar()

  override func viewDidLoad() {
    super.viewDidLoad()

    self.definesPresentationContext = true

    // https://stackoverflow.com/a/40013996/2066546
    searchBar.placeholder = "Search"
    searchBar.searchBarStyle = UISearchBarStyle.prominent
    searchBar.barStyle = .default
    searchBar.isTranslucent = false
    searchBar.barTintColor = applicationController!.webAppBackgroundColor
    searchBar.backgroundImage = UIImage()
    searchBar.delegate = self
    setSearchBarPosition()
    view.addSubview(searchBar)
  }

  override func rotated() {
    setSearchBarPosition()
  }

  func setSearchBarPosition() {
    let navigationBarFrame = navigationController?.navigationBar.frame
    let y_coordinate = (navigationBarFrame?.origin.y)! + (navigationBarFrame?.size.height)!
    searchBar.frame = CGRect(x: 0, y: y_coordinate, width: (navigationController?.view.bounds.size.width)!, height: 64)
  }

}

extension ContactsViewController : UISearchBarDelegate {

  func searchBar(_: UISearchBar, textDidChange: String) {
    let url = URL(string: applicationController!.entryPointUrl!.absoluteString.replacingOccurrences(of: "/mobile/welcome", with: "/mobile/partials/people_search_results"))!
    let query = textDidChange
    self.visitableView.webView?.evaluateJavaScript("App.mobile_perform_people_search('\(url)', '\(query)');")
  }

}
