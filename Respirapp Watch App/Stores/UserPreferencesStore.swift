import SwiftUI
import Combine

class UserPreferencesStore: ObservableObject {
    
    static let shared = UserPreferencesStore()
    
    var isNotificationsEnabled: Bool {
        willSet {
            objectWillChange.send()
        }
        didSet {
            UserDefaults.standard.set(isNotificationsEnabled, forKey: "isNotificationsEnabled")
        }
    }
    
    var isHapticsEnabled: Bool {
        willSet {
            objectWillChange.send()
        }
        didSet {
            UserDefaults.standard.set(isHapticsEnabled, forKey: "isHapticsEnabled")
        }
    }
    
    var hasCompletedOnboarding: Bool {
        willSet {
            objectWillChange.send()
        }
        didSet {
            UserDefaults.standard.set(hasCompletedOnboarding, forKey: "hasCompletedOnboarding")
        }
    }
    
    private init() {

        UserDefaults.standard.register(defaults: [
            "isNotificationsEnabled": true,
            "isHapticsEnabled": true,
            "hasCompletedOnboarding": false
        ])
        
        self.isNotificationsEnabled = UserDefaults.standard.bool(forKey: "isNotificationsEnabled")
        self.isHapticsEnabled = UserDefaults.standard.bool(forKey: "isHapticsEnabled")
        self.hasCompletedOnboarding = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
    }
}
