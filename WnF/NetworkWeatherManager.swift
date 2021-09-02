//
//  NetworkWeatherManager.swift
//  WnF
//
//  Created by Павел Кривцов on 02.09.2021.
//

import Foundation

class NetworkWeatherManager {
    
    var omCompletion: ((Weather) -> Void)?
    
    func fetchWeather() {
        let urlString = "https://api.weather.yandex.ru/v2/forecast?lat=55.75396&lon=37.620393&ru_RU"
        guard let url = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url)
        request.addValue(apiKey, forHTTPHeaderField: HTTPHeader)
        request.httpMethod = "GET"
        
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: request) { data, response, error in
            if let data = data {
                if let weather = self.parseJSOM(withData: data) {
                    self.omCompletion?(weather)
                }
            }
        }
        task.resume()
    }
    
    private func parseJSOM(withData data: Data) -> Weather? {
        let decoder = JSONDecoder()
        
        do {
            let weatherData = try decoder.decode(WeatherData.self, from: data)
            guard let weather = Weather(withWeatherData: weatherData) else { return nil }
            return weather
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return nil
    }
}
