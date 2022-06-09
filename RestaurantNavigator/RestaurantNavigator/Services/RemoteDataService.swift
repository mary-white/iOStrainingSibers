//
//  RemoteDataService.swift
//  RestaurantNavigator
//
//  Created by student on 08.06.2022.
//

import Foundation
import UIKit

let errorStatusCode = [404 : "Bad request", 401 : "Unauthorized", 403 : "Forbidden", 500 : "Internal Server Error", 503 : "Service Unavailable"]

class RemoteDataService : DataService {
    
    var dataContainer : RestaurantContainer = RestaurantContainer()
    var delegate : RestaurantListViewModel?
    
    enum URLAddresses {
        case allRestaurants, defaultMean
        func urlString() -> String {
            switch self {
            case .allRestaurants :
                return "https://restaurants-f64d7.firebaseio.com/restaurants.json"
            default :
                return ""
            }
        }
    }
    
    func updateRestaurantData() {
        stringDataFromURLAddress(urlAddress: URLAddresses.allRestaurants.urlString()) { firstData in
            guard let dataString = String(data: firstData, encoding: .utf8) else {
                return
            }
            let resultDictionaryOfRestaurants = convertJSONStringToArrayOfDictionaries(dataString)
            for restaurant in resultDictionaryOfRestaurants {
                guard let title = restaurant["name"], let address = restaurant["address"], let description = restaurant["description"], let id_str = restaurant["id"] else {
                    continue
                }
                
                let restaurantId = Int(String(describing: id_str)) ?? 0
                self.dataContainer.addRestaurant(title: String(describing: title), address: String(describing: address), description: String(describing: description), id: restaurantId)
                
                self.restaurantPictures(urlAddresses: (restaurant["imagePaths"])! as! [String], restaurantId: restaurantId)
            }
            
            DispatchQueue.main.async {
                self.delegate?.dataDidLoad()
            }
        }
    }
    
    func restaurantPictures(urlAddresses : [String], restaurantId : Int){
        for address in urlAddresses{
            stringDataFromURLAddress(urlAddress : address) { firstData in
                guard let image = UIImage(data: firstData) else {
                    return
                }
                
                DispatchQueue.main.async {
                    self.dataContainer.addImageToGalery(at_id: restaurantId, newImage: image)
                    self.delegate?.dataDidLoad()
                }
            }
        }
    }
    
    func stringDataFromURLAddress(urlAddress : String, requestHappened : @escaping (Data) -> Void) {
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
                requestHappened(firstData)
            }
        }

        task.resume()
    }
}

// json parser
/*struct Root: Codable {
    let result: [Result]
    let status: Status
}

struct Result: Codable {
    let id: Int
    let name, description: String
    let imagePaths : [String]
    let location_lat : Double
    let location_lon : Double
    
    let rating : Double

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case description = "description"
        case imagePaths = "imagePaths"
        case location_lat = "lat"
        case location_lon = "lon"
        case rating = "rating"
    }
}

struct Status: Codable {
    let httpStatusCode: Int
}

func decode(data : Data) {
    do {
        let decoder = JSONDecoder()
        let response = try decoder.decode(Root.self, from: data)
        print("cant")
        var allRes = response.result
        print(allRes)
    } catch {
        print(error)
    }
}*/

// my json parser

func parseStringToJSONElements(_ str : String) -> [String] {
    var result : [String] = []
    var data = str
    
    data.remove(at: data.startIndex) // delete '['
    
    while true {
        if let firstIndex = data.firstIndex(of: "}") { // because we have location {}
            let dataSecondPart = String(data[data.index(after: firstIndex)..<data.endIndex])
            if let lastIndex = dataSecondPart.firstIndex(of: "}") {
                let firstPart = String(data[..<data.index(after: firstIndex)])
                let secondPart = String(dataSecondPart[..<data.index(after: lastIndex)])
                let newElement = firstPart + secondPart
                
                result.append(newElement)
                
                data = String(dataSecondPart[data.index(after: lastIndex)...]) // delete added element
                data.remove(at: data.startIndex) // delete ','
            } else {
                break
            }
        } else {
            break
        }
    }
    
    return result
}

func convertJSONStringToArrayOfDictionaries(_ str : String) -> [[String : Any]] {
    let arrayOfStrings : [String] = parseStringToJSONElements(str)
    
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

protocol DataServiceDelegate : AnyObject {
    func didDataLoad()
}
