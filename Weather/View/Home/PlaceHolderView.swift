//
//  File.swift
//  Weather
//
//  Created by Mano on 03/08/23.
//

import Foundation
import SwiftUI

struct PlaceHolderView: View {
    var isWeatherIcon: Bool // Add a boolean property to determine the weather icon
    var weatherText: String // Add a property to store the weather text
    
    var body: some View {
        VStack {
            CustomImageView(imageName: isWeatherIcon ? "cloud.sun.rain" : "error-dark", showIcon: isWeatherIcon)
                .font(.system(size: 65))
                .padding()
                .foregroundColor(Color.customLightGray)
                .frame(height: 120.0)

            Text(weatherText)
                .font(Font.customAvenir(size: 18))
                .multilineTextAlignment(.center)
                .foregroundColor(Color.customLightGray)
                .frame(alignment: .top)

        }
        .padding([.vertical, .horizontal], 50.0)
    }
}

struct CustomImageView: View {
    var imageName: String
    var showIcon: Bool

    var body: some View {
        if showIcon {
            Image(systemName: imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
        } else {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
               
        }
    }
}
