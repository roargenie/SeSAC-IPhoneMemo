
import UIKit


class CustomHeaderView: UITableViewHeaderFooterView {
    
    let titleLabel: UILabel = {
        let view = UILabel()
        view.textColor = .white
        view.font = .systemFont(ofSize: 25, weight: .heavy)
        return view
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureUI()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        contentView.addSubview(titleLabel)
    }
    
    func setConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(16)
            make.leading.equalTo(contentView.snp.leading)
            make.trailing.equalTo(contentView.snp.trailing)
            make.bottom.equalTo(contentView.snp.bottom).offset(-16)
        }
    }
    
}


