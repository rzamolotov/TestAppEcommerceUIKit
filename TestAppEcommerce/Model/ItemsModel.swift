//
//  ItemsModel.swift
//  TestAppEcommerce
//
//  Created by Роман Замолотов on 22.06.2023.
//

import Foundation

struct Product: Identifiable {
    var id: UUID
    var title: String
    var size: [String]
    var price_photo: Int
    var description: String
    var link: String
    var image_link: [String]
    var category: [String]
}

extension Product: Decodable {
    enum CodingKeys: String, CodingKey {
        case id, title, size, price_photo, description, link, image_link, category
    }
}
