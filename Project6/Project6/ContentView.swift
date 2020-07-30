//
//  ContentView.swift
//  Project6
//
//  Created by Niraj on 29/07/2020.
//  Copyright © 2020 Technomystic. All rights reserved.
//

import Combine
import SwiftUI

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

struct ContentView: View {
    @ObservedObject var order = Order()

    @State private var confirmationMessage = ""
    @State private var showingConfirmation = false

    

    var body: some View {
        NavigationView {
            Form {
                Section {
                    Picker("Cupcake Selection", selection: $order.type) {
                        ForEach(0 ..< Order.types.count, id: \.self) {
                            Text(Order.types[$0]).tag($0)
                        }
                    }

                    Stepper(value: $order.quantity, in: 3...20) {
                        Text("Number of cakes \(order.quantity)")
                    }
                }

                Section {

                    Toggle(isOn: $order.isSpecialRequestEnabled) {
                        Text("ANy Special request?")
                    }

                    if order.isSpecialRequestEnabled {
                        Toggle(isOn: $order.extraFrosting) {
                            Text("Add extra Frostring")
                        }
                        Toggle(isOn: $order.addSprinkles) {
                            Text("Add extra Sprinkers")
                        }
                    }
                }

                Section {
                    TextField("Name", text: $order.name)
                    TextField("Street Address", text: $order.streetAddress)
                    TextField("City", text: $order.city)
                    TextField("Zip", text: $order.zip)
                }

                Section {
                    Button(action: {
                        // Do soemthing
                        self.placeOrder()
                    }) {
                        Text("Place Order")
                    }
                }.disabled(!order.isValid)

            }
            .navigationBarTitle("Cupcake Corner")
            .alert(isPresented: $showingConfirmation) {
                Alert(title: Text("Thank you!"), message: Text(confirmationMessage), dismissButton: .default(Text("OK")))
            }
        }
    }

    func placeOrder() {
        guard let encoded = try? JSONEncoder().encode(order)
            else {
                print("Failed to Encode")
                return
        }

        let url = URL(string: "https://reqres.in/api/cupcakes")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = encoded

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print("No data is response: \(error?.localizedDescription ?? "Unknown error").")
                return
            }

            if let decodedOrder = try? JSONDecoder().decode(Order.self, from: data) {
                self.confirmationMessage = "Your order for \(decodedOrder.quantity)x \(Order.types[decodedOrder.type].lowercased()) cupcakes is on its way!"
                self.showingConfirmation = true
            } else {
                print("Invalid response from server")
            }
        }.resume()  // if resume is never called, the task will never start
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
