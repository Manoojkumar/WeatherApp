//
//  WeatherDetail.swift
//  Weather
//
//  Created by Mano on 30/07/23.
//

import SwiftUI

struct WeatherDetail: View {
    
    let selectedLocation: String
    @StateObject private var viewModel = WeatherViewModel()
    @State private var isDataLoaded = false
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject private var persistenceViewModel = PersistenceViewModel.shared
    @State private var isLocationStored: Bool = false
    @State private var showAlert: Bool = false
    @State private var toast: FancyToast? = nil
    
    private var locationModel: WeatherLocation? {
        return viewModel.weatherDetialModel?.location
    }
    
    private var currentModel: WeatherCurrent? {
        return viewModel.weatherDetialModel?.current
    }
    
    private var forecastDataModel: WeatherForecastData? {
        return viewModel.weatherDetialModel?.forecast
    }
    
    var body: some View {
        ScrollView{
            VStack(spacing: 0){
               
                    HStack{
                        
                        Button(action:{
                            
                            NavigationUtil.popToRootView()
                            
                        }, label: {
                            Image(systemName: "arrow.left")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 20, height: 20)
                                .foregroundColor(Color.customTextColor)
                                .padding([.horizontal,.vertical])
                            
                        })
                        Spacer()
                        HStack{
                            if isLocationStored{
                                Button(action: {
                                    if let locationName = locationModel?.name{
                                    persistenceViewModel.deleteWeather(withName: locationName){ success in
                                        
                                        toast = FancyToast(type: .success, title: locationName, message: "\(locationName) region removed from favourite.")
                                        isLocationStored = false
                                    }
                                }else{
                                    toast = FancyToast(type: .error, title: selectedLocation, message: "not found.")
                                }
                                }, label: {
                                    ActionButton(imageName: "trash", label: "Remove", color: Color(red: 0.89, green: 0.3, blue: 0.3))
                                    
                                })
                            }else{
                                Button(action: {
                                    if let location = locationModel?.name,let region = locationModel?.region, let country = locationModel?.country,
                                       let tempVal = currentModel?.temp_c, let iconV = currentModel?.condition.icon,let time = locationModel?.localtime, let isDay = currentModel?.is_day {
                                        persistenceViewModel.insertWeather(location: location, temperature: tempVal, icon: iconV, country: country, time: time, region: region, isDay: isDay){ success in
                                            isLocationStored = success
                                            
                                            toast = FancyToast(type: .success, title: location, message: "\(location) region added as favourite.")
                                        }
                                    }
                                }, label: {
                                    ActionButton(imageName: "", label: "+Add", color: Color.buttonColor2)
                                })
                            }
                            
                        }
                        .padding([.horizontal,.vertical])
                        
                        
                    }
                    
                    VStack{
                        HStack{
                            VStack{
                                HStack{
                                    Text("\(locationModel?.name ?? "--")")
                                        .font(Font.customAvenir(size: 36))
                                        .foregroundColor(Color.customTextColor)
                                    Spacer()
                                }
                                HStack{
                                    Text(locationModel?.displayRegion ?? "--")
                                        .font(Font.customAvenir(size: 16))
                                        .foregroundColor(Color.customTextColor)
                                    Spacer()
                                }
                            }
                            .padding(.all)
                            Spacer()
                        }
                    }
                    HStack{
                        ZStack{
                            HStack{
                                Text("\(Int(currentModel?.temp_c ?? 0))")
                                    .font(
                                        Font.customAvenir(size: 120).weight(.black)
                                    )
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(Color.textColor2)
                                    .frame( height: 120)
                                
                                Text("°c")
                                    .font(Font.custom("Avenir", size: 40))
                                    .foregroundColor(Color.textColor2)
                                    .padding(.top, -30.0)
                                    .padding(.leading, 0.0)
                                Spacer()
                            }
                            .padding()
                            
                            HStack {
                                Spacer()
                                
                                Image("\(currentModel?.is_day ?? 0)/\(extractImageCode(from: currentModel?.condition.icon ?? "") ?? 112)")
                                    .font(.system(size: 80))
                                    .foregroundColor(Color.customTextColor)
                                    .frame(width: 80,height: 80.0)
                                
                            }
                            .padding()
                            
                        }
                        
                    }
                    ZStack{
                        
                        
                        HStack(spacing: 20){
                            HStack{
                                Image(systemName: "arrow.up")
                                    .font(.system(size: 18))
                                    .foregroundColor(Color.customTextColor)
                                    .frame(width: 12, height: 14)
                                
                                Text("\(Int(forecastDataModel?.forecastday[0].day.maxtemp_c ?? 0))°c")
                                    .font(Font.customAvenir(size: 16))
                                    .foregroundColor(Color.customTextColor)
                                
                            }
                            HStack{
                                Image(systemName: "arrow.down")
                                    .font(.system(size: 18))
                                    .foregroundColor(Color.customTextColor)
                                    .frame(width: 12, height: 14)
                                
                                Text("\(Int(forecastDataModel?.forecastday[0].day.mintemp_c ?? 0))°c")
                                    .font(Font.customAvenir(size: 16))
                                    .foregroundColor(Color.customTextColor)
                                
                            }
                            
                            Spacer()
                            
                            Text("feels like \(Int(currentModel?.feelslike_c ?? 0))°c")
                                .font(
                                    Font.custom("Avenir", size: 16)
                                        .weight(.light)
                                )
                                .foregroundColor(Color.customTextColor)
                                .padding(.trailing, 12)
                        }
                        
                        
                    }
                    .padding(.leading, 20)
                    .padding(.top,-20)
                if isDataLoaded && !showAlert{
                    VStack(spacing:0){
                        
                        TodayForecastView(viewModel: viewModel, weatherStatus: forecastDataModel?.forecastday[0].day.condition.text ?? "")
                        FiveForecastView(viewModel: viewModel)
                        
                        VStack {
                            HStack(spacing: 15) {
                                if let precip_mm = currentModel?.precip_mm {
                                    WeatherCurrentView(iconImage: "cloud.rain", title: "Precipitation", value: "\(precip_mm) mm", showAdditionalInfo: false, sunRise: "", sunSet: "", isWind: false)
                                }
                                
                                if let wind_kph = currentModel?.wind_kph,
                                   let direction = currentModel?.wind_dir {
                                    WeatherCurrentView(iconImage: "wind", title: "Wind", value: "\(wind_kph) kph", showAdditionalInfo: false, sunRise: direction, sunSet: "", isWind: true)
                                }
                            }
                            
                            HStack(spacing: 15) {
                                if let uv = currentModel?.uv {
                                    WeatherCurrentView(iconImage: "sun.min", title: "UV index", value: "\(uv)", showAdditionalInfo: false, sunRise: "", sunSet: "", isWind: false)
                                }
                                
                                if let sunrise = forecastDataModel?.forecastday[0].astro.sunrise,
                                   let sunset = forecastDataModel?.forecastday[0].astro.sunset {
                                    WeatherCurrentView(iconImage: "sun.max", title: "Sun", value: "", showAdditionalInfo: true, sunRise: sunrise, sunSet: sunset, isWind: false)
                                }
                            }
                            
                            
                        }.padding()
                        
                        if viewModel.weatherDetialModel?.alerts.alert.count != 0{
                            WeatherAlertsSubView(viewModel: viewModel)
                        }
                    }
            }
                    
                
            }
            
            .onAppear(){
                isDataLoaded = false
                viewModel.getLocationDetailData(query: selectedLocation, days: 5, alert: true).sink { result in
                    switch result {
                    case .success(let response):
                        // Handle success with receivedData
                        isDataLoaded = true
                        viewModel.weatherDetialModel = response
                        
                     
                        isLocationStored = persistenceViewModel.isLocationNameStored(response.location.name)
                       
                    case .failure( _):
                        // Handle failure with error
                        isDataLoaded = true
                        showAlert = true
                    }
                }
                .store(in: &viewModel.cancellables)
            }
           
        }
        .overlay(!isDataLoaded ? (ZStack{ Color.gray.opacity(0.2).edgesIgnoringSafeArea(.all)
                        ProgressView()}) : nil)
        .overlay(showAlert ? (ZStack{ Color.black.opacity(0.3).edgesIgnoringSafeArea(.all)
                                CustomAlertView(title: "Error", message: viewModel.error?.localizedDescription, primaryButtonLabel: "ok", primaryButtonAction: {
            NavigationUtil.popToRootView()
            }, secondaryButtonLabel: nil, secondaryButtonAction: {}, image: Image(systemName: "exclamationmark.triangle"))
        .padding()
        .animation(.easeIn)})
        : nil)
       
        .navigationBarHidden(true)
        .toastView(toast: $toast)
        
    }

   
}

struct ActionButton: View {
    var imageName: String
    var label: String
    var color: Color
    
    var body: some View {
        HStack {
            Image(systemName: imageName)
                .frame(width: 18.1348, height: 14.8145)
                .foregroundColor(color)
            
            Text(label)
                .font(Font.customAvenir(size: 16))
                .foregroundColor(color)
        }
    }
}

struct WeatherDetail_Previews: PreviewProvider {
    static var previews: some View {
        WeatherDetail(selectedLocation: "china")
       //DetailView1()
    }
}






