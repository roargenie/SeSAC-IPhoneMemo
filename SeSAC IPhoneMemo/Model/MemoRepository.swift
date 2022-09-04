

import Foundation
import RealmSwift



protocol MemoListRepositoryType {
    func fetch() -> Results<MemoList>
    func fetchFilterTrue() -> Int
    func fetchFilterFalse() -> Int
    func fetchFilterTrueArr() -> Results<MemoList>
    func fetchFilterFalseArr() -> Results<MemoList>
    func titleSearchFilter(_ text: String) -> [MemoList]
    func addItem(item: MemoList)
    func deleteItem(item: MemoList)
    func updateItem(item: MemoList, title: String, content: String, wholeText: String)
    func checkBookMark(item: MemoList)
}

final class MemoListRepository: MemoListRepositoryType {
    
    let localRealm = try! Realm()
    
    func fetch() -> Results<MemoList> {
        return localRealm.objects(MemoList.self).sorted(byKeyPath: "regDate", ascending: true)
    }
    
    func fetchFilterTrue() -> Int {
        return localRealm.objects(MemoList.self).filter { data in
            data.bookMark == true
        }.count
    }
    
    func fetchFilterFalse() -> Int {
        return localRealm.objects(MemoList.self).filter { data in
            data.bookMark == false
        }.count
    }
    
    func fetchFilterTrueArr() -> Results<MemoList> {
        return localRealm.objects(MemoList.self).filter("bookMark == true")
    }
    
    func fetchFilterFalseArr() -> Results<MemoList> {
        return localRealm.objects(MemoList.self).filter("bookMark == false")
    }
    
    func titleSearchFilter(_ text: String) -> [MemoList] {
        return localRealm.objects(MemoList.self).filter { $0.title.localizedCaseInsensitiveContains(text) || $0.content.localizedCaseInsensitiveContains(text)}
    }
    
    func addItem(item: MemoList) {
        do {
            try localRealm.write {
                localRealm.add(item)
            }
        } catch {
            print("error")
        }
    }
    
    func deleteItem(item: MemoList) {
        do {
            try localRealm.write {
                localRealm.delete(item)
            }
        } catch {
            print("error")
        }
    }
    
    func updateItem(item: MemoList, title: String, content: String, wholeText: String) {
        do {
            try localRealm.write {
                item.title = title
                item.content = content
                item.wholeText = wholeText
                item.regDate = Date()
            }
        } catch {
            print("error")
        }
    }
    
    func checkBookMark(item: MemoList) {
        do {
            try localRealm.write {
                item.bookMark = !item.bookMark
            }
        } catch {
            print("error")
        }
    }
    
}





