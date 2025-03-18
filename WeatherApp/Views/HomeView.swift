//
//  HomeView.swift
//  WeatherApp
//
//  Created by Mehdi Oturak on 18.03.2025.
//

import SwiftUI

struct HomeView: View {
    @State private var city: String = ""
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
                Image(systemName: "cloud.rain.fill")
                    .font(.system(size: 100))
                    
                VStack {
                    TextField("Şehrin adını girin..", text: $city)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .background(Color.white.opacity(0.3))
                        .cornerRadius(10)
                        .shadow(radius: 5)
                    Button (action: {
                        viewModel.getWeather(for: city)
                    }) {
                        Text("Tıklayınız")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                    }
                    
                    
                    Text(viewModel.temperature + "°C")
                        .font(.system(size: 64, weight: .bold))
                        .padding()
                        .scaleEffect(viewModel.temperature == "--" ? 1.0 : 1.2)
                        .animation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 0.5))
                    
                    Text(viewModel.weatherDescription)
                        .font(.title2)
                        .padding()
                        .opacity(viewModel.weatherDescription == "loading..." ? 0.5: 1.0)
                        .animation(.easeInOut(duration: 0.5))
                    
                    if let url = URL(string: viewModel.iconUrl) {
                        AsyncImage(url: url) { image in
                            image.resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                        } placeholder: {
                            ProgressView()
                        }
                    }
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(viewModel.forecast, id: \.date) { day in
                                VStack {
                                    Text(day.date)
                                        .font(.caption)
                                    AsyncImage(url: URL(string: "https:\(day.day.condition.icon)")) { image in
                                        image.resizable()
                                            .scaledToFit()
                                            .frame(width: 50, height: 50)
                                    } placeholder: {
                                        ProgressView()
                                    }
                                    Text("\(day.day.avgtemp_c, specifier: "%.1f")°C")
                                        .font(.headline)
                                }
                                .padding()
                                .background(Color.white.opacity(0.2))
                                .cornerRadius(10)
                                .shadow(radius: 5)
                            }
                        }
                        .padding()
                    }
                }
                .padding()
            }
        }
    }
}

#Preview {
    HomeView()
}
