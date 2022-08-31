

import UIKit


class WriteViewController: BaseViewController {
    
    var mainView = WriteView()
    
    
    
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func configureUI() {
        
    }
    
    override func setConstraints() {
        
    }
    
    override func setNavigationBar() {
        let shareButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(shareButtonTapped))
        let doneButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(doneButtonTapped))
        shareButton.tintColor = .systemOrange
        doneButton.tintColor = .systemOrange
        navigationItem.rightBarButtonItems = [doneButton, shareButton]
        //self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    @objc func shareButtonTapped() {
        
    }
    
    @objc func doneButtonTapped() {
        
    }
    
}






