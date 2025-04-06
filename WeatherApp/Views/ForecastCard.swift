//
//  ForecastCard.swift
//  WeatherApp
//
//  Created by Mehdi Oturak on 7.04.2025.
//

import SwiftUI

struct ForecastCard: View {
    let day: ForecastDay
    var body: some View {
        VStack {
            Text(formatDate(day.date))
                .font(.caption)
            Image(systemName: weatherIcon(for: day.code))
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
            Text(weatherDescription(for: day.code))
                .font(.caption2)
            Text("\(day.maxTemp, specifier: "%.1f")°C / \(day.minTemp, specifier: "%.1f")°C")
                .font(.headline)
        }
        .padding()
        .background(Color.white.opacity(0.2))
        .cornerRadius(10)
        .shadow(radius: 5)
    }
    func formatDate(_ dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let date = formatter.date(from: dateString) {
            formatter.dateStyle = .short
            return formatter.string(from: date)
        }
        return dateString
    }
    func weatherDescription(for code: Int) -> String {
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
    func weatherIcon(for code: Int) -> String {
        switch code {
        case 0: return "sun.max.fill"
        case 1,2: return "cloud.sun.fill"
        case 3: return "cloud.fill"
        case 45,48: return "cloud.fog.fill"
        case 51,53,55: return "cloud.drizzle.fill"
        case 61,63,65: return "cloud.rain.fill"
        case 71,73,75: return "snow"
        case 80,81,82: return "cloud.heavyrain.fill"
        default: return "questionmark"
        }
    }
}


