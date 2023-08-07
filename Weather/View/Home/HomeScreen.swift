//
//  HomeScreen.swift
//  Weather
//
//  Created by Mano on 29/07/23.
//

import SwiftUI

struct Constants {
    static let SearchPlaceholder = "Search for a city or US/UK zip to check the weather"
    static let NoLocation = "Location not available"
}

struct HomeScreen: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject private var persistenceViewModel = PersistenceViewModel.shared
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Weather.date, ascending: true)],
        animation: .default)
    private var fetchWeather: FetchedResults<Weather>
    @StateObject private var viewModel = WeatherViewModel()
    @State private var toast: FancyToast? = nil
    @EnvironmentObject var networkMonitor: NetworkMonitor
  
    var body: some View {
        NavigationView {
            ScrollView{
                LazyVStack(alignment: .center, spacing: 20){
                    NavigationLink(destination: LocationSearchView()) {
                        SearchView()
                            .padding(.top, 10.0)
                            .padding(.horizontal, 6.0)
                    }
                    
                    if !fetchWeather.isEmpty{
                        
                        ForEach(fetchWeather) { data in
                            
                            NavigationLink(destination: WeatherDetail(selectedLocation: data.location ?? "")) {
                                AddedCityView(location: data.location ?? "" , country: data.country ?? "", temperature: data.temperature ?? "" , icon: data.icon ?? "", time: data.time ?? "")
                                    .padding([.leading,.trailing])
                                    .addButtonActions(leadingButtons:[] ,
                                                      trailingButton:  [.delete], onClick: { button in
                                                       
                                                        persistenceViewModel.deleteWeather(withName: data.location ?? ""){ success in
                                                            print("-->is deleted \(success)")
                                                            
                                                        }
                                                      })
                            }
                            
                        }
                    }else{
                        PlaceHolderView(isWeatherIcon: true, weatherText: Constants.SearchPlaceholder)
                    }
                    
                }
                .padding([.leading,.top,.bottom])
                
            }
            
            .onAppear(){
                fetchWeatherDataAndUpdate(){ state,error  in
                    if !state{
                        toast = FancyToast(type: .error, title: "Update Failed", message: "Failed to update location in added list.\(error ?? "")")
                    }
                }
            }
            .overlay(!networkMonitor.isConnected ? (ZStack{ Color.black.opacity(0.3).edgesIgnoringSafeArea(.all)
                                                    CustomAlertView(title: "No Network", message: "Check your internet connection", primaryButtonLabel: "ok", primaryButtonAction: {print(networkMonitor.isConnected)}, secondaryButtonLabel: nil, secondaryButtonAction: {},
                                                                    image: Image(systemName: "exclamationmark.triangle"))
                                                        .padding()
                                                        .animation(.none)})
                        : nil)
            
            .toastView(toast: $toast)
            .navigationBarTitle(Text("Weather App"))
        }
    }
    
    func fetchWeatherDataAndUpdate(completion: @escaping (Bool,String?)-> Void) {
        if !fetchWeather.isEmpty {
        for data in fetchWeather{
            viewModel.getLocationDetailData(query: data.location ?? "", days: 5, alert: true).sink { result in
                
                switch result {
                case .success(let response):
                    persistenceViewModel.updateWeather(location: data.location ?? "", newTemperature: response.current.temp_c, newTime: response.location.localtime, newIcon: response.current.condition.icon, isDay: response.current.is_day){
                        success in
                       
                        completion(true,nil)
                    }
                case .failure( let error):
                    completion(false,error.localizedDescription)
                   
                }
            }
            .store(in: &viewModel.cancellables)
        }
            
        }
    }
}
    


struct SearchView: View {
    
    var body: some View {
        
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                
                Text("City, Region or US/UK zip code")
                    .frame(height: 35)
                    .foregroundColor( Color.customLightGray)
                    .font(Font.customAvenir(size: 16))
                Spacer()
                
            }
            .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
            .foregroundColor(Color.customLightGray)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(10.0)
        }
        
    }
}


struct AddedCityView: View{
    var location: String
    var country: String
    var temperature: String
    var icon: String
    var time: String
    
    var body: some View {
        
        VStack{
            HStack{
                Text(location)
                    .font(Font.customNewYork(size: 24))
                    .foregroundColor(.customTextColor)
                Spacer()
                HStack{
                    Text(temperature)
                        .font(Font.customAvenir(size: 24))
                        .foregroundColor(.customTextColor)
                    Image(icon)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 35, height: 35)
                }
            }
            HStack{
                Text(country)
                    .font(Font.customAvenir(size: 14)).fontWeight(.light)
                    .foregroundColor(.customTextColor)
                
                Spacer()
                Text(time)
                    .font(Font.customAvenir(size: 14)).fontWeight(.light)
                    .foregroundColor(.customLightGray)
                
            }
            Rectangle()
                .frame(height: 0.5)
                .foregroundColor(Color.customLightGray)
                .padding(.top, 0.5)
        }
    }
}


struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
    }
}

