//
//  FiveForeCastView.swift
//  Weather
//
//  Created by Mano on 04/08/23.
//

import SwiftUI

struct FiveForecastView: View {
   
    @ObservedObject private var model = WeatherViewModel()
    
    private var forecastModel: [WeatherForecast] {
        return model.weatherDetialModel?.forecast.forecastday ?? []
    }
    
    init(viewModel: WeatherViewModel) {
       
        self.model = viewModel
    }
    
    var body: some View {
        VStack{
            VStack {
                HStack{
                    
                    Image(systemName: "calendar")
                        .frame(width: 15, height: 14)
                        .foregroundColor(Color(UIColor(red: 0.21, green: 0.29, blue: 0.49, alpha: 1)))
                    Text("\(model.weatherDetialModel?.forecast.forecastday.count ?? 0)-day forecast")
                        .font(Font.customAvenir(size: 12)).fontWeight(.medium)
                        .foregroundColor(Color(red: 0.21, green: 0.29, blue: 0.49))
                    
                    
                    Spacer()
                }
                .padding([.top, .leading, .trailing])
                
            }
            
            
            LazyVStack(spacing: 10.0) {
                ForEach(forecastModel, id: \.date_epoch) { data in
                    ForeCastDaysView(weekDayName: getWeekdayName(from: data.date) ?? "", iconName:"\(data.astro.is_sun_up)/\(extractImageCode(from: data.day.condition.icon) ?? 113)" , maxWeather: "\(Int(data.day.maxtemp_c))°c", minWeather: "\(Int(data.day.mintemp_c))°c")
                }
            }
            .padding([.leading, .bottom, .trailing])
            
        }
        .background(Color(red: 0.96, green: 0.96, blue: 0.96))
        .cornerRadius(8)
        .padding()
        
    }
    
    private func getWeekdayName(from dateString: String) -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yy-MM-dd"
        
        if let date = formatter.date(from: dateString) {
            let currentDate = Date() // Get the current date
            
            if Calendar.current.isDate(date, inSameDayAs: currentDate) {
                return "Today"
            }
            
            formatter.dateFormat = "EEEE"
            return formatter.string(from: date)
        }
        
        return nil
    }

}
struct ForeCastDaysView: View {
    var weekDayName: String
    var iconName: String
    var maxWeather: String
    var minWeather: String
    
    var body: some View {
        VStack(spacing: 0){
            
            ZStack{
                HStack{
                    Text(weekDayName)
                        .font(Font.custom("Avenir", size: 12))
                        .foregroundColor(Color(red: 0.19, green: 0.19, blue: 0.19))
                    Spacer()
                }
                
                HStack(spacing: 16){
                    Spacer()
                    Image(iconName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 25, height: 25)
                    
                    HStack{
                        Image(systemName: "arrow.up")
                            .font(.system(size: 14))
                            .foregroundColor(Color.constantBlack)
                            .frame(width: 12, height: 14)
                        
                        Text(maxWeather)
                            .font(Font.customAvenir(size: 14))
                            .foregroundColor(Color.constantBlack)
                        
                    }
                    HStack{
                        Image(systemName: "arrow.down")
                            .font(.system(size: 14))
                            .foregroundColor(Color.constantBlack)
                            .frame(width: 12, height: 14)
                        
                        Text(minWeather)
                            .font(Font.customAvenir(size: 14))
                            .foregroundColor(Color.constantBlack)
                        
                    }
                }
                
            }
            Rectangle()
                .foregroundColor(.clear)
                .frame(height: 1)
                .background(Color(red: 0.94, green: 0.94, blue: 0.94))
        }
    }
}


