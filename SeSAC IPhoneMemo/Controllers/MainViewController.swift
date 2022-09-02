

import UIKit
import RealmSwift
import SnapKit

class MainViewController: BaseViewController {
    
    var mainView = MainView()
    
    let toolBar: UIToolbar = {
        let view = UIToolbar()
        view.backgroundColor = .systemGroupedBackground
        return view
    }()
    
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateStyle = .medium
        return formatter
    }()
    
    let repository = MemoListRepository()
    
    var tasks: Results<MemoList>! {
        didSet {
            mainView.tableView.reloadData()
        }
    }
    
    var filteredArr: [MemoList] = []
    
    var isFiltering: Bool {
        let searchController = self.navigationItem.searchController
        let isActive = searchController?.isActive ?? false
        let isSearchBarHasText = searchController?.searchBar.text?.isEmpty == false
        return isActive && isSearchBarHasText
    }
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setToolbar()
        setSearchController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchRealm()
    }
    
    override func configureUI() {
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        mainView.tableView.rowHeight = 70
        mainView.addSubview(toolBar)
    }
    
    override func setConstraints() {
        toolBar.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(mainView.safeAreaLayoutGuide)
        }
    }
    
    override func setNavigationBar() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "메모"
        self.navigationItem.titleView?.tintColor = .systemBackground
    }
    
    func setSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "검색"
        searchController.searchBar.tintColor = .systemOrange
        
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchResultsUpdater = self
        //searchController.delegate = self
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
    
    @objc func writeButtonTapped() {
        let vc = WriteViewController()
        transition(vc)
    }
    
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.isFiltering == true {
            return 1
        } else {
            return repository.fetchFilterTrue() > 0 ? 2 : 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.isFiltering == true {
            return self.filteredArr.count
        } else {
            if repository.fetchFilterTrue() > 0 {
                switch section {
                case 0:
                    return repository.fetchFilterTrue()
                case 1:
                    return repository.fetchFilterFalse()
                default:
                    break
                }
            }
        }
        
        return repository.fetchFilterFalse()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.reuseIdentifier, for: indexPath) as? MainTableViewCell else { return UITableViewCell() }
        
        if self.isFiltering == true {
            let data = filteredArr[indexPath.row]
            cell.titleLabel.text = data.title
            cell.contentLabel.text = data.content
            cell.dateLabel.text = formatter.string(from: data.regDate)
        } else {
            if repository.fetchFilterTrue() > 0 {
                switch indexPath.section {
                case 0:
                    let data = repository.fetchFilterTrueArr()[indexPath.row]
                    
                    cell.titleLabel.text = data.title
                    cell.contentLabel.text = data.content
                    cell.dateLabel.text = formatter.string(from: data.regDate)
                case 1:
                    let data = repository.fetchFilterFalseArr()[indexPath.row]
                    
                    cell.titleLabel.text = data.title
                    cell.contentLabel.text = data.content
                    cell.dateLabel.text = formatter.string(from: data.regDate)
                default:
                    break
                }
            } else {
                switch indexPath.section {
                case 0:
                    let data = repository.fetchFilterFalseArr()[indexPath.row]
                    
                    cell.titleLabel.text = data.title
                    cell.contentLabel.text = data.content
                    cell.dateLabel.text = formatter.string(from: data.regDate)
                default:
                    break
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        if self.isFiltering == true {
            let data = filteredArr[indexPath.row]
            
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
        } else {
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
        }
        
        return UISwipeActionsConfiguration(actions: [])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        if self.isFiltering == true {
            let data = filteredArr[indexPath.row]
            
            let action = UIContextualAction(style: .normal, title: "") { action, view, completion in
                self.repository.deleteItem(item: data)
                self.fetchRealm()
            }
            action.image = UIImage(systemName: "trash.fill")
            action.backgroundColor = .systemRed
            
            return UISwipeActionsConfiguration(actions: [action])
        } else {
            if repository.fetchFilterTrue() > 0 {
                switch indexPath.section {
                case 0:
                    let data = repository.fetchFilterTrueArr()[indexPath.row]
                    
                    let action = UIContextualAction(style: .normal, title: "") { action, view, completion in
                        self.repository.deleteItem(item: data)
                        self.fetchRealm()
                    }
                    action.image = UIImage(systemName: "trash.fill")
                    action.backgroundColor = .systemRed
                    
                    return UISwipeActionsConfiguration(actions: [action])
                case 1:
                    let data = repository.fetchFilterFalseArr()[indexPath.row]
                    
                    let action = UIContextualAction(style: .normal, title: "") { action, view, completion in
                        self.repository.deleteItem(item: data)
                        self.fetchRealm()
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
                        self.repository.deleteItem(item: data)
                        self.fetchRealm()
                    }
                    action.image = UIImage(systemName: "trash.fill")
                    action.backgroundColor = .systemRed
                    
                    return UISwipeActionsConfiguration(actions: [action])
                default:
                    break
                }
            }
        }
        
        return UISwipeActionsConfiguration(actions: [])
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "sectionHeader") as? CustomHeaderView else { return UIView() }
        if self.isFiltering == true {
            view.titleLabel.text = "검색된 메모"
        } else {
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
        }
        
        return view
    }
    
}

extension MainViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text?.lowercased() else { return }
        
        self.filteredArr = repository.titleSearchFilter(text)
        fetchRealm()
//        print(filteredArr)
//        dump(text)
    }
    
}
