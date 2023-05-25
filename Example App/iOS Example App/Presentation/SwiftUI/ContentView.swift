//
//  ContentView.swift
//  iOS Example App
//
//  Created by Иван Изюмкин on 24.05.2023.
//

import SwiftUI
import SnapCollection

@available(iOS 13.0, *)
struct ContentView: View {
    @State var items = [Int](0...100)
    
    private func shuffle() {
        items.shuffle()
    }
    
    var body: some View {
        VStack {
            SnapCollection(items: items, itemSize: CGSize(width: 50, height: 50), scrollDirection: .vertical, cell: { indexPath, item in
                GeometryReader { geometry in
                    Button(action: shuffle) {
                        Text(String(item))
                            .foregroundColor(.black)
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .background(Color.blue)
                    }
                }
            })
            .frame(maxWidth: 50, maxHeight: .infinity)
        }
    }
}

@available(iOS 13.0, *)
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
