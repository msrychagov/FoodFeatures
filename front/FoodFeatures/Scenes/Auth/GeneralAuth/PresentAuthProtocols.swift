//MARK: - BuisnessLogicProtocol
protocol GeneralAuthBuisnessLogic {
    func showChildController(request: GeneralAuthModels.ShowChildController.Request)
    func removeChildController(request: GeneralAuthModels.RemoveChildController.Request)
}

//MARK: - PresenterProtocol
protocol GeneralAuthPresenterLogic {
    func showChildController(response: GeneralAuthModels.ShowChildController.Response)
    func removeChildController(response: GeneralAuthModels.RemoveChildController.Response)
}

//MARK: - ViewProtocol
protocol GeneralAuthViewLogic: AnyObject {
    func showChildController(viewModel: GeneralAuthModels.ShowChildController.ViewModel)
    func removeChildController(viewModel: GeneralAuthModels.RemoveChildController.ViewModel)
}
