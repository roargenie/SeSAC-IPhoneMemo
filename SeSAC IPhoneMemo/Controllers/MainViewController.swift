

import UIKit
import RealmSwift
import SnapKit





final class MainViewController: BaseViewController {
    
    var mainView = MainView()
    
    let searchResultVC = SearchResultsViewController()
    
    var tutorialVC: WalkThroughViewController = {
        let view = WalkThroughViewController()
        
        return view
    }()
    
    let toolBar: UIToolbar = {
        let view = UIToolbar()
        view.backgroundColor = .systemGroupedBackground
        return view
    }()

    var filterText: String = ""
    
    let repository = MemoListRepository()
    
    var tasks: Results<MemoList>! {
        didSet {
            mainView.tableView.reloadData()
            self.navigationItem.title = "\(tasks.count)개의 메모"
        }
    }
    
    
    // MARK: - 검색필터 프로퍼티
    
    var filteredArr: [MemoList] = []
    
    var isFiltering: Bool {
        let searchController = self.navigationItem.searchController
        let isActive = searchController?.isActive ?? false
        let isSearchBarHasText = searchController?.searchBar.text?.isEmpty == false
        return isActive && isSearchBarHasText
    }
    
    // MARK: - 뷰 생명주기
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setToolbar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.navigationController?.navigationBar.prefersLargeTitles = true
        fetchRealm()
        mainView.tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //fetchRealm()
    }
    
    
    // MARK: - UI
    
    override func configureUI() {
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        mainView.tableView.rowHeight = 65
        mainView.addSubview(toolBar)
        searchResultVC.mainView.tableView.delegate = self
        searchResultVC.mainView.tableView.dataSource = self
        searchResultVC.mainView.tableView.rowHeight = 65
    }
    
    override func setConstraints() {
        toolBar.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(mainView.safeAreaLayoutGuide)
        }
    }
    
    override func setNavigationBar() {
        
        self.navigationController?.navigationBar.backgroundColor = .systemBackground
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.prefersLargeTitles = true
        let searchController = UISearchController(searchResultsController: searchResultVC)
        searchController.delegate = self
        
        searchController.searchBar.placeholder = "검색"
        searchController.searchBar.tintColor = .systemOrange
        searchController.searchBar.setValue("취소", forKey: "cancelButtonText")
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchResultsUpdater = self
        
        self.navigationItem.searchController = searchController
    }
    
    func fetchRealm() {
        tasks = repository.fetch()
    }
    
    func setToolbar() {
        let write = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(writeButtonTapped))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        write.tintColor = .systemOrange
        toolBar.setItems([flexible, write], animated: true)
    }
    
    func numberFormatter(_ number: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(for: number)!
    }
    
    @objc func writeButtonTapped() {
        UserDefaults.standard.set(true, forKey: UserDefaultsManager.isBackButtonTapped)
        UserDefaults.standard.set(true, forKey: UserDefaultsManager.isFirstTapped)
        UserDefaults.standard.synchronize()
        print(UserDefaults.standard.bool(forKey: "FirstTapped"))
        let vc = WriteViewController()
        vc.mainView.textView.becomeFirstResponder()
        transition(vc)
    }
    
    func isFirstRun() {
        let userDefaults = UserDefaults.standard
        if userDefaults.bool(forKey: UserDefaultsManager.isFirstRun) == false {
            tutorialVC.modalPresentationStyle = .overCurrentContext
            self.present(tutorialVC, animated: false)
        }
    }
    
    func changeFilterdTextColor(_ string: String) -> NSMutableAttributedString {
        let labelText = (string.lowercased() as NSString).range(of: filterText.lowercased())
        let attributedString = NSMutableAttributedString.init(string: string)
        attributedString.addAttribute(.foregroundColor, value: UIColor.systemOrange, range: labelText)
        return attributedString
    }
    
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - 섹션 갯수
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if tableView == mainView.tableView {
            return repository.fetchFilterTrue() > 0 ? 2 : 1
        } else {
            return 1
        }
        
    }
    
    // MARK: - 섹션당 행 갯수
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == mainView.tableView {
            if repository.fetchFilterTrue() > 0 {
                if section == 0 {
                    return repository.fetchFilterTrue()
                } else {
                    return repository.fetchFilterFalse()
                }
            } else {
                return tasks.count
            }
        } else {
            return searchResultVC.tasks.count
        }
        
    }
    
    // MARK: - 셀에 데이터 표현
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == mainView.tableView {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.reuseIdentifier, for: indexPath) as? MainTableViewCell else { return UITableViewCell() }
            
            if repository.fetchFilterTrue() > 0 {
                switch indexPath.section {
                case 0:
                    let data = repository.fetchFilterTrueArr()[indexPath.row]
                    
                    cell.titleLabel.text = data.title
                    cell.contentLabel.text = data.content
                    cell.dateLabel.text = Date.dateChecking(data.regDate)()
                case 1:
                    let data = repository.fetchFilterFalseArr()[indexPath.row]
                    
                    cell.titleLabel.text = data.title
                    cell.contentLabel.text = data.content
                    cell.dateLabel.text = Date.dateChecking(data.regDate)()
                default:
                    break
                }
            } else {
                switch indexPath.section {
                case 0:
                    let data = repository.fetchFilterFalseArr()[indexPath.row]
                    
                    cell.titleLabel.text = data.title
                    cell.contentLabel.text = data.content
                    cell.dateLabel.text = Date.dateChecking(data.regDate)()
                default:
                    break
                }
            }
            return cell
            
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultTableViewCell.reuseIdentifier, for: indexPath) as? SearchResultTableViewCell else { return UITableViewCell() }
            
            let data = searchResultVC.tasks[indexPath.row]
            print(data)
            cell.titleLabel.attributedText = changeFilterdTextColor(data.title)
            cell.contentLabel.attributedText = changeFilterdTextColor(data.content)
//            cell.titleLabel.text = data.title
//            cell.contentLabel.text = data.content
            cell.dateLabel.text = data.regDate.dateChecking()
            return cell
        }
        
    }
    
    // MARK: - 셀 클릭시 작성/수정
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //guard let cell = tableView.cellForRow(at: indexPath) as? MainTableViewCell else { return }
        let vc = WriteViewController()
        UserDefaults.standard.set(false, forKey: UserDefaultsManager.isFirstTapped)
        UserDefaults.standard.set(true, forKey: UserDefaultsManager.isBackButtonTapped)
        print(UserDefaults.standard.bool(forKey: UserDefaultsManager.isFirstTapped))
        if self.isFiltering == true {
            let data = searchResultVC.tasks[indexPath.row]
            self.navigationItem.backButtonTitle = "검색"
            vc.memoData = data
        } else {
            if repository.fetchFilterTrue() > 0 {
                switch indexPath.section {
                case 0:
                    let data = repository.fetchFilterTrueArr()[indexPath.row]
                    self.navigationItem.backButtonTitle = "메모"
                    vc.memoData = data
                case 1:
                    let data = repository.fetchFilterFalseArr()[indexPath.row]
                    self.navigationItem.backButtonTitle = "메모"
                    vc.memoData = data
                default:
                    break
                }
            } else {
                switch indexPath.section {
                case 0:
                    let data = repository.fetchFilterFalseArr()[indexPath.row]
                    self.navigationItem.backButtonTitle = "메모"
                    vc.memoData = data
                default:
                    break
                }
            }
        }
        transition(vc)
        
    }
    
    // MARK: - 핀 고정
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        if tableView == mainView.tableView {
            if repository.fetchFilterTrue() > 0 {
                switch indexPath.section {
                case 0:
                    let data = repository.fetchFilterTrueArr()[indexPath.row]
                    
                    let action = UIContextualAction(style: .normal, title: "") { action, view, completion in
                        self.repository.checkBookMark(item: data)
                        self.fetchRealm()
                    }
                    let image = data.bookMark ? "pin.slash.fill" : "pin.fill"
                    action.image = UIImage(systemName: image)
                    action.backgroundColor = .systemOrange
                    
                    return UISwipeActionsConfiguration(actions: [action])
                case 1:
                    let data = repository.fetchFilterFalseArr()[indexPath.row]
                    
                    let action = UIContextualAction(style: .normal, title: "") { action, view, completion in
                        
                        if self.repository.fetchFilterTrue() > 4 {
                            self.showAlertMessage(title: "즐겨찾기는 5개 이상 할 수 없습니다.", button: "확인")
                        } else {
                            self.repository.checkBookMark(item: data)
                            self.fetchRealm()
                        }
                    }
                    let image = data.bookMark ? "pin.slash.fill" : "pin.fill"
                    action.image = UIImage(systemName: image)
                    action.backgroundColor = .systemOrange
                    
                    return UISwipeActionsConfiguration(actions: [action])
                default:
                    break
                }
            } else if repository.fetchFilterTrue() == 0 {
                switch indexPath.section {
                case 0:
                    let data = repository.fetchFilterFalseArr()[indexPath.row]
                    
                    let action = UIContextualAction(style: .normal, title: "") { action, view, completion in
                        self.repository.checkBookMark(item: data)
                        self.fetchRealm()
                    }
                    let image = data.bookMark ? "pin.slash.fill" : "pin.fill"
                    action.image = UIImage(systemName: image)
                    action.backgroundColor = .systemOrange
                    
                    return UISwipeActionsConfiguration(actions: [action])
                default:
                    break
                }
            }

        } else {
            switch indexPath.section {
            case 0:
                let data = searchResultVC.tasks[indexPath.row]
                
                let action = UIContextualAction(style: .normal, title: "") { action, view, completion in
                    
                    if self.repository.fetchFilterTrue() > 4 {
                        self.showAlertMessage(title: "즐겨찾기는 5개 이상 할 수 없습니다.", button: "확인")
                    } else {
                        self.repository.checkBookMark(item: data)
                        self.searchResultVC.fetchRealm()
                        self.fetchRealm()
                    }
                }
                let image = data.bookMark ? "pin.slash.fill" : "pin.fill"
                action.image = UIImage(systemName: image)
                action.backgroundColor = .systemOrange
                return UISwipeActionsConfiguration(actions: [action])
            default:
                break
            }
        }
        
        return UISwipeActionsConfiguration(actions: [])
    }
    
    // MARK: - 삭제
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        if tableView == mainView.tableView {
            if repository.fetchFilterTrue() > 0 {
                switch indexPath.section {
                case 0:
                    let data = repository.fetchFilterTrueArr()[indexPath.row]
                    
                    let action = UIContextualAction(style: .normal, title: "") { action, view, completion in
                        self.showAlertMessageWithCancel(title: "삭제 하시겠습니까?", button: "확인") { action in
                            self.repository.deleteItem(item: data)
                            self.fetchRealm()
                        }
                    }
                    action.image = UIImage(systemName: "trash.fill")
                    action.backgroundColor = .systemRed
                    
                    return UISwipeActionsConfiguration(actions: [action])
                case 1:
                    let data = repository.fetchFilterFalseArr()[indexPath.row]
                    
                    let action = UIContextualAction(style: .normal, title: "") { action, view, completion in
                        self.showAlertMessageWithCancel(title: "삭제 하시겠습니까?", button: "확인") { action in
                            self.repository.deleteItem(item: data)
                            self.fetchRealm()
                        }
                    }
                    action.image = UIImage(systemName: "trash.fill")
                    action.backgroundColor = .systemRed
                    
                    return UISwipeActionsConfiguration(actions: [action])
                default:
                    break
                }
            } else if repository.fetchFilterTrue() == 0 {
                switch indexPath.section {
                case 0:
                    let data = repository.fetchFilterFalseArr()[indexPath.row]
                    
                    let action = UIContextualAction(style: .normal, title: "") { action, view, completion in
                        self.showAlertMessageWithCancel(title: "삭제 하시겠습니까?", button: "확인") { action in
                            self.repository.deleteItem(item: data)
                            self.fetchRealm()
                        }
                    }
                    action.image = UIImage(systemName: "trash.fill")
                    action.backgroundColor = .systemRed
                    
                    return UISwipeActionsConfiguration(actions: [action])
                default:
                    break
                }
            }
        } else {
            switch indexPath.section {
            case 0:
                let data = searchResultVC.tasks[indexPath.row]
                
                let action = UIContextualAction(style: .normal, title: "") { action, view, completion in
                    self.showAlertMessageWithCancel(title: "삭제 하시겠습니까?", button: "확인") { action in
                        self.repository.deleteItem(item: data)
                        self.searchResultVC.fetchRealm()
                        self.fetchRealm()
                    }
                }
                action.image = UIImage(systemName: "trash.fill")
                action.backgroundColor = .systemRed
                
                return UISwipeActionsConfiguration(actions: [action])
            default:
                break
            }
        }
        
        return UISwipeActionsConfiguration(actions: [])
    }
    
    // MARK: - 섹션별 헤더 표현
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "sectionHeader") as? CustomHeaderView else { return UIView() }
        
        if tableView == mainView.tableView {
            if repository.fetchFilterTrue() > 0 {
                switch section {
                case 0:
                    view.titleLabel.text = "고정된 메모"
                case 1:
                    view.titleLabel.text = "메모"
                default:
                    break
                }
            } else if repository.fetchFilterTrue() == 0 {
                view.titleLabel.text = "메모"
            }
        } else {
            view.titleLabel.text = "\(searchResultVC.tasks.count)개의 검색된 메모"
        }
        
        return view
    }
    
    
}

    // MARK: - SearchController 조건식 및 업데이트 프로토콜

extension MainViewController: UISearchResultsUpdating, UISearchControllerDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text?.lowercased() else { return }
        filterText = text
        
        searchResultVC.tasks = repository.fetchSearchResult(text: text)
        searchResultVC.mainView.tableView.reloadData()
    }
    
}
