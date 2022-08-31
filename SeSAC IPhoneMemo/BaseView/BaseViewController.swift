

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
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(ok)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
}
