

import UIKit
import SnapKit




class WalkThroughView: BaseView {
    
    let popupView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        return view
    }()
    
    let popupLabel: UILabel = {
        let view = UILabel()
        view.textColor = .label
        view.font = .systemFont(ofSize: 20, weight: .bold)
        view.numberOfLines = 0
        view.text = "처음 오셨군요!\n환영합니다:)\n\n당신만의 메모를 작성하고\n관리해보세요!"
        return view
    }()
    
    let doneButton: UIButton = {
        let view = UIButton()
        view.setTitle("확인", for: .normal)
        view.setTitleColor(UIColor.white, for: .normal)
        view.backgroundColor = .systemOrange
        view.layer.cornerRadius = 15
        return view
    }()
    
    lazy var stackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [popupLabel, doneButton])
        view.axis = .vertical
        view.alignment = .fill
        view.distribution = .fill
        view.spacing = 10
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureUI() {
        [popupView, stackView].forEach { self.addSubview($0) }
        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
    }
    
    override func setConstraints() {
        
        popupView.snp.makeConstraints { make in
            make.center.equalTo(self.snp.center)
            make.width.equalTo(self.snp.width).multipliedBy(0.75)
            make.height.equalTo(self.snp.height).multipliedBy(0.3)
        }
        
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(popupView.snp.edges).inset(30)
        }
        
        doneButton.snp.makeConstraints { make in
            make.height.equalTo(popupView.snp.height).multipliedBy(0.2)
        }
        
    }
    
}


