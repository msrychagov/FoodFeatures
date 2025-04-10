import UIKit

final class GeneralAuthPresenter: GeneralAuthPresenterLogic {
    func showChildController(response: GeneralAuthModels.ShowChildController.Response) {
        guard let currentVC = view as? GeneralAuthViewController else { return }
        let children = currentVC.children
        let childVC = response.vc
        // Удаляем предыдущий child VC, если он есть
        if children.contains(childVC) {
            return // если уже показан, то ничего не делаем
        }
        
        // Снимаем старый
        for child in children {
            let viewModel = GeneralAuthModels.RemoveChildController.ViewModel(vc: child)
            view?.removeChildController(viewModel: viewModel)
        }
        
        // Добавляем новый
        currentVC.addChild(childVC)
        currentVC.showChildController(viewModel: .init(vc: childVC))
    }
    
    func removeChildController(response: GeneralAuthModels.RemoveChildController.Response) {
        let vc = response.vc
        vc.willMove(toParent: nil)
        vc.view.removeFromSuperview()
        vc.removeFromParent()
    }
    
    //MARK: - Constants
    enum Constants {
        
    }
    //MARK: Variables
    weak var view: GeneralAuthViewLogic?
    
    //MARK: - Methods
    
}
