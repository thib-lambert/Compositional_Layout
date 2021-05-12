//
//  Presenter.swift
//  Compositional_Layout_Example
//
//  Created by Thibaud Lambert on 05/05/2021.
//

import Foundation
import UIKit

class Presenter<V: UIViewController> {
	
	// MARK: - Variables
	weak var view: V?
	
	// MARK: - Init
	required init(with view: V) {
		self.view = view
	}
}
