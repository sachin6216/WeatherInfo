//
//  HomeViewModel.swift
//  Weather Info
//
//  Created by Sachin on 28/10/22.
//

import Foundation
import Combine

class HomeViewModel {
    var model = HomeModel()
    
    
    var getWeatherDetailsPublisher: AnyPublisher<String, Never> {
        getWeatherDetailsSubject.eraseToAnyPublisher()
    }
    let getWeatherDetailsSubject = PassthroughSubject<String, Never>()
    
    
    func getCurrentLoc() {
        self.getWeatherDetailsSubject.send("20.3")
    }
}
