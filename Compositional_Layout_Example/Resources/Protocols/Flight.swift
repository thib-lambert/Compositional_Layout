//
//  Flight.swift
//  Compositional_Layout_Example
//
//  Created by Thibaud Lambert on 05/05/2021.
//

import Foundation

protocol Flight {
	
	var id: String { get }
	var name: String { get }
	var date: Date  { get }
}
