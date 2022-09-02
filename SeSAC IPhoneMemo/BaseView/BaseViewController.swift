

import UIKit

class BaseViewController: UIViewController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setConstraints()
        setNavigationBar()
    }
    
    func configureUI() { }
    
    func setConstraints() { }
    
    func setNavigationBar() { }
    
    func showAlertMessage(title: String, button: String) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let ok = UIAlertAction(title: button, style: .default)
        
        alert.addAction(ok)
        present(alert, animated: true)
    }
}
