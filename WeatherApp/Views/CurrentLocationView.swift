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
        switch viewModel.weatherDescription.lowercased() {
        case let desc where desc.contains("sunny"):
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
                Text("Current Location Weather")
                    .font(.title)
                    .padding()
                
                if viewModel.temperature == "--" {
                    Text("konum alınıyor..")
                        .font(.title2)
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    Text(viewModel.temperature + "°C")
                        .font(.system(size: 64, weight: .bold))
                        .padding()
                    
                    Text(viewModel.weatherDescription)
                        .font(.title2)
                        .padding()
                    
                    if let url = URL(string: viewModel.iconUrl) {
                        AsyncImage(url: url) { image in
                            image.resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                        } placeholder: {
                            ProgressView()
                        }
                    }
                }
                
                
                Button(action: {
                    viewModel.getWeatherForCurrentLocation()
                }) {
                    Text("Refresh Location Weather")
                        .foregroundColor(Color.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            }
            .padding()
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { // konum güncellemesi için 1sn bekleme
                    viewModel.getWeatherForCurrentLocation()
                }
            }
        }
    }
}

#Preview {
    CurrentLocationView()
}
