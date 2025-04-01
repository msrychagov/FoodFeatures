//
//  ScanService.swift
//  FoodFeatures
//
//  Created by Михаил Рычагов on 01.04.2025.
//

import Foundation

final class ScanService {
    private let baseURL = "https://world.openfoodfacts.org/api/v3/product"
    func fetchScannedProduct(barcode: String, completion: @escaping (Result<ScannedProductResponse, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/\(barcode).json")
        else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                return
            }
            
            
            do {
                let decoder = JSONDecoder()
                let scannedProduct = try decoder.decode(ScannedProductResponse.self, from: data)
                completion(.success(scannedProduct))
            } catch {
                completion(.failure(error))
            }
            
        }
        task.resume()
    }
}
