//
//  ContentView.swift
//  Project6
//
//  Created by Niraj on 29/07/2020.
//  Copyright © 2020 Technomystic. All rights reserved.
//

import Combine
import SwiftUI

struct ContentView: View {
    @ObservedObject var order = Order()

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
                    AddressView(order: order)
                }

                Section {
                    CheckoutView(order: order)
                }.disabled(!order.isValid)

            }
            .navigationBarTitle("Cupcake Corner")
            }
        }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
