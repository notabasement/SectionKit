import UIKit

@available(iOS 10.0, *)
extension ListCollectionViewAdapter: UICollectionViewDataSourcePrefetching {
    open func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        indexPaths.filter(\.isValid).group(by: \.section).forEach { sectionIndex, indexPaths in
            guard let dataSourcePrefetchingDelegate = dataSourcePrefetchingDelegate(at: sectionIndex) else {
                return
            }
            let sectionIndexPaths = indexPaths.map(SectionIndexPath.init)
            dataSourcePrefetchingDelegate.prefetchItems(at: sectionIndexPaths)
        }
    }

    open func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        indexPaths.filter(\.isValid).group(by: \.section).forEach { sectionIndex, indexPaths in
            guard let dataSourcePrefetchingDelegate = dataSourcePrefetchingDelegate(at: sectionIndex) else {
                return
            }
            let sectionIndexPaths = indexPaths.map(SectionIndexPath.init)
            dataSourcePrefetchingDelegate.cancelPrefetchingForItems(at: sectionIndexPaths)
        }
    }
}
