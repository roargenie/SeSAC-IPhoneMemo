

import UIKit


class SearchResultsView: BaseView {
    
    let tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .insetGrouped)
        view.register(SearchResultTableViewCell.self, forCellReuseIdentifier: SearchResultTableViewCell.reuseIdentifier)
        view.register(CustomHeaderView.self, forHeaderFooterViewReuseIdentifier: "sectionHeader")
        view.backgroundColor = .systemBackground
        view.keyboardDismissMode = .onDrag
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureUI() {
        [tableView].forEach { self.addSubview($0) }
        self.backgroundColor = .systemBackground
    }
    
    override func setConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
        
    }
    
    
    
}










