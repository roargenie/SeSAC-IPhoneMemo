

import UIKit


class WriteView: BaseView {
    
    let textView: UITextView = {
        let view = UITextView()
        view.textContainerInset = UIEdgeInsets(top: 25, left: 25, bottom: 25, right: 25)
        view.backgroundColor = .black
        view.textColor = .white
        view.font = .systemFont(ofSize: 18, weight: .bold)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureUI() {
        [textView].forEach { self.addSubview($0) }
    }
    
    override func setConstraints() {
        textView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
    }
    
}





