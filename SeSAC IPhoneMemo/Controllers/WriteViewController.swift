

import UIKit
import RealmSwift


class WriteViewController: BaseViewController {
    
    var mainView = WriteView()
    
    let repository = MemoListRepository()
    
    var memoData: MemoList?
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        backButtonTapped()
    }
    
    override func configureUI() {
        mainView.textView.delegate = self
        guard let text = memoData?.wholeText else { return }
        mainView.textView.text = text
    }
    
    override func setConstraints() {
        
    }
    
    override func setNavigationBar() {
        
        self.navigationController?.navigationBar.tintColor = .systemOrange
        
    }
    
    @objc func shareButtonTapped() {
        
    }
    
    @objc func doneButtonTapped() {
        
        let userDefaults = UserDefaults.standard
        guard let text = mainView.textView.text else { return }
        let strArr = text.components(separatedBy: "\n")
        let titleText = strArr[0]
        let contentText = strArr[1...strArr.count - 1].joined(separator: " ")
        
        if userDefaults.bool(forKey: UserDefaultsManager.isFirstTapped) == true {
            
            if text != "" {
                if titleText != "" || contentText != "" {
                    let task = MemoList(title: titleText, content: contentText, wholeText: text, regDate: Date())
                    repository.addItem(item: task)
                } else {
                    let task = MemoList(title: titleText, content: "내용 없음", wholeText: text, regDate: Date())
                    repository.addItem(item: task)
                }
                UserDefaultsManager.shared.checkFirstTapped()
                self.navigationController?.popViewController(animated: true)
            } else {
                self.navigationController?.popViewController(animated: true)
            }
            
        } else {
            guard let memoData = memoData else { return }
            
            if text != "" {
                repository.deleteItem(item: memoData)
                self.navigationController?.popViewController(animated: true)
            } else {
                repository.updateItem(item: memoData, title: titleText, content: contentText, wholeText: text)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func backButtonTapped() {
        
        let userDefaults = UserDefaults.standard
        guard let text = mainView.textView.text else { return }
        
        if userDefaults.bool(forKey: UserDefaultsManager.isFirstTapped) == true {
            
            if text != "" || text != " " {
                let strArr = text.components(separatedBy: "\n")
                let titleText = strArr[0]
                let contentText = strArr[1...strArr.count - 1].joined(separator: " ")
                
                let task = MemoList(title: titleText, content: contentText, wholeText: text, regDate: Date())
                repository.addItem(item: task)
                
                UserDefaultsManager.shared.checkFirstTapped()
                self.navigationController?.popViewController(animated: true)
            } else {
                self.navigationController?.popViewController(animated: true)
            }
            
        } else {
            guard let memoData = memoData else { return }
            
            if text != "" {
                repository.deleteItem(item: memoData)
                self.navigationController?.popViewController(animated: true)
            } else {
                let strArr = text.components(separatedBy: "\n")
                let titleText = strArr[0]
                let contentText = strArr[1...strArr.count - 1].joined(separator: " ")
                repository.updateItem(item: memoData, title: titleText, content: contentText, wholeText: text)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
}

extension WriteViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        let shareButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(shareButtonTapped))
        let doneButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(doneButtonTapped))
        navigationItem.rightBarButtonItems = [doneButton, shareButton]
    }
    
}




