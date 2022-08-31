

import UIKit
import SnapKit

class MainViewController: BaseViewController {
    
    var mainView = MainView()
    
    let toolBar: UIToolbar = {
        let view = UIToolbar()
        view.backgroundColor = .systemGray
        
        return view
    }()
    
//    let writeToolbarItem: UIBarButtonItem = {
//        let view = UIBarButtonItem(barButtonSystemItem: .compose, target: MainViewController(), action: #selector(writeButtonTapped))
//        view.tintColor = .systemOrange
//        return view
//    }()
//
//    let flexibleSpaceItem: UIBarButtonItem = {
//        let view = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: MainViewController(), action: nil)
//        return view
//    }()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setToolbar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        let serchController = UISearchController(searchResultsController: nil)
        serchController.searchBar.placeholder = "검색"
        self.navigationItem.searchController = serchController
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
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.reuseIdentifier, for: indexPath) as? MainTableViewCell else { return UITableViewCell() }
        
        cell.backgroundColor = .systemGray4
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "sectionHeader") as? CustomHeaderView else { return UIView() }
        
        if section == 0 {
            view.titleLabel.text = "고정된 메모"
        } else {
            view.titleLabel.text = "메모"
        }
        
        return view
    }
    
}

