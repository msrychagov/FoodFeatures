struct ScannedProductResponse: Decodable {
    let code: String?
    var product: ScannedProduct
}

struct ScannedProduct: Decodable {
    let product_name: String?
    let brands: String?
    var allergens_tags: [String]?
    var traces_tags: [String]?
}


