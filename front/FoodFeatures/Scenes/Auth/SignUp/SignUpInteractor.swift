import UIKit

final class SignUpInteractor: SignUpBuisnessLogic {
    //MARK: - Constants
    enum Constants {
        
    }
    
    //MARK: Variables
    private let presenter: SignUpPresenterLogic
    private lazy var worker: SignUpWorker = SignUpWorker(interactor: self)
    private var userPreferences: [String] = []
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
                                     Preference(title: "Нет ограничений", isSelected: false)
    ]
    private var navigationController: UINavigationController?
    
    //MARK: - Lyfesycles
    init (presenter: SignUpPresenterLogic) {
        self.presenter = presenter
    }
    
    //MARK: Methods
    func fetchPreferences() {
        presenter.presentFetchedPreferences(response: SignUpModels.UpdatePrefernces.Response(preferences: preferences))
    }
    
    func updatePreferences(request: SignUpModels.UpdatePrefernces.Request) {
        var currentpPreferenceIndex = request.preferenceIndex
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
    
    func checkFields(request: SignUpModels.CheckFields.Request, completion: @escaping (Bool) -> Void) {
        completion(!request.name!.isEmpty && !request.email!.isEmpty && !request.password!.isEmpty && userPreferences.count != 0)
    }
    
    func showAlert(request: SignUpModels.ShowAlert.Request) {
        let response = SignUpModels.ShowAlert.Response(message: request.message)
        presenter.showAlert(response: response)
    }
    
    func signUp(request: SignUpModels.SignUp.Request) {
        worker.signUp(name: request.name, preferences: userPreferences, email: request.email, password: request.password) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let tokenResponse):
                    // Формируем Response, передаём токен
                    AuthManager.shared.saveToken(tokenResponse.access_token)
                    let response = SignUpModels.SignUp.Response(token: tokenResponse.access_token)
                    self?.presenter.presentSignUpSuccess(response: response)
                case .failure(let error):
                    self?.presenter.presentSignUpFailure(error: error)
                }
            }
        }
    }
    
    func setUpTabBar() {
        worker.setUpTabBar()
        presenter.dismissAuthViewController()
    }
}
