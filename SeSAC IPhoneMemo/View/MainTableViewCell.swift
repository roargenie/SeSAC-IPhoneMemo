

import UIKit


class MainTableViewCell: BaseTableViewCell {
    
    let titleLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 15, weight: .bold)
        view.text = "dasfasfdaf"
        return view
    }()
    
    let dateLabel: UILabel = {
        let view = UILabel()
        view.text = "12345"
        return view
    }()
    
    let contentLabel: UILabel = {
        let view = UILabel()
        view.text = "asdfasdfasdfasdfasfd"
        return view
    }()
    
    lazy var stackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [dateLabel, contentLabel])
        view.axis = .horizontal
        view.alignment = .fill
        view.distribution = .fill
        view.spacing = 4
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureUI() {
        [titleLabel, stackView].forEach { self.contentView.addSubview($0) }
    }
    
    override func setConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top).offset(12)
            make.leading.equalTo(self.snp.leading).offset(12)
            make.trailing.lessThanOrEqualTo(self.snp.trailing).offset(-12)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.equalTo(self.snp.leading).offset(12)
            make.trailing.lessThanOrEqualTo(self.snp.trailing).offset(-12)
            make.bottom.equalTo(self.snp.bottom).offset(-12)
        }
    }
    
}

