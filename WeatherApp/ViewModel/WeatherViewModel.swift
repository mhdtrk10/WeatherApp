//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Mehdi Oturak on 18.03.2025.
//

import Foundation
import Combine

class WeatherViewModel: ObservableObject {
    @Published var temperature: String = "--"
    @Published var weatherDescription: String = "loading..."
    @Published var iconUrl: String = ""
    @Published var forecast: [ForecastDay] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    func getWeather(for city: String) {
        WeatherService.shared.fetchWeather(for: city)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("API hatası: \(error.localizedDescription)")
                    self.temperature = "--"
                    self.weatherDescription = "Unknown"
                    self.iconUrl = ""
                    self.forecast = []
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] weather in
                self?.temperature = String(format: "%.1f", weather.current.temp_c)
                self?.weatherDescription = weather.current.condition.text
                self?.iconUrl = "https:\(weather.current.condition.icon)"
                self?.forecast = weather.forecast.forecastday
            })
            .store(in: &cancellables)
    }
    
}
