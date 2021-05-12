//
//  FlightSectionHeader.swift
//  Compositional_Layout_Example
//
//  Created by Thibaud Lambert on 06/05/2021.
//

import Foundation
import UIKit

class FlightSectionHeader: UICollectionReusableView {
	
	// MARK: - Outlets
	@IBOutlet private weak var label: UILabel!
	
	// MARK: - Variables
	var text: String! {
		didSet {
			self.label.text = self.text
		}
	}
}
