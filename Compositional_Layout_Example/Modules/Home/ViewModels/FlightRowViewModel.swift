//
//  FlightRowViewModel.swift
//  Compositional_Layout_Example
//
//  Created by Thibaud Lambert on 05/05/2021.
//

import Foundation

struct FlightRowViewModel: Hashable {
	
	let name: String
	let date: String
}

enum FlightItemType: Hashable {
	case upcoming(FlightRowViewModel)
	case past(FlightRowViewModel)
}
