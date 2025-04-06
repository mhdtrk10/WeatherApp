//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Mehdi Oturak on 18.03.2025.
//

import Foundation
import Combine

class WeatherViewModel: ObservableObject {
   
    //Anlık veriler (güncel sıcaklık gösterimi için)
    @Published var locationName: String = "Current Location"
    @Published var currentTemp: String = "--"
    @Published var descriptionText: String = ""
    @Published var weatherCode: Int = 0
    
    // 7 günlük tahmin
    @Published var forecast: [ForecastDay] = []
    
    // hata mesajı
    @Published var errorMessage: String? = nil
    
    
    // Combine için iptal edilebilir referans
    private var cancellables = Set<AnyCancellable>()
    
    // Konum yöneticisi
    private let locationManager = LocationManager()
    
    var currentLocationName: String {
        locationManager.cityName
    }
    
    // Kullanıcının anlık konumuna göre hava durumu getirme
    func fetchWeatherForCurrentLocation() {
        let lat = locationManager.latitude
        let lon = locationManager.longitude
        
        guard lat != 0.0 && lon != 0.0 else {
            errorMessage = "Konum alınamadı."
            return
        }
        WeatherService.shared.fetchWeather(latitude: lat, longitude: lon)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    self.errorMessage = "API hatası: \(error.localizedDescription)"
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] forecast in
                guard let self = self else { return }
                self.forecast = forecast
                if let today = forecast.first {
                    self.currentTemp = String(format: "%.1f", today.maxTemp)
                    self.weatherCode = today.code
                    self.descriptionText = self.getDescription(from: today.code)
                }
            })
            .store(in: &cancellables)
    }
    
    func fetchWeather(for latitude: Double, longitude: Double) {
        WeatherService.shared.fetchWeather(latitude: latitude, longitude: longitude)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    self.errorMessage = "API hatası: \(error.localizedDescription)"
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] forecast in
                guard let self = self else { return }
                self.forecast = forecast
                if let today = forecast.first {
                    self.currentTemp = String(format: "%.1f", today.maxTemp)
                    self.weatherCode = today.code
                    self.descriptionText = self.getDescription(from: today.code)
                    
                }
            })
            .store(in: &cancellables)
    }
    
    // Weather açıklaması
    private func getDescription(from code: Int) -> String {
        switch code {
        case 0: return "Sunny"
        case 1,2 : return "Partly Cloudy"
        case 3: return "Cloudy"
        case 45,48 : return "Foggy"
        case 51,52,55: return "Drizzly"
        case 61,63,65: return "Rainy"
        case 71,73,75: return "Snowy"
        case 80,81,82: return "DownPour"
        default: return "Unknown"
        }
    }
    
    
}
