import WebKit

class ContactsViewController: VisitableViewController {

  let searchController = UISearchController(searchResultsController: nil)

  override func viewDidLoad() {
    super.viewDidLoad()

    self.definesPresentationContext = true

    // https://stackoverflow.com/a/40013996/2066546
    let searchBar = UISearchBar()
    searchBar.placeholder = "Search"
    searchBar.searchBarStyle = UISearchBarStyle.prominent
    searchBar.frame = CGRect(x: 0, y: 64, width: (navigationController?.view.bounds.size.width)!, height: 64)
    searchBar.barStyle = .default
    searchBar.isTranslucent = false
    searchBar.barTintColor = applicationController!.webAppBackgroundColor
    searchBar.backgroundImage = UIImage()
    searchBar.delegate = self
    view.addSubview(searchBar)
  }

}

extension ContactsViewController : UISearchBarDelegate {

  func searchBar(_: UISearchBar, textDidChange: String) {
    let url = URL(string: applicationController!.entryPointUrl!.absoluteString.replacingOccurrences(of: "/mobile/welcome", with: "/mobile/partials/people_search_results"))!
    let query = textDidChange
    self.visitableView.webView?.evaluateJavaScript("App.mobile_perform_people_search('\(url)', '\(query)');")
  }

}
