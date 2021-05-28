# Welcome to Compositional-Layout-Example project

## 🗺️ Navigation

<ul>
	<li><a href="#-project-goal">📚 Project goal</a></li>
	<li><a href="#-prerequisite">🔍 Prerequisite</a></li>
	<li><a href="#-layout-organization">🛠 Layout organization</a></li>
	<li><a href="#-usage">🔠 Usage</a></li>
</ul>

## 📚 Project goal
This project has for goal to present you how to construct UICollectionView with Compostional Layout.

### - Project presentation
Project use json data for avoid network call. The data are from to SpaceX web service and only needed keys are fetch for simplify the code.

Clean Architecture is used.

## 🔍 Prerequisite

 - Version minimum required: **iOS 13**
 - Know how to use enum with data inside

## 🛠 Layout organization

![Layout schema](https://www.zealousweb.com/wp-content/uploads/2020/10/Design-02.jpg)

## 🔠 Usage
### -- DiffableDataSource
`UICollectionViewDataSource` is replaced by `UICollectionViewDiffableDataSource<SectionType, ItemType>`

SectionType and ItemType need to be Hashable. 

You can use UICollectionViewDelegate for manage tap on cells.

### — Create cells
```swift
UICollectionViewDiffableDataSource<SectionType, ItemType>(collectionView: collectionView)  { 
(collectionView: UICollectionView, indexPath: IndexPath, item: ItemType) -> UICollectionViewCell? in 
	// configure and return cell
}
```

This func is equivalent to `collectionView(_:cellForItemAt:)`

**How to use ?**
```swift
let dataSource = UICollectionViewDiffableDataSource<SectionType, ItemType>(collectionView: self.collectionView, cellProvider: { collectionView, indexPath, itemType in
	let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? Cell
	cell.item = itemType
	
	return cell
})
```

### - Create UICollectionReusableView (header / footer)
> supplementaryViewProvider: UICollectionViewDiffableDataSource<SectionIdentifierType, ItemIdentifierType>.SupplementaryViewProvider?

This func is equivalent to `collectionView(_:viewForSupplementaryElementOfKind:at:)`

**How to use ?**
```swift
dataSource.supplementaryViewProvider = self.supplementary(collectionView:kind:indexPath:)


private func supplementary(collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView {
	let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "sectionHeader", for: indexPath) as? SectionHeader
	
	return header ?? UICollectionReusableView()
}
```

### - Reload data in collection view
The dataSource manage automatically `numberOfSections(in collectionView: UICollectionView) -> Int` and `collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int`.

**How to use ?**
```swift
private func reloadData(section: SectionType, items: [ItemType]) {

	var snapshot = NSDiffableDataSourceSnapshot<SectionType, ItemType>()

	// Add sections to collection view
	snapshot.appendSections([section])

	// Add items to section in collection view
	snapshot.appendItems(items, toSection: section)

	// Reload data in collection view
	self.dataSource.apply(snapshot)
}
```

### - Manage layout
This section will explain how to create layout for collectionView.

⚠️ Sizes always refer to the parent. ⚠️

**How to add layout ?**
```swift
// Create layout for collection view
self.collectionView.collectionViewLayout = self.createLayout()
```

**How to create layout ?**
```swift
private func createLayout() -> UICollectionViewLayout {
	UICollectionViewCompositionalLayout(sectionProvider: self.createSection(index: environment:))
}
```

```swift
private func createSection(index: Int, environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {

	// Get section type for create different layout
	let sectionType = self.dataSource.snapshot().sectionIdentifiers[index]
	var section: NSCollectionLayoutSection!

	switch sectionType {
		default: section = self.prepareLayout()
	}

	// Add header on section
	let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
						heightDimension: .estimated(50))

	let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
									elementKind: "sectionHeaderKind",
									alignment: .top)
	section.boundarySupplementaryItems = [sectionHeader]

	return section
}
```

```swift
/// Create line with two items square
private func prepareLayout() -> NSCollectionLayoutSection {
	// Item
	let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
					      heightDimension: .fractionalWidth(1))
	let item = NSCollectionLayoutItem(layoutSize: itemSize)

	// Group
	let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
					       heightDimension: .estimated(200))
	let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
						       subitem: item, 
						       count: 2)

	// Section
	let section = NSCollectionLayoutSection(group: group)
	section.interGroupSpacing = 5

	return section
}
```
