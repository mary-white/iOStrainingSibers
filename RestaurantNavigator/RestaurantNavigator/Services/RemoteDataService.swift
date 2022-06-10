//
//  RemoteDataService.swift
//  RestaurantNavigator
//
//  Created by student on 08.06.2022.
//

import Foundation
import UIKit

let errorStatusCode = [404 : "Bad request", 401 : "Unauthorized", 403 : "Forbidden", 500 : "Internal Server Error", 503 : "Service Unavailable"]

enum URLAddresses {
    case restaurants, reviews, defaultMean
    func stringFormat() -> String {
        switch self {
        case .restaurants :
            return "https://restaurants-f64d7.firebaseio.com/restaurants.json"
        case .reviews :
            return "https://restaurants-f64d7.firebaseio.com/reviews.json"
        default :
            return ""
        }
    }
}

class RemoteDataService : DataService {
    
    var dataContainer : RestaurantContainer = RestaurantContainer()
    weak var delegate : RemoteDataServiceDelegate?
    
    func updateRestaurantData() {
        // load all information about restaurants
        processDataFromURLAddress(from: URLAddresses.restaurants.stringFormat()) { firstData in
            guard let dataInStringFormat = String(data: firstData, encoding: .utf8) else {
                return
            }
            
            let resultDictionaryOfRestaurants = convertJSONStringToArrayOfDictionaries(dataInStringFormat, parser : parseStringToJSONElements)
            for restaurant in resultDictionaryOfRestaurants {
                guard let title = restaurant["name"], let address = restaurant["address"], let description = restaurant["description"], let id_str = restaurant["id"], let location_anyType = restaurant["location"], let imagePaths = restaurant["imagePaths"]  else {
                    continue
                }
                
                let restaurantId = Int(String(describing: id_str)) ?? 0
                self.dataContainer.addRestaurant(title: String(describing: title), address: String(describing: address), description: String(describing: description), id: restaurantId)
                
                // set restaurants coordinats
                let location = location_anyType as! [String:Double]
                self.dataContainer.setRestaurantCoordinats(lat: location["lat"] ?? 0.0, lon: location["lon"] ?? 0.0, for: restaurantId)
                
                // load pictures
                self.loadRestaurantPictures(from: imagePaths as! [String], for: restaurantId)
            }
            
            DispatchQueue.main.async {
                self.delegate?.dataDidLoad()
            }
        }
        // load reviews
        loadRestaurantReviews()
    }
    
    func loadRestaurantPictures(from urlAddresses : [String], for restaurantId : Int){
        for address in urlAddresses{
            processDataFromURLAddress(from: address) { firstImage in
                guard let image = UIImage(data: firstImage) else {
                    return
                }
                
                DispatchQueue.main.async {
                    self.dataContainer.addImageToGalery(for: restaurantId, newImage: image)
                    self.delegate?.dataDidLoad()
                }
            }
        }
    }
    
    func loadRestaurantReviews() {
        processDataFromURLAddress(from: URLAddresses.reviews.stringFormat()) {firstData in
            guard let dataInStringFormat = String(data: firstData, encoding: .utf8) else {
                return
            }
            let resultDictionaryOfReviews = convertJSONStringToArrayOfDictionaries(dataInStringFormat, parser : parseReviewStringToJSONElements)
            
            for review in resultDictionaryOfReviews {
                guard let id_str = review["restaurantId"], let author = review["author"], let text = review["reviewText"], let date = review["date"] else {
                    continue
                }
                
                let restaurantId = Int(String(describing: id_str)) ?? 0
                self.dataContainer.addReview(for: restaurantId, newReview: Review(author: String(describing: author), reviewText: String(describing: text), date: String(describing: date)))
            }
        }
    }
    
    func processDataFromURLAddress(from urlAddress : String, with processFunction : @escaping (Data) -> Void) {
        guard let url = URL(string: urlAddress) else {
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("URL response error: \(error)")
                return
            }
            
            if let response = response as? HTTPURLResponse, let responseError = errorStatusCode[response.statusCode] {
                print("Response HTTP Status code: \(response.statusCode)")
                print("Response error: " + responseError)
                return
            }
            
            if let firstData = data {
                processFunction(firstData)
            }
        }

        task.resume()
    }
    
    func addReview(author : String, text : String, restaurantId : Int, date : String) {
        if restaurantId == -1 {
            return
        }
        
        let rowData: [String: Any] = [
            "restaurantId": restaurantId,
            "author": author,
            "reviewText": text,
            "date": date
        ]

        let jsonDataToWrite = try? JSONSerialization.data(withJSONObject: rowData)

        guard let url = URL(string: URLAddresses.reviews.stringFormat()) else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonDataToWrite

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("URL response error: \(error)")
                return
            }
            
            if let response = response as? HTTPURLResponse, let responseError = errorStatusCode[response.statusCode] {
                print("Response HTTP Status code: \(response.statusCode)")
                print("Response error: " + responseError)
                return
            }
            
            if let firstData = data {
                let responseJSON = try? JSONSerialization.jsonObject(with: firstData, options: [])
                if let responseJSON = responseJSON as? [String: Any] {
                    print(responseJSON)
                }
            }
        }

        task.resume()
    }
}

protocol RemoteDataServiceDelegate : AnyObject {
    func dataDidLoad()
}

func parseStringToJSONElements(_ str : String) -> [String] {
    var result : [String] = []
    var data = str
    
    data.remove(at: data.startIndex) // delete '['
    
    while true {
        guard let firstIndex = data.firstIndex(of: "}") else { // because we have location {}
            break
        }

        let dataSecondPart = String(data[data.index(after: firstIndex)..<data.endIndex])
        
        guard let lastIndex = dataSecondPart.firstIndex(of: "}") else {
            break
        }
        
        let firstPart = String(data[..<data.index(after: firstIndex)])
        let secondPart = String(dataSecondPart[..<data.index(after: lastIndex)])
        let newElement = firstPart + secondPart
                
        result.append(newElement)
                
        data = String(dataSecondPart[data.index(after: lastIndex)...]) // delete added element
        data.remove(at: data.startIndex) // delete ','
    }
    
    return result
}

func convertJSONStringToArrayOfDictionaries(_ str : String, parser : (String) -> [String]) -> [[String : Any]] {
    let arrayOfStrings : [String] = parser(str)
    
    var result : [[String : Any]] = []
    
    for element in arrayOfStrings {
        result.append(convertJSONStringToDictionary(element))
    }
    
    return result
}

func convertJSONStringToDictionary(_ str : String) -> [String: Any] {
    let jsonData = Data(str.utf8)
    
    do {
        if let jsonDictionary = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
            return jsonDictionary
        }
    } catch let error as NSError {
        print("Failed to load: \(error.localizedDescription)")
    }
    return [:]
}

// convert review
func parseReviewStringToJSONElements(_ str : String) -> [String] {
    var result : [String] = []
    var data = str
    
    data.remove(at: data.startIndex) // delete '{'
    
    while true {
        guard let firstIndex = data.firstIndex(of: "{") else {
            break
        }
        // delete review id
        data = String(data[firstIndex...])
        
        guard let secondIndex = data.firstIndex(of: "}") else {
            break
        }
        
        let afterSecondIndex = data.index(after: secondIndex)
        let newElement = String(data[..<afterSecondIndex])
        result.append(newElement)
                
        data = String(data[afterSecondIndex...])
    }
    return result
}
