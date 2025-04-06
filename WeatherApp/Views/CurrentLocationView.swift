//
//  CurrentLocationView.swift
//  WeatherApp
//
//  Created by Mehdi Oturak on 19.03.2025.
//

import SwiftUI

struct CurrentLocationView: View {
    
    @StateObject private var viewModel = WeatherViewModel()
    
    var backgroundColor: Color {
        switch viewModel.descriptionText.lowercased() {
        case let desc where desc.contains("sun"):
            return Color.yellow.opacity(0.7)
        case let desc where desc.contains("cloud"):
            return Color.gray.opacity(0.5)
        case let desc where desc.contains( "rain"):
            return Color.blue.opacity(0.5)
        case let desc where desc.contains("snow"):
            return Color.white.opacity(0.8)
        default:
            return Color.blue.opacity(0.3)
        }
    }
    
    var body: some View {
        ZStack {
            backgroundColor
                .edgesIgnoringSafeArea(.all)
                .animation(.easeInOut(duration: 0.5))
            
            VStack {
                VStack {
                    Text(viewModel.currentLocationName)
                        .font(.title)
                        .padding()
                    
                    Image(systemName: weatherIcon(for: viewModel.weatherCode))
                        .font(.system(size: 100))
                        .padding()
                    
                    if viewModel.currentTemp == "--" {
                        Text("location is being taken..")
                            .font(.title2)
                            .foregroundColor(.gray)
                            .padding()
                    } else {
                        Text(viewModel.currentTemp + "°C")
                            .font(.system(size: 64, weight: .bold))
                            .padding()
                        
                        Text(viewModel.descriptionText)
                            .font(.title2)
                            .padding()
                        
                        
                    }
                    
                    
                    Button(action: {
                        
                        viewModel.fetchWeatherForCurrentLocation()
                    }) {
                        Text("Refresh Location Weather")
                            .foregroundColor(Color.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                }
                .padding()
                
                ScrollView(.horizontal,showsIndicators: false) {
                    HStack {
                        ForEach(viewModel.forecast) { day in
                            VStack {
                                Text(day.date) // değişecek
                                    .font(.caption)
                                Text("\(day.maxTemp,specifier: "%.1f")°C / \(day.minTemp,specifier: "%.1f")°C")
                                    .font(.headline)
                                
                                Image(systemName: weatherIcon(for: day.code))
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40)
                                
                                Text(weatherDescription(for: day.code))
                                    .font(.caption2)
                                    .foregroundColor(.black)
                                    
                            }
                            .padding()
                            .cornerRadius(10)
                            .background(Color.white.opacity(0.2))
                            .shadow(radius: 5)
                        }
                    }
                    .padding(.horizontal)
                }
                Spacer()
            }
            .padding()
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    viewModel.fetchWeatherForCurrentLocation()
                }
            }
            
        }
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
}

#Preview {
    CurrentLocationView()
}
