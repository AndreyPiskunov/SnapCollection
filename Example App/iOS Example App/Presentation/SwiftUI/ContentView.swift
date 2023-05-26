// MIT License
//
// Copyright (c) 2023 Ivan Izyumkin
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import SwiftUI
import SnapCollection

@available(iOS 13.0, *)
struct ContentView: View {
    @State var items = [Int](0...100)
    @State private var firstCurrentSelectedCellIndex: Int = 0
    @State private var secondCurrentSelectedCellIndex: Int = 0
    @State private var thirdCurrentSelectedCellIndex: Int = 0

    var body: some View {
        VStack(spacing: 40) {
            Text("First collection index \(firstCurrentSelectedCellIndex)")
            SnapCollection(
                items: items,
                itemSize: CGSize(width: 50, height: 50),
                currentSelectedCellIndex: $firstCurrentSelectedCellIndex,
                scrollDirection: .horizontal,
                spacing: 10.0,
                cell: { indexPath, item in
                    Button(action: shuffle) {
                        Text(String(item))
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .foregroundColor(.white)
                            .background(Color.blue)
                    }
                })
            .frame(maxWidth: .infinity, maxHeight: 50)
            Text("Second collection index \(secondCurrentSelectedCellIndex)")
            SnapNumbersPicker(
                range: 0...100,
                itemSize: CGSize(width: 73, height: 76),
                scrollDirection: .horizontal,
                currentSelectedCellIndex: $secondCurrentSelectedCellIndex,
                animationSettings: .init(
                    type: .onlyCenter,
                    maxScale: 1.4,
                    minScale: 1.0,
                    maxAlpha: 1.0,
                    minAlpha: 0.35
                ),
                spacing: 10.0
            )
            .frame(maxWidth: .infinity, maxHeight: 76)
            Text("Third collection index \(thirdCurrentSelectedCellIndex)")
            SnapRoulettePicker(
                range: 50...250,
                step: 5,
                scrollDirection: .horizontal,
                currentSelectedCellIndex: $thirdCurrentSelectedCellIndex,
                spacing: 14.0
            )
            .frame(maxWidth: .infinity, maxHeight: 76)
        }
    }

    private func shuffle() {
        items.shuffle()
    }
}

@available(iOS 13.0, *)
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
