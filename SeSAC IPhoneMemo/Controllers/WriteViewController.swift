

import UIKit
import RealmSwift


final class WriteViewController: BaseViewController {
    
    var mainView = WriteView()
    
    let repository = MemoListRepository()
    
    var memoData: MemoList?
    
    var tasks: Results<MemoList>!
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if UserDefaults.standard.bool(forKey: UserDefaultsManager.isBackButtonTapped) == true {
            backButtonTapped()
            fetchRealm()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        //fetchRealm()
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
    
    func fetchRealm() {
        tasks = repository.fetch()
    }
    
    @objc func shareButtonTapped() {
        let activityViewController = UIActivityViewController(activityItems: [memoData?.wholeText ?? ""], applicationActivities: nil)
        
        self.present(activityViewController, animated: true)
    }
    
    @objc func doneButtonTapped() {
        
        let userDefaults = UserDefaults.standard
        UserDefaults.standard.set(false, forKey: UserDefaultsManager.isBackButtonTapped)
        guard let text = mainView.textView.text else { return }
        
        let strArr = text.components(separatedBy: "\n")
        
        if userDefaults.bool(forKey: UserDefaultsManager.isFirstTapped) == true {
            
            if strArr.count > 1 {
                let titleText = strArr[0]
                
                let contentText = strArr[1...strArr.count - 1].joined(separator: " ")
                
                let task = MemoList(title: titleText, content: contentText, wholeText: text, regDate: Date())
                repository.addItem(item: task)
                //UserDefaultsManager.shared.checkFirstTapped()
                self.navigationController?.popViewController(animated: true)
                print(#function, "=============1")
                
            } else if strArr.count == 1 && text != "" && text != " " && text != "\n" {
                let titleText = strArr[0]
                
                let task = MemoList(title: titleText, content: "?????? ??????", wholeText: text, regDate: Date())
                repository.addItem(item: task)
                //UserDefaultsManager.shared.checkFirstTapped()
                self.navigationController?.popViewController(animated: true)
                print(#function, "=============2")
            } else {
                //UserDefaultsManager.shared.checkFirstTapped()
                self.navigationController?.popViewController(animated: true)
                print(#function, "=============3")
            }
            
        } else {
            guard let memoData = memoData else { return }
            if strArr.count > 1 {
                let titleText = strArr[0]
                
                let contentText = strArr[1...strArr.count - 1].joined(separator: " ")
                
                repository.updateItem(item: memoData, title: titleText, content: contentText, wholeText: text)
                //UserDefaultsManager.shared.checkFirstTapped()
                self.navigationController?.popViewController(animated: true)
                print(#function, "=============1 ????????????")
            } else if strArr.count == 1 && text != "" && text != " " && text != "\n" {
                let titleText = strArr[0]
                
                repository.updateItem(item: memoData, title: titleText, content: "?????? ??????", wholeText: text)
                //UserDefaultsManager.shared.checkFirstTapped()
                self.navigationController?.popViewController(animated: true)
                print(#function, "=============2 ????????????")
            } else {
                repository.deleteItem(item: memoData)
                //UserDefaultsManager.shared.checkFirstTapped()
                self.navigationController?.popViewController(animated: true)
                print(#function, "=============3 ????????????")
            }
        }
    }
    
    func backButtonTapped() {
        
        guard let text = mainView.textView.text else { return }
        let strArr = text.components(separatedBy: "\n")
        let userDefaults = UserDefaults.standard
        //UserDefaults.standard.set(false, forKey: UserDefaultsManager.isBackButtonTapped)
        
        if userDefaults.bool(forKey: UserDefaultsManager.isFirstTapped) == true {
            
            if strArr.count > 1 {
                let titleText = strArr[0]
                
                let contentText = strArr[1...strArr.count - 1].joined(separator: " ")
                
                let task = MemoList(title: titleText, content: contentText, wholeText: text, regDate: Date())
                repository.addItem(item: task)
                //UserDefaultsManager.shared.checkFirstTapped()
                self.navigationController?.popViewController(animated: true)
                print(#function, "=============1")
                
            } else if strArr.count == 1 && text != "" && text != " " && text != "\n" {
                let titleText = strArr[0]
                
                let task = MemoList(title: titleText, content: "?????? ??????", wholeText: text, regDate: Date())
                repository.addItem(item: task)
                //UserDefaultsManager.shared.checkFirstTapped()
                self.navigationController?.popViewController(animated: true)
                print(#function, "=============2")
            } else {
                //UserDefaultsManager.shared.checkFirstTapped()
                self.navigationController?.popViewController(animated: true)
                print(#function, "=============3")
            }
            
        } else {
            guard let memoData = memoData else { return }
            if strArr.count > 1 {
                let titleText = strArr[0]
                
                let contentText = strArr[1...strArr.count - 1].joined(separator: " ")
                
                repository.updateItem(item: memoData, title: titleText, content: contentText, wholeText: text)
                //UserDefaultsManager.shared.checkFirstTapped()
                self.navigationController?.popViewController(animated: true)
                print(#function, "=============1 ????????????")
            } else if strArr.count == 1 && text != "" && text != " " && text != "\n" {
                let titleText = strArr[0]
                
                repository.updateItem(item: memoData, title: titleText, content: "?????? ??????", wholeText: text)
                //UserDefaultsManager.shared.checkFirstTapped()
                self.navigationController?.popViewController(animated: true)
                print(#function, "=============2 ????????????")
            } else {
                repository.deleteItem(item: memoData)
                //UserDefaultsManager.shared.checkFirstTapped()
                self.navigationController?.popViewController(animated: true)
                print(#function, "=============3 ????????????")
            }
        }
    }
    
    
}

extension WriteViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        let shareButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(shareButtonTapped))
        let doneButton = UIBarButtonItem(title: "??????", style: .plain, target: self, action: #selector(doneButtonTapped))
        navigationItem.rightBarButtonItems = [doneButton, shareButton]
        
    }
    
    
}




