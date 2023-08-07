////
////  LocationData.swift
////  Weather
////
////  Created by Mano on 01/08/23.
////


import SwiftUI
import Foundation

// WeatherResponse Model
struct WeatherResponse: Codable {
    let weatherForecastResponse: WeatherForecastResponse
}

// WeatherForecastResponse Model
struct WeatherForecastResponse: Codable {
    let location: WeatherLocation
    let current: WeatherCurrent
    let forecast: WeatherForecastData
    let alerts: WeatherAlertData
    // You can add other properties like "alerts" if needed
}
// WeatherLocation Model
struct WeatherLocation: Codable,Hashable {
    let name: String
    let region: String
    let country: String
    let lat: Double
    let lon: Double
    let tz_id: String
    let localtime_epoch: Int
    let localtime: String
    
    var displayRegion: String {
            return [region, country].compactMap { $0 }.joined(separator: ", ")
        }
}

// WeatherCondition Model
struct WeatherCondition: Codable {
    let text: String
    let icon: String
    let code: Int
    
    }


// WeatherCurrent Model
struct WeatherCurrent: Codable {
    let last_updated_epoch: Int
    let last_updated: String
    let temp_c: Double
    let temp_f: Double
    let is_day: Int
    let condition: WeatherCondition
    let wind_mph: Double
    let wind_kph: Double
    let wind_degree: Int
    let wind_dir: String
    let pressure_mb: Double
    let pressure_in: Double
    let precip_mm: Double
    let precip_in: Double
    let humidity: Int
    let cloud: Int
    let feelslike_c: Double
    let feelslike_f: Double
    let vis_km: Double
    let vis_miles: Double
    let uv: Double
    let gust_mph: Double
    let gust_kph: Double
}

// WeatherForecast Model
struct WeatherForecast: Codable {
    let date: String
    let date_epoch: Int
    let day: WeatherForecastDay
    let astro: Astro
    let hour: [Hour]
   
}
struct Astro: Codable {
    let sunrise: String
    let sunset: String
    let moonrise: String
    let moonset: String
    let moon_phase: String
    let moon_illumination: String
    let is_moon_up: Int
    let is_sun_up: Int
}

struct Hour: Codable {
   
    let time_epoch: Int
    let time: String
    let temp_c: Double
    let temp_f: Double
    let is_day: Int
    let condition: WeatherCondition
    let wind_mph: Double
    let wind_kph: Double
    let wind_degree: Int
    let wind_dir: String
    let pressure_mb: Double
    let pressure_in: Double
    let precip_mm: Double
    let precip_in: Double
    let humidity: Int
    let cloud: Int
    let feelslike_c: Double
    let feelslike_f: Double
    let windchill_c: Double
    let windchill_f: Double
    let heatindex_c: Double
    let heatindex_f: Double
    let dewpoint_c: Double
    let dewpoint_f: Double
    let will_it_rain: Int
    let chance_of_rain: Int
    let will_it_snow: Int
    let chance_of_snow: Int
    let vis_km: Double
    let vis_miles: Double
    let gust_mph: Double
    let gust_kph: Double
    let uv: Double

}


// WeatherForecastData Model
struct WeatherForecastData: Codable {
    let forecastday: [WeatherForecast]
}

// WeatherForecastDay Model
struct WeatherForecastDay: Codable {
    let maxtemp_c: Double
    let maxtemp_f: Double
    let mintemp_c: Double
    let mintemp_f: Double
    let avgtemp_c: Double
    let avgtemp_f: Double
    let maxwind_mph: Double
    let maxwind_kph: Double
    let totalprecip_mm: Double
    let totalprecip_in: Double
    let totalsnow_cm: Double
    let avgvis_km: Double
    let avgvis_miles: Double
    let avghumidity: Double
    let daily_will_it_rain: Int
    let daily_chance_of_rain: Int
    let daily_will_it_snow: Int
    let daily_chance_of_snow: Int
    let condition: WeatherCondition
    let uv: Double
}


struct WeatherAlert: Codable,Hashable {
    let headline: String
    let msgtype: String
    let severity: String
    let urgency: String
    let areas: String
    let category: String
    let certainty: String
    let event: String
    let note: String
    let effective: String
    let expires: String
    let desc: String
    let instruction: String
    var id: Int {
            return headline.hashValue ^ event.hashValue ^ effective.hashValue
        }
}


struct WeatherAlertData: Codable {
    let alert: [WeatherAlert]
}
