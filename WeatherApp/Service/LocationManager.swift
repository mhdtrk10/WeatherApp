//
//  LocationManager.swift
//  WeatherApp
//
//  Created by Mehdi Oturak on 19.03.2025.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    private let manager = CLLocationManager()
    private let geocoder = CLGeocoder()
    
    @Published var latitude: Double = 0.0
    @Published var longitude: Double = 0.0
    @Published var locationStatus: CLAuthorizationStatus?
    @Published var cityName: String = "Current Locaiton"
    
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.requestWhenInUseAuthorization( )
        manager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        DispatchQueue.main.async {
            self.latitude = location.coordinate.latitude
            self.longitude = location.coordinate.longitude
            self.reverseGeocode(location: location)
        }
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        DispatchQueue.main.async {
            self.locationStatus = status
            if status == .authorizedWhenInUse || status == .authorizedAlways{
                self.manager.startUpdatingLocation()
            } else {
                print("konum erişimi reddedildi veya kısıtlandı.")
            }
        }
    }
    private func reverseGeocode(location: CLLocation) {
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let placemark = placemarks?.first {
                let city = placemark.locality ?? placemark.name ?? "Unknown"
                let country = placemark.country ?? "bilinmiyor"
                DispatchQueue.main.async {
                    self.cityName = "\(city), \(country)"
                }
            }
        }
    }
}
