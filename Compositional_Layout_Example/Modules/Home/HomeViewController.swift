//
//  HomeViewController.swift
//  Compositional_Layout_Example
//
//  Created by Thibaud Lambert on 05/05/2021.
//

import UIKit

class HomeViewController: UIViewController {
	
	// MARK: - Outlets
	@IBOutlet private weak var changeLayoutButton: UIButton!
	@IBOutlet private weak var loader: UIActivityIndicatorView! {
		didSet {
			self.loader.hidesWhenStopped = true
		}
	}
	
	@IBOutlet private weak var collectionView: UICollectionView! {
		didSet {
			// Register cells and header
			self.collectionView.register(UINib(nibName: "UpcomingCell", bundle: .main), forCellWithReuseIdentifier: "upcomingCell")
			self.collectionView.register(UINib(nibName: "PastCell", bundle: .main), forCellWithReuseIdentifier: "pastCell")
			self.collectionView.register(UINib(nibName: "FlightSectionHeader", bundle: .main), forSupplementaryViewOfKind: "flightSectionHeaderKind", withReuseIdentifier: "flightSectionHeader")
			
			// Create layout for collection view
			self.collectionView.collectionViewLayout = self.createLayout()
		}
	}
	
	// MARK: - Variables
	private lazy var dataSource: UICollectionViewDiffableDataSource<FlightSectionType, FlightItemType> = {
		
		// Generate cells with their type
		let dataSource = UICollectionViewDiffableDataSource<FlightSectionType, FlightItemType>(collectionView: self.collectionView, cellProvider: { collectionView, indexPath, itemType in
			
			switch itemType {
			case .upcoming(let data):
				let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "upcomingCell", for: indexPath) as? UpcomingCell
				cell?.data = data
				
				return cell
				
			case .past(let data):
				let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pastCell", for: indexPath) as? PastCell
				cell?.data = data
				
				return cell
			}
		})
		
		// Generate header for sections
		dataSource.supplementaryViewProvider = self.supplementary(collectionView:kind:indexPath:)
		
		return dataSource
	}()
	
	private lazy var interactor: HomeInteractor = {
		HomeInteractor(with: self)
	}()
	
	// It's for create a new layout
	private var useStormLayout = false
	
	// MARK: - View life cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.loader.startAnimating()
		
		// Fetch data
		self.interactor.refresh()
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		self.changeLayoutButton.layer.cornerRadius = self.changeLayoutButton.bounds.height / 4
	}
	
	// MARK: - Refresh
	func didRefresh(flights: [FlightSectionViewModel]) {
		
		// Reload data for the collection view
		DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
			self?.loader.stopAnimating()
			self?.changeLayoutButton.isHidden = false
			self?.reloadData(data: flights)
		}
	}
	
	// MARK: - Helpers
	private func reloadData(data: [FlightSectionViewModel]) {
		var snapshot = NSDiffableDataSourceSnapshot<FlightSectionType, FlightItemType>()
		
		// Add sections to collection view
		snapshot.appendSections(data.compactMap { $0.type })
		
		// Add items to section in collection view
		data.forEach { section in
			snapshot.appendItems(section.rows, toSection: section.type)
		}
		
		// Reload data in collection view
		self.dataSource.apply(snapshot)
	}
	
	// MARK: - Actions
	@IBAction private func didTapButon() {
		self.useStormLayout.toggle()
		UIView.animate(withDuration: 1) { [collectionView] in
			collectionView?.collectionViewLayout.invalidateLayout()
		}
	}
}

// MARK: - Layout
extension HomeViewController {
	
	private func createLayout() -> UICollectionViewLayout{
		return UICollectionViewCompositionalLayout(sectionProvider: self.createSection(index: environment:))
	}
	
	
	private func createSection(index: Int, environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
		// Get section type for create different layout
		let sectionType = self.dataSource.snapshot().sectionIdentifiers[index]
		
		var section: NSCollectionLayoutSection!

		switch sectionType {
		case .upcoming: section = self.useStormLayout ? self.createStormLayoutForUpcoming() : self.prepareLayoutForUpcoming()
		case .past: section = self.useStormLayout ? self.createStormLayoutForPast() : self.prepareLayoutForPast()
		}
		
		// Add header on section
		let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
													  heightDimension: .estimated(50))
		
		let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
																		elementKind: "flightSectionHeaderKind",
																		alignment: .top)
		
		section.boundarySupplementaryItems = [sectionHeader]
		
		return section
	}
	
	private func prepareLayoutForUpcoming() -> NSCollectionLayoutSection {
		// Item
		let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1))
		let item = NSCollectionLayoutItem(layoutSize: itemSize)
		
		// Group
		let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .estimated(200))
		let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
		
		// Section
		let section = NSCollectionLayoutSection(group: group)
		section.orthogonalScrollingBehavior = .continuous
		section.interGroupSpacing = 5
		
		return section
	}
	
	private func prepareLayoutForPast() -> NSCollectionLayoutSection {
		// Item
		let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
		let item = NSCollectionLayoutItem(layoutSize: itemSize)
		
		// Group
		let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.5))
		let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
		group.interItemSpacing = .fixed(5)
		
		// Section
		let section = NSCollectionLayoutSection(group: group)
		section.interGroupSpacing = 5
		
		return section
	}
	
	private func createStormLayoutForPast() -> NSCollectionLayoutSection {
		// mainItem
		let mainItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1))
		let mainItem = NSCollectionLayoutItem(layoutSize: mainItemSize)
		
		// PairItem
		let pairItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.5))
		let pairItem = NSCollectionLayoutItem(layoutSize: pairItemSize)
		
		// Group pair item
		let groupPairItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1))
		let groupPairItem = NSCollectionLayoutGroup.vertical(layoutSize: groupPairItemSize, subitems: [pairItem, pairItem])
		
		// Group final
		let groupFinalSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(150))
		let groupFinal = NSCollectionLayoutGroup.horizontal(layoutSize: groupFinalSize, subitems: [mainItem, groupPairItem])
		
		// Section
		let section = NSCollectionLayoutSection(group: groupFinal)
		section.interGroupSpacing = 5
		
		return section
	}
	
	private func createStormLayoutForUpcoming() -> NSCollectionLayoutSection {
		// sideItem
		let sideItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3), heightDimension: .fractionalHeight(1))
		let sideItem = NSCollectionLayoutItem(layoutSize: sideItemSize)

		// PairItem
		let pairItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.5))
		let pairItem = NSCollectionLayoutItem(layoutSize: pairItemSize)

		// Center group
		let groupPairItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3), heightDimension: .fractionalHeight(1))
		let groupPairItem = NSCollectionLayoutGroup.vertical(layoutSize: groupPairItemSize, subitem: pairItem, count: 2)

		// Group final
		let groupFinalSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(150))
		let groupFinal = NSCollectionLayoutGroup.horizontal(layoutSize: groupFinalSize, subitems: [sideItem, groupPairItem, sideItem])

		// Section
		let section = NSCollectionLayoutSection(group: groupFinal)
		section.interGroupSpacing = 5

		return section
	}
	
	// Create header only for type flightSectionHeaderKind
	private func supplementary(collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView {
		var headerFinal = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "flightSectionHeader", for: indexPath)
		
		let sectionType = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
		
		if let header = headerFinal as? FlightSectionHeader {
			header.text = sectionType.rawValue.uppercased()
			headerFinal = header
		}
		
		return headerFinal
	}
}
