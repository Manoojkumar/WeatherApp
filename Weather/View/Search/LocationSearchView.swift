//
//  LocationSearchView.swift
//  Weather
//
//  Created by Mano on 30/07/23.
//

import SwiftUI

struct LocationSearchView: View {
    
    @State private var searchText = ""
    @StateObject private var viewModel = WeatherViewModel()
    @State private var isEditing: Bool = false
    @State private var checkData = false
    @StateObject private var locationManager = LocationManager()
    @SceneStorage("isLocationPermissionRequested") private var isLocationPermissionRequested = false
    
    @State private var selectedLocation: String? = nil
    @State private var showingSettingsAlert = false
    @State private var errorMessage = ""
    @State private var toast: FancyToast? = nil
    
    var userLatitude: String {
        return "\(locationManager.lastLocation?.coordinate.latitude ?? 0)"
    }
    
    var userLongitude: String {
        return "\(locationManager.lastLocation?.coordinate.longitude ?? 0)"
    }
    
    var body: some View {
        
        NavigationView {
            VStack {
                // Search view
                VStack{
                    SearchBar(searchText:  $searchText, checkData:  $checkData, errorMessage: $errorMessage, toast: $toast, viewModel: viewModel,onEditingChanged: { isEditing in
                    self.isEditing = isEditing // Update the editing status in ContentView
                })
                .padding(.top, 20.0)
                .padding(.horizontal, 6.0)
                    
                    
                    
                    Button(action: {
                        if let status = locationManager.locationStatus {
                            switch status {
                            case .denied,.restricted:
                                showingSettingsAlert = true
                    
                            default: showingSettingsAlert = false
                            }
                        }

                    }) {
                        if self.showingSettingsAlert {
                            CurrentLocation()
                        }else{
                            NavigationLink(destination: WeatherDetail(selectedLocation: "\(userLatitude),\(userLongitude)")) {
                                CurrentLocation()
                            }
                        }
                    }
                    .padding(.leading)
                    
                }
                
                if isEditing || searchText.count != 0{
                    if checkData{
                        PlaceHolderView(isWeatherIcon: false, weatherText: Constants.NoLocation)
                        Spacer()
                    }else{
                        List {
                            ForEach(viewModel.locationModel, id:\.self) {
                                searchText in
                                ZStack{
                                    
                                NavigationLink(destination: WeatherDetail(selectedLocation: searchText.name)) {
                                    EmptyView()
                                }.opacity(0.0)
                                    Text(searchText.displayName)
                                        .font(Font.customAvenir(size: 15).weight(.medium))
                                        .frame(maxHeight: .infinity, alignment: .leading)
                                        .multilineTextAlignment(.leading)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                            .padding(.horizontal, 6.0)
                        }
                        .hasScrollEnabled(false)
                        .background(Color.clear)
                        .listStyle(PlainListStyle())
                        
                    }
                }else{
                    PlaceHolderView(isWeatherIcon: true, weatherText: Constants.SearchPlaceholder)
                    Spacer()
                }
                
            }
            .navigationBarTitle(Text("Weather App"))
            .resignKeyboardOnDragGesture()
            .overlay(self.showingSettingsAlert ? (ZStack{ Color.black.opacity(0.3).edgesIgnoringSafeArea(.all)
                                                    CustomAlertView(title: "Weather App", message: "Weather App need your location permission to get current location ", primaryButtonLabel: "Go To Setting", primaryButtonAction: {openSettings()}, secondaryButtonLabel: "Cancel", secondaryButtonAction: {self.showingSettingsAlert = false},
                                                        image: Image(systemName: "exclamationmark.triangle"))
            .padding()
            .animation(.easeIn)})
            : nil)
        }
        .toastView(toast: $toast)
        .navigationBarHidden(true)
    }
    
    private func openSettings() {
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
    }

}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LocationSearchView()
                .environment(\.colorScheme, .light)
        }
    }
}







struct CurrentLocation: View {
    var body: some View {
        HStack {
            Image(systemName: "location").foregroundColor(Color.customButtonColor)
            Text("Current Location")
                .font(Font.customAvenir(size: 16))
                .foregroundColor(Color.customButtonColor)
            Spacer()
            
        }
        .padding()
    }
}
