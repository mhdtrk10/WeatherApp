//
//  HomeContent.swift
//  WeatherApp
//
//  Created by Mehdi Oturak on 7.04.2025.
//

import SwiftUI
import CoreLocation
struct HomeContent: View {
    @Binding var city: String
    @ObservedObject var viewModel: WeatherViewModel
    
    var body: some View {
        VStack {
            Image(systemName: weatherIcon(for: viewModel.weatherCode))
                .font(.system(size: 100))
                .padding()
            TextField("Enter a city..", text: $city)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .background(Color.white.opacity(0.3))
                .cornerRadius(10)
                .shadow(radius: 5)
            Button(action: {
                geocodeCityName(city)
            }) {
                Text("Search")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
                    .shadow(radius: 5)
            }
            if viewModel.currentTemp != "--" {
                Text("\(viewModel.currentTemp)°C")
                    .font(.system(size: 64, weight: .bold))
                    .padding(.top)
                Text(viewModel.descriptionText)
                    .font(.title2)
                    .padding(.bottom)
            }
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(viewModel.forecast) { day in
                        ForecastCard(day: day)
                    }
                }
                .padding(.horizontal)
            }
            Spacer()
        }
    }
    func geocodeCityName(_ city: String) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(city) { placemarks, error in
            if let coordinate = placemarks?.first?.location?.coordinate {
                viewModel.fetchWeather(for: coordinate.latitude, longitude: coordinate.longitude)
            } else {
                print("Geocoding Hatası: \(error?.localizedDescription ?? "Unknown Error")")
            }
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


