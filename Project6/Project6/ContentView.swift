//
//  ContentView.swift
//  Project6
//
//  Created by Niraj on 29/07/2020.
//  Copyright © 2020 Technomystic. All rights reserved.
//

import Combine
import SwiftUI

class Order: ObservableObject {

    static var types = ["Vanilla", "Strawberry", "Butterscotch", "Rainbow", "Chocolate"]

    @Published var type = 0
    @Published var quantity = 3

    @Published var isSpecialRequestEnabled = false

    @Published var extraFrosting = false
    @Published var addSprinkers = false

    @Published var name = ""
    @Published var streetAddress = ""
    @Published var city = ""
    @Published var zip = ""

    var isValid: Bool {
        if name.isEmpty || streetAddress.isEmpty || city.isEmpty || zip.isEmpty {
            return false
        }
        return true
    }

}

struct ContentView: View {
    @ObservedObject var order = Order()

    var body: some View {
        NavigationView {
            Form {
                Section {
                    Picker("Cupcake Selection", selection: $order.type) {
                        ForEach(0 ..< Order.types.count) {
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
                        Toggle(isOn: $order.addSprinkers) {
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
        }
    }

    func placeOrder() {
        //TODO
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
