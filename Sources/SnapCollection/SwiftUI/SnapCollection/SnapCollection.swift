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

public struct CollectionRow<Section: Hashable, Item: Hashable>: Hashable {
    let section: Section
    let items: [Item]
    
    public init(section: Section, items: [Item]) {
        self.section = section
        self.items = items
    }
}

@available(iOS 13.0, *)
public struct SnapCollection<Item: Hashable, Cell: View>: UIViewRepresentable {
    
    public class Coordinator: NSObject, SnapCollectionViewDelegate {
        
        // MARK: - Types
        
        fileprivate typealias DataSource = UICollectionViewDiffableDataSource<Int, Item>
        
        // MARK: - Private Properties
        
        fileprivate var dataSource: DataSource? = nil

        private let collection: SnapCollection
        
        // MARK: - Initializers
        
        init(_ collection: SnapCollection) {
            self.collection = collection
        }
        
        // MARK: - SnapCollectionViewDelegate
        
        public func didSelectItem(at index: Int) {
            collection.currentSelectedCellIndex = index
        }
    }
    
    // MARK: - Public Properties
    
    /// An array of data that will be displayed in the cells of the collection.
    ///
    /// Array elements must comply with the `Hashable` protocol.
    let items: [Item]
    /// The scroll direction of the grid.
    let scrollDirection: UICollectionView.ScrollDirection
    /// The default size to use for cells.
    let itemSize: CGSize
    /// The spacing to use between items.
    let spacing: CGFloat?
    /// The intensity of tactile feedback during the scroll collection.
    let feedbackIntensity: CGFloat?
    /// Tactile feedback style during collection scrolling.
    let feedBackGeneratorStyle: UIImpactFeedbackGenerator.FeedbackStyle?
    /// A cell for a specific `IndexPath` and `Item`.
    let cell: (IndexPath, Item) -> Cell
    /// The observed value that is responsible for the index of the current central element.
    @Binding var currentSelectedCellIndex: Int
    
    // MARK: - Initializers
    
    public init(
        items: [Item],
        itemSize: CGSize,
        currentSelectedCellIndex: Binding<Int>,
        scrollDirection: UICollectionView.ScrollDirection,
        spacing: CGFloat? = nil,
        feedbackIntensity: CGFloat? = nil,
        feedBackGeneratorStyle: UIImpactFeedbackGenerator.FeedbackStyle? = nil,
        @ViewBuilder cell: @escaping (IndexPath, Item) -> Cell
    ) {
        self.items = items
        self.itemSize = itemSize
        self._currentSelectedCellIndex = currentSelectedCellIndex
        self.scrollDirection = scrollDirection
        self.spacing = spacing
        self.feedbackIntensity = feedbackIntensity
        self.feedBackGeneratorStyle = feedBackGeneratorStyle
        self.cell = cell
    }
    
    // MARK: - Public Methods
    
    public func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    public func makeUIView(context: Context) -> UICollectionView {
        let cellIdentifier = String(describing: HostCell.self)
        let collectionView = SnapCollectionView()
        collectionView.pickerDelegate = context.coordinator
        collectionView.scrollDirection = scrollDirection
        collectionView.itemSize = itemSize
        collectionView.spacing = spacing ?? 0.0
        collectionView.feedbackIntensity = feedbackIntensity ?? 0.7
        collectionView.feedBackGeneratorStyle = feedBackGeneratorStyle ?? .soft
        collectionView.register(HostCell.self, forCellWithReuseIdentifier: cellIdentifier)
        
        let dataSource = Coordinator.DataSource(collectionView: collectionView) { collectionView, indexPath, item in
            let hostCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? HostCell
            hostCell?.hostedCell = cell(indexPath, item)
            return hostCell
        }
        context.coordinator.dataSource = dataSource
        
        reloadData(in: collectionView, context: context)
        return collectionView
    }
    
    public func updateUIView(_ collection: UICollectionView, context: Context) {
        reloadData(in: collection, context: context, animated: true)
    }
    
    // MARK: - Private Methods
    
    private func snapshot() -> NSDiffableDataSourceSnapshot<Int, Item> {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Item>()
        snapshot.appendSections([.zero])
        snapshot.appendItems(items, toSection: .zero)
        return snapshot
    }
    
    private func reloadData(in collectionView: UICollectionView, context: Context, animated: Bool = false) {
        let coordinator = context.coordinator
        
        guard let dataSource = coordinator.dataSource else { return }
        
        dataSource.apply(snapshot(), animatingDifferences: animated) {
            collectionView.setNeedsFocusUpdate()
            collectionView.updateFocusIfNeeded()
        }
    }
}

@available(iOS 13.0, *)
extension SnapCollection {
    private class HostCell: UICollectionViewCell {
        private var hostController: UIHostingController<Cell>?
        
        override func prepareForReuse() {
            if let hostView = hostController?.view {
                hostView.removeFromSuperview()
            }
            hostController = nil
        }
        
        var hostedCell: Cell? {
            willSet {
                guard let view = newValue else { return }
                hostController = UIHostingController(rootView: view)
                guard let hostView = hostController?.view else { return }
                hostView.frame = contentView.bounds
                hostView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                contentView.addSubview(hostView)
            }
        }
    }
}
