

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
    
    override func configureUI() {
        mainView.doneButton.addTarget(self, action: #selector(isTapped), for: .touchUpInside)
    }
    
    override func setConstraints() {
        
    }
    
    @objc func isTapped() {
        let userDefaults = UserDefaults.standard
        userDefaults.set(true, forKey: UserDefaultsManager.isFirstRun)
        userDefaults.synchronize()
        self.presentingViewController?.dismiss(animated: false)
    }
    
    
    
    
}






