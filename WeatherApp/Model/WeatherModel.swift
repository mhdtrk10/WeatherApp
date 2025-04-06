
import Foundation


//Open-Meteo API'den dönen ana JSON yanıt yapısı
struct WeatherResponse: Codable {
    let daily: DailyForecast
}
//Günlük tahmin değerlerini içeren yapı
struct DailyForecast: Codable {
    let time: [String]
    let temperature_2m_max: [Double]
    let temperature_2m_min: [Double]
    let weathercode: [Int]
}

//UI'da kullanılmak üzere sadeleştirilmiş model
struct ForecastDay: Identifiable {
    let id = UUID()
    let date: String
    let maxTemp: Double
    let minTemp: Double
    let code: Int
}
