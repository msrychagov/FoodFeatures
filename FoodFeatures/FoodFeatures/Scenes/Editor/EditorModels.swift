import UIKit

enum EditorModels {
    enum FetchUser {
        struct Response {
            var user: User
        }
        struct ViewModel {
            var name: String
            var email: String
            var features: [String]
        }
    }
    enum FetchPreferences {
        struct Response {
            var preferences: [Preference]
        }
        struct ViewModel {
            var preferences: [Preference]
        }
    }
    enum UpdatePreferences {
        struct Request {
            var chosenPreferenceIndex: Int
        }
    }
    enum SaveChanges {
        struct Request {
            var name: String
            var email: String
        }
    }
}

