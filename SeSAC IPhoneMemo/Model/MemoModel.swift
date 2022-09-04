

import Foundation
import RealmSwift



final class MemoList: Object {
    
    @Persisted var title: String
    @Persisted var content: String
    @Persisted var wholeText: String
    @Persisted var regDate = Date()
    @Persisted var bookMark: Bool
    
    @Persisted(primaryKey: true) var objectId: ObjectId
    
    convenience init(title: String, content: String, wholeText: String, regDate: Date) {
        self.init()
        self.title = title
        self.content = content
        self.wholeText = wholeText
        self.regDate = regDate
        self.bookMark = false
    }
    
}
