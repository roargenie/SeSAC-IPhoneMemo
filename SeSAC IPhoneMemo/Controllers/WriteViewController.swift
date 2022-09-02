

import UIKit


class WriteViewController: BaseViewController {
    
    var mainView = WriteView()
    
    let repository = MemoListRepository()
    
    
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
        mainView.textView.delegate = self
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
        guard let text = mainView.textView.text else { return }
        
        let strArr = text.components(separatedBy: "\n")
        let contentText = strArr[1 ... strArr.count - 1].joined(separator: " ")
        if contentText != "" {
            let task = MemoList(title: strArr[0], content: contentText, regDate: Date())
            repository.addItem(item: task)
        } else {
            let task = MemoList(title: strArr[0], content: "내용 없음", regDate: Date())
            repository.addItem(item: task)
        }
         
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension WriteViewController: UITextViewDelegate {
    
    
    
}




