//
//  FieldsParser.swift
//  FoodFeatures
//
//  Created by Михаил Рычагов on 04.04.2025.
//


final class FieldsParser {
    private let defaultTags: [String] = [
        "en:gluten",
        "en:milk",
        "en:eggs",
        "en:nuts",
        "en:sesame_seeds",
        "ensoybeans",
        "en:celery",
        "en:mustard",
        "en:lupin",
        "en:fish",
        "en:crustaceans",
        "en:molluscs",
    ]
    
    private let tagsDictionary: [String: String] = [
        "gluten":       "глютен",
        "milk":         "лактоза",
        "eggs":         "яйца",
        "nuts":         "орехи",
        "sesame_seeds": "кунжут",
        "soybeans":     "соя",
        "celery":       "сельдерей",
        "mustard":      "горчица",
        "lupin":        "люпин",
        "fish":         "рыба",
        "crustaceans":  "ракообразные",
        "molluscs":     "моллюски"
    ]
    
    
    
    func parseTags(tags: [String]) -> [String]{
        let unifiedTags = tags.map { tag -> String in
            let components = tag.split(separator: ":")
            guard components.count == 2 else {
                return tag
            }
            
            // Получаем язык и сам термин
            let lang = String(components[0])
            let text = String(components[1])
            
            switch lang {
                case "en":
                return tagsDictionary[text] ?? text
            default:
                return text
            }
        }
        return unifiedTags
    }
}
