//
//  ContentView.swift
//  Project1WeatherApp
//
//  Created by Niraj on 26/07/2020.
//  Copyright © 2020 Technomystic. All rights reserved.
//

import Combine
import SwiftUI


class DataSource: ObservableObject {
    let didChange = PassthroughSubject<Void, Never>()
    var pictures: [String] = [String]()

    init() {
        let fm = FileManager.default

        if let path = Bundle.main.resourcePath, let items = try? fm.contentsOfDirectory(atPath: path) {
            for item in items {
                if item.hasPrefix("nssl") {
                    pictures.append(item)
                }
            }
        }
        didChange.send(())
    }

}

struct DetailView: View {
    @State private var hideNavigationBar = false
    var selectedImage: String

    var body: some View {
        let img = UIImage(named: selectedImage)!
        return Image(uiImage: img)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .navigationBarTitle(Text(selectedImage), displayMode: .inline)
        .navigationBarHidden(hideNavigationBar)
            .onTapGesture {
                self.hideNavigationBar.toggle()
        }
    }

}

struct ContentView: View {
    @ObservedObject var dataSource = DataSource()

    var body: some View {
        NavigationView {
            List(dataSource.pictures, id: \.self) { picture in
                NavigationLink(destination: DetailView(selectedImage: picture)) {
                    Text(picture)
                }
            }.navigationBarTitle(Text("Storm Viewer"))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
