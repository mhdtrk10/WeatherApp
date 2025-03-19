//
//  WeatherAppApp.swift
//  WeatherApp
//
//  Created by Mehdi Oturak on 18.03.2025.
//

import SwiftUI

@main
struct WeatherAppApp: App {
    var body: some Scene {
        WindowGroup {
            
            NavigationStack {
                ZStack {
                    Color.blue.opacity(0.5)
                        .ignoresSafeArea(edges: .all)
                    VStack {
                        NavigationLink("Check My Location Weather", destination: CurrentLocationView())
                            .padding()
                            .frame(width: 300, height: 50)
                            .foregroundColor(Color.white)
                            .background(Color.blue)
                            .cornerRadius(10)
                        NavigationLink("Enter a City", destination: HomeView())
                            .padding()
                            .frame(width: 300, height: 50)
                            .foregroundColor(Color.white)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                }
            }
        }
    }
}
