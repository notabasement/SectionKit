import UIKit

extension ListCollectionViewAdapter: UICollectionViewDataSource {
    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        sections.count
    }

    open func collectionView(_ collectionView: UICollectionView,
                             numberOfItemsInSection section: Int) -> Int {
        guard section >= 0 && section < sections.count else {
            assertionFailure("Could not find the specified section")
            return 0
        }
        return sections[section].controller.dataSource.numberOfItems
    }

    open func collectionView(_ collectionView: UICollectionView,
                             cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard indexPath.isSectionIndexValid(for: sections) else {
            assertionFailure("Could not find the specified section")
            return UICollectionViewCell()
        }
        let sectionIndexPath = SectionIndexPath(indexInCollectionView: indexPath,
                                                indexInSectionController: indexPath.item)
        return sections[indexPath.section].controller.dataSource.cellForItem(at: sectionIndexPath)
    }

    open func collectionView(_ collectionView: UICollectionView,
                             viewForSupplementaryElementOfKind elementKind: String,
                             at indexPath: IndexPath) -> UICollectionReusableView {
        guard indexPath.isSectionIndexValid(for: sections) else {
            assertionFailure("Could not find the specified section")
            return UICollectionReusableView()
        }
        let sectionIndexPath = SectionIndexPath(indexInCollectionView: indexPath,
                                                indexInSectionController: indexPath.item)

        let sectionController = sections[indexPath.section]

        switch elementKind {
        case UICollectionView.elementKindSectionHeader:
            return sectionController.controller.dataSource.headerView(at: sectionIndexPath)

        case UICollectionView.elementKindSectionFooter:
            return sectionController.controller.dataSource.footerView(at: sectionIndexPath)

        default:
            assertionFailure("Unsupported supplementary view kind.")
            return UICollectionReusableView()
        }
    }

    open func collectionView(_ collectionView: UICollectionView,
                             canMoveItemAt indexPath: IndexPath) -> Bool {
        guard indexPath.isSectionIndexValid(for: sections) else {
            assertionFailure("Could not find the specified section")
            return false
        }
        let sectionIndexPath = SectionIndexPath(indexInCollectionView: indexPath,
                                                indexInSectionController: indexPath.item)
        return sections[indexPath.section].controller.dataSource.canMoveItem(at: sectionIndexPath)
    }

    open func collectionView(_ collectionView: UICollectionView,
                             moveItemAt sourceIndexPath: IndexPath,
                             to destinationIndexPath: IndexPath) {
        guard sourceIndexPath.isSectionIndexValid(for: sections) else {
            assertionFailure("Could not find the specified section")
            return
        }
        let moveInsideSection = destinationIndexPath.isSectionIndexValid(for: sections)
            && sourceIndexPath.section == destinationIndexPath.section
        guard moveInsideSection || allowReorderingBetweenDifferentSections else {
            return
        }
        let sourceSectionIndexPath = SectionIndexPath(indexInCollectionView: sourceIndexPath,
                                                      indexInSectionController: sourceIndexPath.item)
        let destinationSectionIndexPath = SectionIndexPath(indexInCollectionView: destinationIndexPath,
                                                           indexInSectionController: destinationIndexPath.item)
        sections[sourceIndexPath.section].controller.dataSource.moveItem(at: sourceSectionIndexPath,
                                                                         to: destinationSectionIndexPath)
    }

    open func indexTitles(for collectionView: UICollectionView) -> [String]? {
        return nil
    }

    open func collectionView(_ collectionView: UICollectionView,
                             indexPathForIndexTitle title: String,
                             at index: Int) -> IndexPath {
        assertionFailure("collectionView(_:indexPathForIndexTitle:at:) not implemented")
        return IndexPath(item: 0, section: 0)
    }
}
