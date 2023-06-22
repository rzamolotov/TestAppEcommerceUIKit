//
//  NetworkManager.swift
//  TestAppEcommerce
//
//  Created by Роман Замолотов on 22.06.2023.
//

import Foundation
import CoreLocation

protocol NetworkManagerDelegate {
    func didUpdateData(_ networkManager: NetworkManager, model: ItemsModel)
    func didFailWithError(error: Error)
    
}

struct NetworkManager {
    
    let itemsURL =  "  "
    
    var delegate: NetworkManagerDelegate?
    
    func fetchWeather(cityName: String) {
        let urlString = "\(itemsURL)&q=\(cityName)"
        performRequest(with: urlString)
    } // получаем название города для того чтобы добватьб его в урл
    
    func fetchCurentLocation(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let  urlString = "\(itemsURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    } //получаем урл из широты и долготы
    
    func performRequest(with urlString: String) {
        //1. Create a URL
        if let url  = URL(string: urlString) {
            //2. Create a URLSession
            let session = URLSession(configuration: .default)
            //3. Give the session a task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                } // если ошибка не равна нулю возвращаем функцию и продолжаем работать, если есть ошибка - печатаем ее в консоле
                if let safeData = data {
                    if let itemsData = self.parseJSON(safeData) {
                        self.delegate?.didUpdateData(self, model: itemsData)
                    }
                }
            }
            //4. Start the task
            task.resume()
        }
    }
    
    func parseJSON(_ itemsData: Data) -> ItemsModel? {
        let decoder = JSONDecoder() // создаем константу декодирования
        do {
            let decodedData = try decoder.decode(ItemsModel.self, from: itemsData) //выбираем, что декодировать
        let items = ItemsModel() // создаем объект
            return items
            
        } catch {
            delegate?.didFailWithError(error: error) // если не получается декодировать данные пишем ошибку
            return nil
        }
    }
}
