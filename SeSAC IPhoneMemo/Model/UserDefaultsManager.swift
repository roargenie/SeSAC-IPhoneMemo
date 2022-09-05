


import UIKit


final class UserDefaultsManager {
    
    static let shared = UserDefaultsManager()
    
    private let userDefualts = UserDefaults.standard
    
    static let isFirstRun = "FirstRun"
    static let isFirstTapped = "FirstTapped"
    static let isBackButtonTapped = "BackButtonTapped"
    
    func checkFirstRun() {
        
    }
    
    func checkFirstTapped() {
        if userDefualts.bool(forKey: UserDefaultsManager.isFirstTapped) == true {
            userDefualts.set(false, forKey: UserDefaultsManager.isFirstTapped)
            userDefualts.synchronize()
        } else {
            userDefualts.set(true, forKey: UserDefaultsManager.isFirstTapped)
            userDefualts.synchronize()
        }
    }
    
}
