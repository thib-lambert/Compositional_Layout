//
//  HomePresenter.swift
//  Compositional_Layout_Example
//
//  Created by Thibaud Lambert on 05/05/2021.
//

import Foundation

class HomePresenter: Presenter<HomeViewController> {
	
	// MARK: - Refresh
	func didFetchFlights(upcomingFlights: [Flight], pastFlights: [Flight]) {
		
		let upcomingSection = FlightSectionViewModel(type: .upcoming, rows: upcomingFlights.compactMap { flight -> FlightItemType in
			.upcoming(FlightRowViewModel(name: flight.name, date: flight.date.toString()))
		})
		
		let pastSection = FlightSectionViewModel(type: .past, rows: pastFlights.compactMap { flight -> FlightItemType in
			.past(FlightRowViewModel(name: flight.name, date: flight.date.toString()))
		})
		
		self.view?.didRefresh(flights: [upcomingSection, pastSection])
	}
}

private extension Date {
	func toString() -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.locale = Locale.current
		dateFormatter.dateStyle = .medium
		return dateFormatter.string(from: self)
	}
}
