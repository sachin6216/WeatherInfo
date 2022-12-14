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
    
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var btnSwitchLang: UISwitch!
    @IBOutlet weak var btnSWitchMode: UISwitch!
    // MARK: - Variables
    var viewModel = HomeViewModel()
    private var subscriptions = Set<AnyCancellable>()
    
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
        LocationManager.sharedInstance.startUpdatingLocation()
    }
    @IBAction func btnSWitchModeAct(_ sender: UISwitch) {
        let appDelegate = UIApplication.shared.windows.first
        if sender.isOn {
            appDelegate?.overrideUserInterfaceStyle = .dark
            UserDefaults.standard.setValue(true, forKey: "isDarkEnable")
            return
        }
        UserDefaults.standard.setValue(false, forKey: "isDarkEnable")
        appDelegate?.overrideUserInterfaceStyle = .light
    }
    @IBAction func btnSwitchAct(_ sender: UISwitch) {
        
        Localize.setCurrentLanguage(sender.isOn ? "hi" : "En")
        self.setLocalization()
    }
    // MARK: - Extra functions
    /// Setting the localization on UIs
    fileprivate func setLocalization() {
        self.lblWind.text = "WIND".localized()
        self.lblPrep.text = "PRECIPTION".localized()
        self.lblPressure.text = "PRESSURE".localized()
        self.lblHeader.text = "WEATHERINFO".localized()
    }
    
    /// Set UI properties
    func setUITheme() {
        self.imgWeatherIcon.layer.cornerRadius = self.imgWeatherIcon.frame.height / 2
        self.bgView.layer.cornerRadius = 20
        self.bgView.layer.shadowColor = UIColor.lightGray.cgColor
        self.bgView.layer.shadowOffset = .zero
        self.bgView.layer.shadowRadius = 10
        self.bgView.layer.shadowOpacity = 0.6
        let imgView = UIImageView.init(frame: self.view.frame)
        imgView.image = #imageLiteral(resourceName: "mountains")
        self.view.insertSubview(imgView, at: 0)
        setLocalization()
        
        
        self.btnSWitchMode.isOn = UserDefaults.standard.bool(forKey: "isDarkEnable") ? true : false
        self.btnSWitchModeAct(self.btnSWitchMode)
        self.btnSwitchLang.isOn = Localize.currentLanguage() == "hi" ? true : false
    }
    // MARK: - APIs
    /// Subscribe the publisher to get callbacks from the change events.
    func subscribers() {
        self.viewModel.getWeatherDetailsPublisher.sink { _ in
            self.lblLoc.text = "\(self.viewModel.model.dataResponse?.location?.name ?? ""), \(self.viewModel.model.dataResponse?.location?.region ?? ""), \(self.viewModel.model.dataResponse?.location?.country ?? "")"
            self.lblTemp.text = "\(self.viewModel.model.dataResponse?.current?.temperature ?? 0.0)??c"
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
