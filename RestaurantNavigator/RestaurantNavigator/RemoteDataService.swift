//
//  RemoteDataService.swift
//  RestaurantNavigator
//
//  Created by student on 08.06.2022.
//

import Foundation

let errorStatusCode = [404 : "Bad request", 401 : "Unauthorized", 403 : "Forbidden", 500 : "Internal Server Error", 503 : "Service Unavailable"]

class RemoteDataService : DataService {
    
    init() {
        updateDataOfrestaurant()
    }
    
    func updateDataOfrestaurant() {
        guard let url = URL(string: "https://restaurants-f64d7.firebaseio.com/restaurants.json") else {
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
            
            if let firstData = data, let dataString = String(data: firstData, encoding: .utf8) {
                print(convertJSONStringToArrayOfDictionaries(dataString))
            }
        }

        task.resume()
    }
}

func parseStringToJSONElements(_ str : String) -> [String] {
    var result : [String] = []
    var data = str
    data.remove(at: data.startIndex)
    
    while true {
        if let firstIndex = data.firstIndex(of: "}") {
            let dataSecondPart = String(data[data.index(after: firstIndex)..<data.endIndex])
            if let lastIndex = dataSecondPart.firstIndex(of: "}") {
                let firstPart = String(data[..<data.index(after: firstIndex)])
                let secondPart = String(dataSecondPart[..<data.index(after: lastIndex)])
                let newElement = firstPart + secondPart
                
                result.append(newElement)
                
                data = String(dataSecondPart[data.index(after: lastIndex)...])
                data.remove(at: data.startIndex)
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
    let data = Data(str.utf8)
    
    do {
        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
            return json
        }
    } catch let error as NSError {
        print("Failed to load: \(error.localizedDescription)")
    }
    return [:]
}
