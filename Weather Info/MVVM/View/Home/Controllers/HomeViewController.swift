//
//  HomeViewController.swift
//  Weather Info
//
//  Created by Sachin on 27/10/22.
//

import UIKit
import Combine
import CoreLocation
import Localize_Swift

class HomeViewController: UIViewController {

    // MARK: - Properties
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var lblLoc: UILabel!
    @IBOutlet weak var imgWeatherIcon: UIImageView!
    @IBOutlet weak var lblWeatherStatus: UILabel!
    @IBOutlet weak var lblTemp: UILabel!
    @IBOutlet weak var lblWindValue: UILabel!
    @IBOutlet weak var lblPrecpValue: UILabel!
    @IBOutlet weak var lblPressureValue: UILabel!
    @IBOutlet weak var lblWind: UILabel!
    @IBOutlet weak var lblPrep: UILabel!
    @IBOutlet weak var lblPressure: UILabel!

    // MARK: - Variables
    var viewModel = HomeViewModel()
    private var subscriptions = Set<AnyCancellable>() //Cancellation
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUITheme()
        self.subscribers()
        LocationManager.sharedInstance.startUpdatingLocation()
        LocationManager.sharedInstance.delegate = self
    }
    // MARK: - IBActions
    @IBAction func btnReload(_ sender: UIButton) {
        self.viewModel.getCurrentWeather(controller: self)
    }
    // MARK: - Extra functions
    func setUITheme() {
        Localize.setCurrentLanguage("En")
        
        self.imgWeatherIcon.layer.cornerRadius = self.imgWeatherIcon.frame.height / 2

        self.bgView.layer.cornerRadius = 10
        self.bgView.layer.borderColor = #colorLiteral(red: 0.3761256337, green: 0.5008631945, blue: 0.5802932382, alpha: 1)
        self.bgView.layer.borderWidth = 3.5
        let imgView = UIImageView.init(frame: self.view.frame)
        imgView.image = #imageLiteral(resourceName: "mountains")
        self.view.insertSubview(imgView, at: 0)        
        self.lblWind.text = "WIND".localized()
    }
    // MARK: - APIs
    func subscribers() {
        self.viewModel.getWeatherDetailsPublisher.sink { _ in
            self.lblLoc.text = "\(self.viewModel.model.dataResponse?.location?.name ?? ""), \(self.viewModel.model.dataResponse?.location?.region ?? ""), \(self.viewModel.model.dataResponse?.location?.country ?? "")"
            self.lblTemp.text = "\(self.viewModel.model.dataResponse?.current?.temperature ?? 0.0)°c"
            self.lblWeatherStatus.text = self.viewModel.model.dataResponse?.current?.weatherDescriptions?.first ?? ""
            self.lblWindValue.text = "\(self.viewModel.model.dataResponse?.current?.windSpeed ?? 0.0) kmph"
            self.lblPrecpValue.text = "\(self.viewModel.model.dataResponse?.current?.precip ?? 0.0) mm"
            self.lblPressureValue.text = "\(self.viewModel.model.dataResponse?.current?.pressure ?? 0.0) mb"
            self.imgWeatherIcon.loadFrom(URLAddress: self.viewModel.model.dataResponse?.current?.weatherIcons?.first ?? "")
        }.store(in: &subscriptions)
    }
    
}
// MARK: - Extension UI
extension HomeViewController: LocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        LocationManager.sharedInstance.getCurrentPlace(latitude: locations.first?.coordinate.latitude ?? 0.0, longitude: locations.first?.coordinate.longitude ?? 0.0) { fullAddress, cityName in
            self.viewModel.model.currentLoc = cityName
            self.viewModel.getCurrentWeather(controller: self)
        }
    }
}
