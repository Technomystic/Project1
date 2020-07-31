//
//  Order.swift
//  Project6
//
//  Created by Niraj on 31/07/2020.
//  Copyright © 2020 Technomystic. All rights reserved.
//

import Foundation
import Combine

class Order: ObservableObject, Codable {

    enum CodingKeys: String, CodingKey {
        case type, quantity, specialRequestEnabled, extraFrosting, addSprinkles, name, streetAddress, city, zip
    }

    static var types = ["Vanilla", "Strawberry", "Butterscotch", "Rainbow", "Chocolate"]

    @Published var type = 0
    @Published var quantity = 3

    @Published var isSpecialRequestEnabled = false {
        didSet {
            extraFrosting = false
            addSprinkles = false
        }
    }

    @Published var extraFrosting = false
    @Published var addSprinkles = false

    @Published var name = ""
    @Published var streetAddress = ""
    @Published var city = ""
    @Published var zip = ""

    var isValid: Bool {
        if name.isEmpty || (name.trimmingCharacters(in: .whitespaces) == "") {
            return false
        } else if streetAddress.isEmpty || (streetAddress.trimmingCharacters(in: .whitespaces) == "") {
            return false
        } else if city.isEmpty || (city.trimmingCharacters(in: .whitespaces) == "") {
            return false
        } else if zip.isEmpty || (zip.trimmingCharacters(in: .whitespaces) == "") {
            return false
        }
        return true
    }

    var cost: Double {
        var cost = Double(quantity) * 2
        cost += (Double(type) / 2)
        if extraFrosting {
            cost += Double(quantity)
        }
        if addSprinkles {
            cost += Double(quantity) / 2
        }
        return cost
    }

    init() {}

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decode(Int.self, forKey: .type)
        quantity = try container.decode(Int.self, forKey: .quantity)
        extraFrosting = try container.decode(Bool.self, forKey: .extraFrosting)
        addSprinkles = try container.decode(Bool.self, forKey: .addSprinkles)
        name = try container.decode(String.self, forKey: .name)
        streetAddress = try container.decode(String.self, forKey: .streetAddress)
        city = try container.decode(String.self, forKey: .city)
        zip = try container.decode(String.self, forKey: .zip)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
        try container.encode(quantity, forKey: .quantity)
        try container.encode(extraFrosting, forKey: .extraFrosting)
        try container.encode(addSprinkles, forKey: .addSprinkles)
        try container.encode(streetAddress, forKey: .streetAddress)
        try container.encode(name, forKey: .name)
        try container.encode(city, forKey: .city)
        try container.encode(zip, forKey: .zip)
    }

}
