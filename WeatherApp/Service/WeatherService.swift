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
    
    
    func fetchWeather(latitude: Double, longitude: Double) -> AnyPublisher<[ForecastDay], Error> {
        let urlString = "https://api.open-meteo.com/v1/forecast?latitude=\(latitude)&longitude=\(longitude)&daily=temperature_2m_max,temperature_2m_min,weathercode&timezone=auto"
        guard let url = URL(string: urlString) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        return URLSession.shared.dataTaskPublisher(for: url)
            .map {$0.data}
            .decode(type: WeatherResponse.self, decoder: JSONDecoder())
            .map { response in
                // API'den gelen dizi verileri tek tek ForecastDay modeline dönüştürür.
                
                let count = response.daily.time.count
                return (0..<count).map { index in
                    ForecastDay(
                        date: response.daily.time[index],
                        maxTemp: response.daily.temperature_2m_max[index],
                        minTemp: response.daily.temperature_2m_min[index],
                        code:  response.daily.weathercode[index]
                    )
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
}

