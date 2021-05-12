//
//  HomeInteractor.swift
//  Compositional_Layout_Example
//
//  Created by Thibaud Lambert on 05/05/2021.
//

import Foundation
import UIKit

class HomeInteractor: Interactor<HomeViewController, HomePresenter> {
	
	// MARK: - Workers
	private lazy var flightsWorker: FlightsWorker = {
		let worker = FlightsWorker()
		worker.delegate = self
		
		return worker
	}()
	
	// MARK: - Refresh
	func refresh() {
		self.flightsWorker.fetchFlights()
	}
}

extension HomeInteractor: FlightsWorkerDelegate {
	
	func didFetchFlights(upcomingFlights: [Flight], pastFlights: [Flight]) {
		self.presenter.didFetchFlights(upcomingFlights: upcomingFlights, pastFlights: pastFlights)
	}
}
