import Foundation
import Combine
import SwiftUI

struct APIError: Error {
    var message: String
}

class APIManager {
    static let shared = APIManager()
   
    func fetchData(from endPoint: APIManager.APIEndPoint) -> AnyPublisher<Data, Error> {
       
        guard var urlComponents = URLComponents(string: endPoint.baseUrl) else {
            return Fail(error: APIError(message: "Invalid URL")).eraseToAnyPublisher()
        }
        
        urlComponents.path = endPoint.path
        urlComponents.queryItems = endPoint.queryItems
        
        guard let url = urlComponents.url else {
            return Fail(error: APIError(message: "Invalid URL")).eraseToAnyPublisher()
        }
        print("APIManager.APIEndPoint ---->", url)
        return URLSession.shared.dataTaskPublisher(for: url)
            .mapError { error in
                APIError(message: error.localizedDescription)
            }
            .map(\.data)
            .eraseToAnyPublisher()
    }
}

class WeatherViewModel: ObservableObject {
    @Published var locationModel: [LocationModel] = []
    @Published var error: Error? = nil
    @Published var weatherDetialModel: WeatherForecastResponse?

    var cancellables = Set<AnyCancellable>()
    
//
    func getLocationSearchData(query: String)-> AnyPublisher<Result<[LocationModel], Error>, Never>{
          
            let subject = PassthroughSubject<Result<[LocationModel], Error>, Never>()
            let endPoint = APIManager.APIEndPoint.locationSearch(query: query)
           
            //let weatherUrl = APIManager.APIEndPoint.locationSearch(query: query).url
            APIManager.shared.fetchData(from: endPoint)
                .subscribe(on: DispatchQueue.global(qos: .background))
                .receive(on: DispatchQueue.main)
                .tryMap(handleLocationData)
                .decode(type: [LocationModel].self, decoder: JSONDecoder())
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        self.error = error
                        subject.send(.failure(error))
                    }
                }, receiveValue: { [weak self] receivedData in
                    self?.locationModel = receivedData
                    subject.send(.success(receivedData))
                })
                .store(in: &cancellables)
        
            return subject.eraseToAnyPublisher()
        }
    
    func getLocationDetailData(query: String, days: Int, alert: Bool) -> AnyPublisher<Result<WeatherForecastResponse, Error>, Never> {
        let subject = PassthroughSubject<Result<WeatherForecastResponse, Error>, Never>()

        let endPoint = APIManager.APIEndPoint.locationDetail(query: query, days: days, alert: alert)

        APIManager.shared.fetchData(from: endPoint)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .tryMap(handleForeCastData)
            .decode(type: WeatherForecastResponse.self, decoder: JSONDecoder())
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.error = error
                    subject.send(.failure(error))
                }
            }, receiveValue: { [weak self] receivedData in
                self?.weatherDetialModel = receivedData
                subject.send(.success(receivedData))
            })
            .store(in: &cancellables)
        
        return subject.eraseToAnyPublisher()
    }
 
    
    private func handleLocationData(output: Data) throws -> Data {
        do {
            let _ = try JSONDecoder().decode([LocationModel].self, from: output)
            return output
        } catch {
            //errorMessage = "Error decoding data: \(error.localizedDescription)"
            throw error
        }
    }
    
    private func handleForeCastData(output: Data) throws -> Data {
        do {
            let _ = try JSONDecoder().decode(WeatherForecastResponse.self, from: output)
           
            return output
        } catch {
          
            throw error
        }
    }
}


extension APIManager {
    enum APIEndPoint {
        case locationSearch(query: String)
        case locationDetail(query: String, days: Int, alert: Bool)
        
        private static let locationAPIKey = "819a583174c74b869b865720233007"
        
        var url: URL {
           var urlComponents = URLComponents(string: baseUrl)
           urlComponents?.path = path
           urlComponents?.queryItems = queryItems
           
           guard let url = urlComponents?.url else {
              fatalError("Invalid URL")
           }
           
           return url
        }
        
        var baseUrl: String {
            switch self {
            case .locationSearch:
                return "https://api.weatherapi.com"
            case .locationDetail:
                return "https://api.weatherapi.com"
            }
        }
        
        var path: String {
            switch self {
            case .locationSearch:
                return "/v1/search.json"
            case .locationDetail:
                return "/v1/forecast.json"
            }
        }
        
        var queryItems: [URLQueryItem] {
            var items: [URLQueryItem] = [
                URLQueryItem(name: "key", value: APIEndPoint.locationAPIKey)
            ]
            
            switch self {
            case .locationSearch(let query):
                items.append(URLQueryItem(name: "q", value: query))
            case .locationDetail(let query, let days, let alert):
                items.append(URLQueryItem(name: "q", value: query))
                items.append(URLQueryItem(name: "days", value: String(days)))
                items.append(URLQueryItem(name: "alerts", value: alert ? "yes" : "no"))
            }
            return items
        }
    }
}

struct LocationModel: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
    let region: String?
    let country: String
    let lat: Double
    let lon: Double
    let url: String

    var displayName: String {
        return [name, region, country].compactMap { $0 }.joined(separator: ", ")
    }
}

