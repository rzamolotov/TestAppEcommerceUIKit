//
//  NetworkManager.swift
//  TestAppEcommerce
//
//  Created by Роман Замолотов on 22.06.2023.
//

import Foundation
import CoreLocation

protocol NetworkManagerDelegate {
    func didUpdateProduct(_ networkManager: NetworkManager, product: Product)
    func didFailWithError(error: Error)
    
}

struct NetworkManager {
    
    let productsURL =  "  "
    
    var delegate: NetworkManagerDelegate?
    
    func fetchWeather(cityName: String) {
        let urlString = "\(productsURL)&q=\(cityName)"
        performRequest(with: urlString)
    } // получаем название города для того чтобы добватьб его в урл
    
    func fetchCurentLocation(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let  urlString = "\(productsURL)&lat=\(latitude)&lon=\(longitude)"
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
                    if let productData = self.parseJSON(safeData) {
                        self.delegate?.didUpdateProduct(self, product: productData)
                    }
                }
            }
            //4. Start the task
            task.resume()
        }
    }
    
    func parseJSON(_ product: Data) -> Product? {
        let decoder = JSONDecoder() // создаем константу декодирования
        do {
            let decodedData = try decoder.decode(Product.self, from: product) //выбираем, что декодировать
            let title = decodedData.title
            let size = decodedData.size
            let price_photo = decodedData.price_photo
            let imageLink = decodedData.image_link
            let description = decodedData.description
            let link = decodedData.link
          
            let category = decodedData.category

            let product = Product(id: UUID(),
                                  title: title,
                                  size: size,
                                  price_photo: price_photo,
                                  description: description,
                                  link: link,
                                  image_link: imageLink,
                                  category: category)
            return product
        } catch {
            delegate?.didFailWithError(error: error) // если не получается декодировать данные пишем ошибку
            return nil
        }
    }
}
