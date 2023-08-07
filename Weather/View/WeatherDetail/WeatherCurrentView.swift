//
//  WeatherCurrentView.swift
//  Weather
//
//  Created by Mano on 04/08/23.
//

import Foundation
import SwiftUI

struct WeatherCurrentView: View {
    var iconImage: String
    var title: String
    var value: String
    var showAdditionalInfo: Bool
    var sunRise: String
    var sunSet: String
    var isWind: Bool
    
    
    var body: some View {
        VStack {
            HStack {
                ZStack {
                    VStack(spacing: 10) {
                        HStack {
                            Image(systemName: iconImage)
                                .font(.system(size: 16))
                                .foregroundColor(Color.constantBlack)
                                .frame(width: 12, height: 16)
                            Text(title)
                                .font(Font.customAvenir(size: 14))
                                .foregroundColor(Color(red: 0.21, green: 0.29, blue: 0.49))
                            Spacer()
                        }

                        HStack {
                            if showAdditionalInfo{
                                
                                HStack(spacing: 2){
                                    HStack{
                                    Image(systemName: "sunrise")
                                        .font(.system(size: 13))
                                        .foregroundColor(Color.constantBlack)
                                        .frame(width: 12, height: 14)
                                    Text(sunRise)
                                        .font(Font.customAvenir(size: 13)).fontWeight(.medium)
                                        .foregroundColor(Color(red: 0.19, green: 0.19, blue: 0.19))
                                       // .frame(width: 18, height: 14)
                                        
                                    }
                                    Spacer(minLength: 0)
                                    HStack{
                                    Image(systemName: "sunset")
                                        .font(.system(size: 13))
                                        .foregroundColor(Color.constantBlack)
                                        .frame(width: 12, height: 14)

                                    Text(sunSet)
                                        .font(Font.customAvenir(size: 13)).fontWeight(.medium)
                                        .foregroundColor(Color(red: 0.19, green: 0.19, blue: 0.19))

                                    }
                                   
                                }
                                .frame( height: 25)
                               
                                
        
                            }else{
                                Text(value)
                                    .font(Font.customAvenir(size: 18))
                                    .fontWeight(.medium)
                                    .foregroundColor(Color(red: 0.19, green: 0.19, blue: 0.19))
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.4)
                                Spacer()
                            }
                        }
                    }
                    .padding(8.0)
                }
                
                if isWind {
                    Text(sunRise)
                        .font(Font.customAvenir(size: 26))
                        .fontWeight(.medium)
                        .padding(.horizontal)
                        .lineLimit(1)
                        .minimumScaleFactor(0.4)
                    
                
                }
            }
        }
        .frame(height: 73)
        .background(Color(red: 0.99, green: 0.98, blue: 0.95))
        .cornerRadius(8)
    }
}
