//
//  AddressView.swift
//  Project6
//
//  Created by Niraj on 31/07/2020.
//  Copyright © 2020 Technomystic. All rights reserved.
//

import SwiftUI

struct AddressView: View {
    @ObservedObject var order: Order

    var body: some View {
        VStack {
                TextField("Name", text: $order.name)
                TextField("Street Address", text: $order.streetAddress)
                TextField("City", text: $order.city)
                TextField("Zip", text: $order.zip)
        }
    }
}

struct AddressView_Previews: PreviewProvider {
    static var previews: some View {
        AddressView(order: Order())
    }
}
