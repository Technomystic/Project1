//
//  CheckoutView.swift
//  Project6
//
//  Created by Niraj on 31/07/2020.
//  Copyright © 2020 Technomystic. All rights reserved.
//

import SwiftUI
import Combine

struct CheckoutView: View {
    
    @ObservedObject var order: Order

    @State private var confirmationMessage = ""
    @State private var showingConfirmation = false

    var body: some View {

        GeometryReader{ geo in
            ScrollView {
                VStack {
                    Button("Check out") {
                        self.placeOrder()
                    }
                    .padding()
                }
            }
        }
        .navigationBarTitle("Check Out", displayMode: .inline)
        .alert(isPresented: $showingConfirmation) {
            Alert(title: Text("Thank you!"), message: Text(confirmationMessage), dismissButton: .default(Text("OK")))
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


struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        CheckoutView(order: Order())
    }
}
