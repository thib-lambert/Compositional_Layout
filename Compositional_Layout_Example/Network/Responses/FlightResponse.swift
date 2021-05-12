//
//  FlightResponse.swift
//  Compositional_Layout_Example
//
//  Created by Thibaud Lambert on 05/05/2021.
//

import Foundation

struct FlightResponse: Decodable, Flight {
	
	enum CodingKeys: String, CodingKey {
		case id, name
		case dateUnix = "date_unix"
	}
	
	let id: String
	let name: String
	private let dateUnix: Int
	
	var date: Date { Date(timeIntervalSince1970: TimeInterval(self.dateUnix)) }
}
