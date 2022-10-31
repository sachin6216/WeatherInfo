//
//  LocationManager.swift
//
//  Created by macbook on 20/01/20.
//

import UIKit
import CoreLocation
import Alamofire
@objc protocol LocationManagerDelegate: AnyObject {
    @objc optional func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    @objc optional func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    @objc optional func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus)
    @objc optional func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion)
    @objc optional func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion)
    @objc optional func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading)
}
class LocationManager: NSObject {
    // MARK: - Variables
    static let sharedInstance = LocationManager()
    private var locationManager: CLLocationManager?
    weak var delegate: LocationManagerDelegate?
    var coordinates: CLLocationCoordinate2D?
    // MARK: - Initializer
    private override init() {
        super.init()
        self.locationManager = CLLocationManager()
        locationManager?.delegate = self
        self.locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        //        self.locationManager?.distanceFilter = 5
        self.locationManager?.requestAlwaysAuthorization()
        self.locationManager?.requestWhenInUseAuthorization()
    }
    // MARK: - Start Updating Locations
    /// Get Location request from the user
    func startUpdatingLocation() {
        if CLLocationManager.authorizationStatus() == .notDetermined || CLLocationManager.authorizationStatus() == .denied || CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||  CLLocationManager.authorizationStatus() == .restricted ||  CLLocationManager.authorizationStatus() == .restricted {
            self.locationManager?.requestAlwaysAuthorization()
            self.locationManager?.requestWhenInUseAuthorization()
        } else {
            self.locationManager?.startUpdatingLocation()
            self.locationManager?.startUpdatingHeading()
        }
    }
    // MARK: - Stop Updating Locations
    func stopUpdatingLocation() {
        self.locationManager?.stopUpdatingLocation()
    }
    // MARK: - Get Address from lat, long
    /// Get location from gps coordinates
    func getCurrentPlace(latitude: Double, longitude: Double, complition: @escaping (String, String) -> Void ) {
        var center: CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double = latitude
        let lon: Double = longitude
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon
        var addressString: String = ""
        var cityName: String = ""
        
        let loc: CLLocation = CLLocation(latitude: center.latitude, longitude: center.longitude)
        ceo.reverseGeocodeLocation(loc) { (placemarks, error) in
            if error != nil {
                Logger.sharedInstance.logMessage(message: "reverse geodcode fail: \(error!.localizedDescription)")
            }
            if  let place = placemarks {
                if place.count > 0 {
                    var addressObj: GeoReverseAddressModel = .init()
                    let locationData = placemarks?.first
                    // Location name
                    if let locationName = locationData?.name {
                        addressString.append(locationName)
                        print(locationName)
                    }
                    // Street address
                    if let street = locationData?.thoroughfare {
                        addressString.append(", \(street)")
                        print(street)
                    }
                    // line 2 address
                    if let subThoroughfare = locationData?.subThoroughfare {
                        addressObj.line2 = subThoroughfare
                    }
                    addressObj.line1 = addressString
                    // City
                    if let city = locationData?.locality {
                        addressString.append(", \(city)")
                        addressObj.city = city
                        cityName = city
                        print(city)
                    }
                    // State
                    if let state = locationData?.administrativeArea {
                        addressString.append(", \(state)")
                        addressObj.state = state
                        print(state)
                    }
                    // Zip code
                    if let zipCode = locationData?.postalCode {
                        addressString.append(", \(zipCode)")
                        addressObj.postalCode = zipCode
                        print(zipCode)
                    }
                    // Country
                    if let country = locationData?.country {
                        addressString.append(", \(country)")
                        addressObj.country = country
                        print(country)
                    }
                    addressObj.formattedAddress = addressString
                    complition(addressString, cityName)
                }
            }
        }
    }
    
}
// MARK: - Location Manger Delegates
extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == .authorizedAlways || CLLocationManager.authorizationStatus() == .notDetermined {
            coordinates = locationManager?.location?.coordinate
            delegate?.locationManager?(manager, didChangeAuthorization: status)
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == .authorizedAlways || CLLocationManager.authorizationStatus() == .notDetermined || CLLocationManager.authorizationStatus() == .restricted {
            guard let currentLoc = locationManager?.location else {
                //                self.showalertview(messagestring: "PLEASEALLOWLOCATION".localize())
                return
            }
            coordinates = currentLoc.coordinate
            delegate?.locationManager?(manager, didUpdateLocations: locations)
        }
//        locationManager?.stopUpdatingLocation()
    }
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        coordinates = locationManager?.location?.coordinate
        //        delegate?.locationManager?(manager, didUpdateHeading: newHeading)
    }
}

// MARK: - GetAddress
struct GetAddress: Codable {
    let plusCode: PlusCode?
    let results: [Result]?
    
    enum CodingKeys: String, CodingKey {
        case plusCode = "plus_code"
        case results
    }
}

// MARK: - PlusCode
struct PlusCode: Codable {
    let compoundCode, globalCode: String?
    
    enum CodingKeys: String, CodingKey {
        case compoundCode = "compound_code"
        case globalCode = "global_code"
    }
}

// MARK: - Result
struct Result: Codable {
    let addressComponents: [AddressComponent]?
    let formattedAddress, placeID: String?
    let plusCode: PlusCode?
    let geometry: Geometry?

    enum CodingKeys: String, CodingKey {
        case addressComponents = "address_components"
        case formattedAddress = "formatted_address"
        case placeID = "place_id"
        case plusCode = "plus_code"
        case geometry = "geometry"
    }
}

// MARK: - AddressComponent
struct AddressComponent: Codable {
    let longName, shortName: String?
    let types: [String]?
    enum CodingKeys: String, CodingKey {
        case longName = "long_name"
        case shortName = "short_name"
        case types
    }
}

struct GeoReverseAddressModel {
    var line1, line2, city, state, country, postalCode, formattedAddress: String?
}
struct Geometry: Codable {
    let location: Coordinates?
    enum CodingKeys: String, CodingKey {
            case location = "location"
        }
}
struct Coordinates: Codable {
    let lat, lng: Double?
    enum CodingKeys: String, CodingKey {
            case lat, lng
        }
}
