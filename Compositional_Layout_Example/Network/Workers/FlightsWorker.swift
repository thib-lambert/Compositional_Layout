//
//  FlightsWorker.swift
//  Compositional_Layout_Example
//
//  Created by Thibaud Lambert on 05/05/2021.
//

import Foundation

protocol FlightsWorkerDelegate: AnyObject {
	func didFetchFlights(upcomingFlights: [Flight], pastFlights: [Flight])
}

class FlightsWorker {
	
	weak var delegate: FlightsWorkerDelegate?
	
	// MARK: - Fetch
	func fetchFlights() {
		var upcomingFlights: [Flight] = []
		var pastFlights: [Flight] = []
		
		if let upcomingPath = Bundle.main.path(forResource: "upcoming", ofType: "json"),
		   let pastPath = Bundle.main.path(forResource: "past", ofType: "json") {
			do {
				var data = try Data(contentsOf: URL(fileURLWithPath: upcomingPath), options: .mappedIfSafe)
				upcomingFlights = try JSONDecoder().decode([FlightResponse].self, from: data)
				
				data = try Data(contentsOf: URL(fileURLWithPath: pastPath), options: .mappedIfSafe)
				pastFlights = try JSONDecoder().decode([FlightResponse].self, from: data)
			} catch {
				print("\(Self.self) \(#function) -> \(error.localizedDescription)")
			}
		}
		
		self.delegate?.didFetchFlights(upcomingFlights: upcomingFlights, pastFlights: pastFlights)
	}
}
