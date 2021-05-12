//
//  Interactor.swift
//  Compositional_Layout_Example
//
//  Created by Thibaud Lambert on 05/05/2021.
//

import Foundation
import UIKit

class Interactor<V: UIViewController, P: Presenter<V>> {
	
	// MARK: - Variables
	var presenter: P
	
	// MARK: - Init
	init(with view: V) {
		self.presenter = P(with: view)
	}
}
