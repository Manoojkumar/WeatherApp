//
//  TodayForeCaseView.swift
//  Weather
//
//  Created by Mano on 04/08/23.
//

import Foundation
import SwiftUI

struct TodayForecastView: View {
    
    var weatherStatus: String
    
    @ObservedObject private var model = WeatherViewModel()
    
    
    init(viewModel: WeatherViewModel,weatherStatus: String) {
        self.weatherStatus = weatherStatus
        self.model = viewModel
    }
    
    var body: some View {
        VStack{
            VStack {
                HStack{
                    Text(weatherStatus)
                        .font(Font.customAvenir(size: 16).weight(.medium))
                        .foregroundColor(Color.constantBlack)
                        .frame(alignment: .leading)
                        .padding([.top, .leading])
                    Spacer()
                }
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(height: 1)
                    .background(Color(red: 0.94, green: 0.94, blue: 0.94))
                    .padding(.top, -2)
                    .padding(.horizontal)
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 15.0) {
                    ForEach(filteredHours , id: \.time_epoch) { value in
                        HourView(time: value.time, icon: "\(value.is_day)/\(extractImageCode(from: value.condition.icon) ?? 113)", weather: "\(Int(value.temp_c))°c")
                    }
                }
            }
            
            .padding([.leading,.bottom])
            
        }
        .frame(height: 135)
        .background(Color(red: 0.96, green: 0.96, blue: 0.96))
        .cornerRadius(8)
        .padding()
        
    }
    
    private var filteredHours: [Hour] {
        let currentHour = Calendar.current.component(.hour, from: Date())
        
        let allHoursDay1 = model.weatherDetialModel?.forecast.forecastday[0].hour ?? []
        let allHoursDay2 = model.weatherDetialModel?.forecast.forecastday[1].hour ?? []
        
        let filteredHoursDay1 = filterHours(allHoursDay1, startingFrom: currentHour)
        let filteredHoursDay2 = filterHours(allHoursDay2, startingFrom: 0)
        
        return combinedFilteredHours(filteredHoursDay1, and: filteredHoursDay2, totalHours: 24)
    }
    
    private func filterHours(_ hours: [Hour], startingFrom startHour: Int) -> [Hour] {
        return hours.filter { hour in
            let hourValue = Int(formatTime(hour.time)) ?? -1
            return hourValue >= startHour
        }
    }
    
    private func combinedFilteredHours(_ hours1: [Hour], and hours2: [Hour], totalHours: Int) -> [Hour] {
        // let remainingHoursCount = totalHours - hours1.count
        let combinedHours = hours1 + hours2
        return Array(combinedHours.prefix(totalHours))
    }
    
}


struct HourView: View {
    var time: String
    var icon: String
    var weather: String
    
    var body: some View {
        VStack(spacing: 6) {
           
            Text(isCurrentHour(time) ? "Now" : formatTime(time))
                .font(Font.customAvenir(size: 12))
                .foregroundColor(Color.constantBlack)
            
            Image(icon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 25, height: 25)
  
            Text(weather)
                .font(Font.customAvenir(size: 12))
                .foregroundColor(Color.constantBlack)
            
        }.padding(.trailing)
    }
       
       private func isCurrentHour(_ time: String) -> Bool {
           let currentHour = Calendar.current.component(.hour, from: Date())
           let hour = Int(formatTime(time)) ?? -1 // Use -1 as a fallback value
           
           return hour == currentHour
       }
    
}
