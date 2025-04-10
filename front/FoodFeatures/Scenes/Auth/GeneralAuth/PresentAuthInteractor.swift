final class GeneralAuthInteractor: GeneralAuthBuisnessLogic {
    func showChildController(request: GeneralAuthModels.ShowChildController.Request) {
        let response = GeneralAuthModels.ShowChildController.Response(vc: request.vc)
        presenter.showChildController(response: response)
    }
    
    func removeChildController(request: GeneralAuthModels.RemoveChildController.Request) {
        let response = GeneralAuthModels.RemoveChildController.Response(vc: request.vc)
        presenter.removeChildController(response: response)
    }
    
    //MARK: - Constants
    enum Constants {
        
    }
    
    //MARK: Variables
    let presenter: GeneralAuthPresenterLogic
    
    //MARK: - Lyfesycles
    init (presenter: GeneralAuthPresenterLogic) {
        self.presenter = presenter
    }
    
    //MARK: Methods
    
    
}
