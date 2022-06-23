//
//  RemoteDataService.swift
//  RestaurantNavigator
//
//  Created by student on 08.06.2022.
//

import Foundation
import UIKit

let errorStatusCode = [404 : "Bad request", 401 : "Unauthorized", 403 : "Forbidden", 500 : "Internal Server Error", 503 : "Service Unavailable", 402 : "Quota has been exceeded for this project"]

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

class RemoteDataService : DataService, RestaurantPageRemoteDataService {
    
    var dataContainer : RestaurantContainer = RestaurantContainer()
    
    func updateRestaurantData(afterUpdate : @escaping () -> Void) {
        // load all information about restaurants
        processDataFromURLAddress(from: URLAddresses.restaurants.stringFormat()) { firstData in
            guard let dataInStringFormat = String(data: firstData, encoding: .utf8) else {
                return
            }
            
            let resultDictionaryOfRestaurants = convertJSONStringToArrayOfDictionaries(dataInStringFormat, parser : parseStringToJSONElements)
            self.dataContainer.removeAll()
            for restaurant in resultDictionaryOfRestaurants {
                guard let title = restaurant.name, let address = restaurant.address, let description = restaurant.description, let id = restaurant.id,
                      let lat = restaurant.lat, let lon = restaurant.lon, let imagePaths = restaurant.imagePaths else {
                    continue
                }
                self.dataContainer.addRestaurant(title: title, address: address, description: description, id: id)
                
                // set restaurants coordinats
                self.dataContainer.setRestaurantCoordinats(lat: Double(lat), lon: Double(lon), for: id)
                
                // load pictures
                self.loadRestaurantPictures(from: imagePaths, for: id, afterUpdated: afterUpdate)
            }
            
            DispatchQueue.main.async {
                afterUpdate()
            }
        }
        // load reviews
        loadRestaurantReviews()
    }
    
    func loadRestaurantPictures(from urlAddresses : [String], for restaurantId : Int, afterUpdated : @escaping () -> Void) {
        for address in urlAddresses{
            processDataFromURLAddress(from: address) { firstImage in
                guard let image = UIImage(data: firstImage) else {
                    return
                }
                
                DispatchQueue.main.async {
                    self.dataContainer.addImageToGalery(for: restaurantId, newImage: image)
                    afterUpdated()
                }
            }
        }
    }
    
    func loadRestaurantReviews() {
        self.dataContainer.removeAllReviews()
        processDataFromURLAddress(from: URLAddresses.reviews.stringFormat()) {firstData in
            guard let dataInStringFormat = String(data: firstData, encoding: .utf8) else {
                return
            }
            let resultDictionaryOfReviews = convertJSONStringToArrayOfDictionaries(dataInStringFormat, parser : parseReviewStringToJSONElements)
            
            for review in resultDictionaryOfReviews {
                guard let id = review.restaurantId, let author = review.author, let text = review.reviewText, let date = review.date else {
                    continue
                }
                
                self.dataContainer.addReview(for: id, newReview: Review(author: author, reviewText: text, date: date))
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
    
    func addNewReview(author : String, text : String, restaurantId : Int, date : String) {
        
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
            
            if let _ = data {
                DispatchQueue.main.async {
                    self.updateRestaurantData() {}
                }
                
                /*let responseJSON = try? JSONSerialization.jsonObject(with: firstData, options: [])
                if let res = responseJSON as? [String: Any] {
                    print(res)
                }*/
            }
        }

        task.resume()
    }
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
                
        data = String(dataSecondPart[data.index(after: lastIndex)...]) // delete added element from string
        data.remove(at: data.startIndex) // delete ','
    }
    
    return result
}

/*func convertJSONStringToArrayOfDictionaries(_ str : String, parser : (String) -> [String]) -> [[String : Any]] {
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
}*/

struct JSONDictionary : Decodable {
    // review
    var restaurantId : Int?
    var author : String?
    var date : String?
    var reviewText : String?

    // restaurant
    var id: Int?
    var name: String?
    var description: String?
    var address: String?
    var lat: Float?
    var lon: Float?
    var imagePaths : [String]?
    
    enum CodingKeys : String, CodingKey {
        case restaurantId = "restaurantId"
        case author = "author"
        case date = "date"
        case reviewText = "reviewText"

        // restaurant
        case id = "id"
        case name = "name"
        case description = "description"
        case address = "address"
        case location = "location"
        case lat = "lat"
        case lon = "lon"
        case imagePaths = "imagePaths"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        do {
            restaurantId = try container.decode(Int.self, forKey: .restaurantId)
            author = try container.decode(String.self, forKey: .author)
            date = try container.decode(String.self, forKey: .date)
            reviewText = try container.decode(String.self, forKey: .reviewText)
            
        } catch {
            restaurantId = nil
            author = nil
            date = nil
            reviewText = nil
        }
        
        do {
            id = try container.decode(Int.self, forKey: .id)
            name = try container.decode(String.self, forKey: .name)
            description = try container.decode(String.self, forKey: .description)
            address = try container.decode(String.self, forKey: .address)
        
            let location = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .location)
            lat = try location.decode(Float.self, forKey: .lat)
            lon = try location.decode(Float.self, forKey: .lon)
            imagePaths = try container.decode([String].self, forKey: .imagePaths)
        } catch {
            id = nil
            name = nil
            description = nil
            address = nil
            lat = nil
            lon = nil
            imagePaths = nil
        }
    }
}

func convertJSONStringToDictionary(_ str : String) -> JSONDictionary? {
    let jsonData = Data(str.utf8)
    
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    
    var info : JSONDictionary?
    do {
        info = try decoder.decode(JSONDictionary.self, from: jsonData)
    } catch {
        print("Failed to decode JSON")
    }

    return info
}

func convertJSONStringToArrayOfDictionaries(_ str : String, parser : (String) -> [String]) -> [JSONDictionary] {
    let arrayOfStrings : [String] = parser(str)
    
    var result : [JSONDictionary] = []
    
    for element in arrayOfStrings {
        if let jsonDictionary = convertJSONStringToDictionary(element) {
            result.append(jsonDictionary)
        }
    }
    
    return result
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
