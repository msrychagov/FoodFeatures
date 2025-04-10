//MARK: - BuisnessLogicProtocol
protocol EditorBuisnessLogic {
    func fetchUser()
    func fetchPreferences()
    func updatePreferences(request: EditorModels.UpdatePreferences.Request)
    func saveChanges(request: EditorModels.SaveChanges.Request)
}

//MARK: - PresenterProtocol
protocol EditorPresenterLogic {
    func fetchUser(response: EditorModels.FetchUser.Response)
    func fetchPreferences(response: EditorModels.FetchPreferences.Response)
}

//MARK: - WorkerProtocol
protocol EditorWorkerLogic {
    func saveChanges(name: String, email: String, preferences: [String], completion: @escaping (Result<User, Error>) -> Void)
}

//MARK: - ViewProtocol
protocol EditorViewLogic: AnyObject {
    func setUserValues(viewModel: EditorModels.FetchUser.ViewModel)
    func displayPreferences(viewModel: EditorModels.FetchPreferences.ViewModel)
}
