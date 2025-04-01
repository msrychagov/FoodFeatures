struct ScannedProductResponse: Decodable {
    let code: String?
    let product: ScannedProduct
}

struct ScannedProduct: Decodable {
    let product_name: String?
    let brands: String?
}
