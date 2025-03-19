//
//  WeatherService.swift
//  WeatherApp
//
//  Created by Mehdi Oturak on 18.03.2025.
//

import Foundation
import Combine

class WeatherService {
    static let shared = WeatherService()
    private let apiKey = "7fb13cb820684470b6610833251803"
    
    func fetchWeather(for city: String) -> AnyPublisher<weatherModel, Error> {
        let urlString = "https://api.weatherapi.com/v1/forecast.json?key=\(apiKey)&q=\(city)&days=7&aqi=no&alerts=no"
        guard let url = URL(string: urlString) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        return URLSession.shared.dataTaskPublisher(for: url)
            .map {$0.data}
            .decode(type: weatherModel.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func fetchWeatherByCoordinates(lat: Double, lon: Double) -> AnyPublisher<weatherModel, Error> {
        let urlString = "https://api.weatherapi.com/v1/forecast.json?key=\(apiKey)&q=\(lat),\(lon)&days=7&aqi=no&alerts=no"
        guard let url = URL(string: urlString) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { result in
                return result.data
            }
            .decode(type: weatherModel.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

