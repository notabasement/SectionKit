import UIKit

open class ListSectionAdapter:
    NSObject,
    SectionAdapter
{
    // MARK: - Internal properties
    
    internal var cachedIndexTitles: [(sectionControllerId: String, title: String)] = []
    
    // MARK: - Init
    
    /**
     Initialize an instance of `ListCollectionAdapter` to use it as the datasource and delegate of the given `UICollectionView`
     
     - Parameter viewController: The `UIViewController` which owns the `UICollectionView` and will be used in the `CollectionContext`
     
     - Parameter collectionView: The `UICollectionView` to use to display the data
     
     - Parameter scrollViewDelegate: An optional delegate instance that should receive `UIScrollViewDelegate` callbacks
     */
    public init(viewController: UIViewController?,
                collectionView: UICollectionView,
                scrollViewDelegate: UIScrollViewDelegate? = nil) {
        collectionContext = MainCollectionContext(viewController: viewController,
                                                  collectionView: collectionView)
        self.scrollViewDelegate = scrollViewDelegate
        super.init()
        collectionContext.sectionControllers = { [weak self] in
            self?.sections.map(\.controller) ?? []
        }
        collectionView.dataSource = self
        collectionView.delegate = self
        if #available(iOS 11.0, *) {
            collectionView.dragDelegate = self
            collectionView.dropDelegate = self
            collectionView.dragInteractionEnabled = true
        }
    }
    
    // MARK: - SectionAdapter
    
    public let collectionContext: CollectionContext
    
    open weak var scrollViewDelegate: UIScrollViewDelegate?
    
    open weak var dataSource: SectionAdapterDataSource? {
        didSet { invalidateDataSource() }
    }
    
    /**
     The list of sections currently displayed in the `UICollectionView`
     
     Only set this property if `UICollectionView` insertions and deletions are handled, otherwise use `sections` instead.
     */
    open var collectionViewSections: [Section] = [] {
        willSet {
            collectionViewSections.forEach { $0.controller.context = nil }
        }
        didSet {
            collectionViewSections.forEach { $0.controller.context = collectionContext }
        }
    }
    
    open var sections: [Section] {
        get { collectionViewSections }
        set {
            let collectionUpdate = calculateUpdate(from: collectionViewSections,
                                                   to: newValue)
            collectionContext.apply(update: collectionUpdate)
        }
    }
    
    /**
     Calculate the `UICollectionView` events using the difference from the old to the new data
     
     - Parameter oldData: The old data currently displayed in the `UICollectionView`
     
     - Parameter newData: The new data that should be displayed in the `UICollectionView`
     
     - Returns: The update that should be performed on the `UICollectionView`
     */
    open func calculateUpdate(from oldData: [Section],
                              to newData: [Section]) -> CollectionUpdate<[Section]> {
        return CollectionUpdate(data: newData,
                                setData: { [weak self] in self?.collectionViewSections = $0 })
    }
    
    open var allowReorderingBetweenDifferentSections: Bool = false
    
    open func invalidateDataSource() {
        guard let dataSource = dataSource else { return }
        sections = querySections(from: dataSource)
    }
    
    private func querySections(from dataSource: SectionAdapterDataSource) -> [Section] {
        var sections: [Section] = []
        let rootObjects = dataSource.objects(for: self).map { (dataSource, $0) }
        var objectsStack = Stack(rootObjects.reversed())
        while let (dataSource, object) = objectsStack.pop() {
            switch object {
            case let .section(id: id, model: model):
                let sectionController = dataSource.sectionController(with: model, for: self)
                let section = Section(id: id,
                                      model: model,
                                      controller: sectionController)
                sections.append(section)
            case let .dataSource(nestedDataSource):
                for nestedObject in nestedDataSource.objects(for: self).reversed() {
                    objectsStack.push((nestedDataSource, nestedObject))
                }
            }
        }
        return sections
    }
}

