

import UIKit



class MainView: BaseView {
    
    let tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .insetGrouped)
        view.register(MainTableViewCell.self, forCellReuseIdentifier: MainTableViewCell.reuseIdentifier)
        view.register(CustomHeaderView.self, forHeaderFooterViewReuseIdentifier: "sectionHeader")
        view.backgroundColor = .black
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
    }
    
    override func setConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
        
    }
    
}
