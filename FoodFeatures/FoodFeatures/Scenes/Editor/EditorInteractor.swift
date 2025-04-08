import Foundation

final class EditorInteractor: EditorBuisnessLogic {
    func saveChanges(request: EditorModels.SaveChanges.Request) {
        worker.saveChanges(name: request.name, email: request.email, preferences: userPreferences) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let updatedUser): // если worker возвращает обновлённого пользователя
                    NotificationCenter.default.post(name: Notification.Name("updateUserData"), object: updatedUser)
                    print("Крутяк")
                case .failure(let error):
                    print("minus vibe")
                }
            }
        }
    }

    
    func fetchPreferences() {
        presenter.fetchPreferences(response: EditorModels.FetchPreferences.Response(preferences: self.preferences))
    }
    
    func updatePreferences(request: EditorModels.UpdatePreferences.Request) {
        var currentpPreferenceIndex = request.chosenPreferenceIndex
        preferences[currentpPreferenceIndex].isSelected.toggle()
        
        if currentpPreferenceIndex == preferences.count - 1 {
            userPreferences.removeAll()
            
            for i in 0...preferences.count - 2 {
                if preferences[i].isSelected {
                    preferences[i].isSelected.toggle()
                    fetchPreferences()
                }
            }
        }
        
        else {
            if preferences[preferences.count - 1].isSelected {
                userPreferences.removeAll()
                preferences[preferences.count - 1].isSelected.toggle()
            }
        }
        
        if preferences[currentpPreferenceIndex].isSelected {
            userPreferences.append(preferences[currentpPreferenceIndex].title)
        } else {
            if let index = userPreferences.firstIndex(of: preferences[currentpPreferenceIndex].title) {
                userPreferences.remove(at: index)
            }
        }
        print(userPreferences)
        
        fetchPreferences()
    }
    
    func fetchUser() {
        presenter.fetchUser(response: EditorModels.FetchUser.Response(user: self.user))
    }
    
    //MARK: - Constants
    enum Constants {
        
    }
    
    //MARK: Variables
    lazy var worker: EditorWorkerLogic = EditorWorker(interactor: self)
    let presenter: EditorPresenterLogic
    private let user: User
    private var userPreferences: [String]
    private var preferences: [Preference] = [Preference(title: "Лактоза", isSelected: false),
                                     Preference(title: "Глютен", isSelected: false),
                                     Preference(title: "Орехи", isSelected: false),
                                     Preference(title: "Арахис", isSelected: false),
                                     Preference(title: "Сезам", isSelected: false),
                                     Preference(title: "Соя", isSelected: false),
                                     Preference(title: "Сельдерей", isSelected: false),
                                     Preference(title: "Горчица", isSelected: false),
                                     Preference(title: "Люпин", isSelected: false),
                                     Preference(title: "Рыба", isSelected: false),
                                     Preference(title: "Ракообразные", isSelected: false),
                                     Preference(title: "Моллюски", isSelected: false),
                                     Preference(title: "Нет ограничений", isSelected: false)]
    
    
    //MARK: - Lyfesycles
    init (presenter: EditorPresenterLogic, user: User) {
        self.presenter = presenter
        self.user = user
        self.userPreferences = user.preferences!
        setupPreferences()
    }
    
    private func setupPreferences() {
        for preferenceIndex in 0...preferences.count - 1 {
            for userPreferenceIndex in 0...userPreferences.count - 1 {
                if preferences[preferenceIndex].title == userPreferences[userPreferenceIndex] {
                    preferences[preferenceIndex].isSelected.toggle()
                }
            }
        }
    }
    
    //MARK: Methods
    
    
}
