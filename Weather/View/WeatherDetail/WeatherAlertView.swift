//
//  WeatherAlertView.swift
//  Weather
//
//  Created by Mano on 04/08/23.
//

import Foundation
import SwiftUI


struct WeatherAlertsView: View {
    var categoryName: String
    var headline: String
    var weatherDate: String
    var weatherDesc: String
    
    var body: some View {
        VStack {
            HStack{
                Spacer()
                HStack{
                    Text(categoryName)
                        .font(Font.customAvenir(size: 12)).fontWeight(.medium)
                        .foregroundColor(.white)
                        .padding([.horizontal])
                        
                }
                .foregroundColor(.clear)
                .frame(height: 23)
                .background(Color(red: 0.93, green: 0.55, blue: 0.19))
                .cornerRadius(4)
            }
            
            
            HStack {
                Text(headline)
                    .font(Font.custom("Avenir", size: 16))
                    .foregroundColor(.black)
                    
                Spacer()
            }
            HStack {
                Text(weatherDate)
                    .font(Font.custom("Avenir", size: 12))
                    .foregroundColor(Color(red: 0.55, green: 0.55, blue: 0.55))
                   
                Spacer()
            }
            HStack{
            Text(weatherDesc)
                .font(Font.custom("Avenir", size: 16))
                .foregroundColor(.black)
                .multilineTextAlignment(.leading)
                .padding(.top, 6)
                Spacer()
                
            }
        }
        .padding()
        .background(Color(red: 0.99, green: 0.98, blue: 0.95))
       
    }
}

struct WeatherAlertsSubView: View {
    
    @ObservedObject private var model = WeatherViewModel()
    
    private var alertModel: [WeatherAlert] {
        return model.weatherDetialModel?.alerts.alert ?? []
    }
    
    init(viewModel: WeatherViewModel) {
       
        self.model = viewModel
    }
    
    var body: some View {
        VStack {
            HStack{
                Image(systemName: "bell")
                    .foregroundColor(Color(UIColor(red: 0.21, green: 0.29, blue: 0.49, alpha: 1)))
                    .font(.system(size: 14))
                    .frame(width: 12, height: 14)
                    .padding(.leading)
                Text("Alerts")
                    .font(Font.custom("Avenir", size: 12))
                    .foregroundColor(Color(red: 0.21, green: 0.29, blue: 0.49))
                Spacer()
            }
            
            LazyVStack(spacing: 20){
                ForEach(alertModel,id: \.self){ data in
                    WeatherAlertsView(categoryName: data.category, headline: data.headline, weatherDate: "\(formatWeatherDate(data.effective))-\(formatWeatherDate(data.expires))", weatherDesc: data.desc)
                }
               
            }
           
            .cornerRadius(8)
            .padding(.horizontal)
        }
        
    }
    private func formatWeatherDate(_ dateString: String) -> String {
        let inputDateFormatter = ISO8601DateFormatter()
        let outputDateFormatter = DateFormatter()
        
        inputDateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        if let date = inputDateFormatter.date(from: dateString) {
            outputDateFormatter.dateFormat = "dd MMM, yyyy h:mm a"
            outputDateFormatter.locale = Locale(identifier: "en_US_POSIX")
            return outputDateFormatter.string(from: date)
        }
        
        return ""
    }
}
