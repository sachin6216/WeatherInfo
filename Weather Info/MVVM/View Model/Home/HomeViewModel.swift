//
//  HomeViewModel.swift
//  Weather Info
//
//  Created by Sachin on 28/10/22.
//
import UIKit
import Foundation
import Combine

class HomeViewModel {
    var model = HomeModel()
    var getWeatherDetailsPublisher: AnyPublisher<String, Never> {
        getWeatherDetailsSubject.eraseToAnyPublisher()
    }
    let getWeatherDetailsSubject = PassthroughSubject<String, Never>()
    
    
    func getCurrentWeather(controller: UIViewController) {
        Connectivity.shared.startLoad()
        HomeEndPoint.getCurrentWeather(query: self.model.currentLoc ?? "Chandigarh").instance.executeQuery { (response: GetWeather) in
            Connectivity.shared.endLoad()
            if response.current != nil {
                self.model.dataResponse = response
                self.getWeatherDetailsSubject.send("")
            } else {
                controller.showalertview(messagestring: "Something went worng")
            }
        } error: { (errorMsg) in
            Connectivity.shared.endLoad()
            controller.showalertview(messagestring: errorMsg ?? "")
        }
    }
}
