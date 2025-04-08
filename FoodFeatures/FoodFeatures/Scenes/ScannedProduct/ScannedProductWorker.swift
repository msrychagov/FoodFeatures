//
//  ScannedProductWorker.swift
//  FoodFeatures
//
//  Created by Михаил Рычагов on 02.04.2025.
//

final class ScannedProductWorker: ScannedProductWorkerLogic {
    func loadProduct(barcode: String, completion: @escaping (Result<ScannedProductResponse, any Error>) -> Void) {
        ScanService().fetchScannedProduct(barcode: "4607177073088") { result in
            completion(result)}
    }
    
    
    //MARK: - Variables
    private let interactor: ScannedProductBuisnessLogic
    
    //MARK: - Lyfecycles
    init(interactor: ScannedProductBuisnessLogic) {
        self.interactor = interactor
    }
    
    
}
