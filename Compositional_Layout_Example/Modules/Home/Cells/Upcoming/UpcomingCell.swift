//
//  UpcomingCell.swift
//  Compositional_Layout_Example
//
//  Created by Thibaud Lambert on 05/05/2021.
//

import Foundation
import UIKit

class UpcomingCell: UICollectionViewCell {
	
	// MARK: - Outlets
	@IBOutlet private weak var nameLabel: UILabel!
	@IBOutlet private weak var dateLabel: UILabel!
	
	// MARK: - Variables
	var data: FlightRowViewModel! {
		didSet {
			self.nameLabel.text = data.name
			self.dateLabel.text = data.date
			self.layer.borderWidth = 1
			self.layer.borderColor = UIColor.black.cgColor
		}
	}
}
