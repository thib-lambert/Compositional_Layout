//
//  FlightSectionViewModel.swift
//  Compositional_Layout_Example
//
//  Created by Thibaud Lambert on 05/05/2021.
//

import Foundation

struct FlightSectionViewModel {
	
	let type: FlightSectionType
	let rows: [FlightItemType]
}

enum FlightSectionType: String {
	case upcoming, past
}
