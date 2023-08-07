//
//  SearchBar.swift
//  Weather
//
//  Created by Mano on 29/07/23.
//

import Foundation

import SwiftUI

struct SearchBar: View {
    
    @Binding var searchText: String
    @State private var showCancelButton: Bool = false
    @ObservedObject private var viewModel = WeatherViewModel()
    @Binding var checkData: Bool
    @ObservedObject private var locationManager = LocationManager()
  
    @Binding var errorMessage: String
 
    @Binding var toast: FancyToast?
    
    var onEditingChanged: ((Bool) -> Void)?
    private let debouncer = Debouncer(delay: 0.5) // Adjust the delay time as needed
    
    init(searchText: Binding<String>,checkData: Binding<Bool>,errorMessage: Binding<String>,toast: Binding<FancyToast?>,viewModel: WeatherViewModel, onEditingChanged: ((Bool) -> Void)? = nil) {
        self._searchText = searchText
        self.viewModel = viewModel
        self.onEditingChanged = onEditingChanged
        self._checkData = checkData
       
        self._errorMessage = errorMessage
        
        self._toast = toast
    }
    
    var body: some View {
        VStack{
            HStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                   
                    // need to add first becomeFirstResponder but focused is not supporting in swift5 
                    TextField("City, Region or US/UK zip code", text: $searchText,onEditingChanged: { isEditing in
                        self.showCancelButton = true
                        onEditingChanged?(isEditing)
                    })
 
                    .frame(height: 35)
                    .foregroundColor(showCancelButton ? Color.customTextColor : Color.customLightGray)
                    .font(Font.customAvenir(size: 16))
                    
                    Button(action: {
                        self.searchText = ""
                        viewModel.locationModel.removeAll()
                    }) {
                        Image(systemName: "xmark.circle.fill").opacity(searchText == "" ? 0 : 1)
                    }
                }
                .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
                .foregroundColor(Color.customLightGray)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10.0)
                
                if showCancelButton  {
                    Button("Cancel") {
                        UIApplication.shared.endEditing(true) // this must be placed before the other commands here
                        viewModel.locationModel.removeAll()
                        self.searchText = ""
                        self.showCancelButton = false
                        
                    }
                    .foregroundColor(Color(.systemBlue))
                }
            }
            .padding(.horizontal)
        }
        
        .onChange(of: searchText) { newText in
            // Trigger the API call from the view model whenever the text changes
           
                viewModel.getLocationSearchData(query: newText).sink { result in
                    switch result {
                    case .success(_):
                        DispatchQueue.delay(2.0){
                            self.checkData = searchText.count > 1 && self.viewModel.locationModel.isEmpty
                        }
                    case .failure(let error):
//                        UIApplication.shared.endEditing(true) 
                        self.checkData = false
                        self.errorMessage = error.localizedDescription
                       

                    }
                }
                .store(in: &viewModel.cancellables)
                
            
        }
        
    }
}

