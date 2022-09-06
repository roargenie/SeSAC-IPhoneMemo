

import UIKit
import RealmSwift

final class SearchResultsViewController: BaseViewController {
    
    var mainView = SearchResultsView()
    
    let repository = MemoListRepository()
    
    var tasks: Results<MemoList>! {
        didSet {
            mainView.tableView.reloadData()
        }
    }
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    func fetchRealm() {
        tasks = repository.fetch()
    }
    
}
