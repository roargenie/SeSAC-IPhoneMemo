

import UIKit


class WalkThroughViewController: BaseViewController {
    
    var mainView = WalkThroughView()
    
    
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
}






