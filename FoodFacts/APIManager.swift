//
//  APIManager.swift
//  FoodFacts
//
//  Created by Archit Jain on 12/4/20.
//  Copyright © 2020 archit. All rights reserved.
//

import Foundation
import UIKit

class APIManager {
    
    static func getFoodFromImage(image: UIImage, onSuccess: @escaping (String) -> Void, onFailure: @escaping (String) -> Void){
        
        let boundary = UUID().uuidString
        let api_token = "3712982aeace39bc1f0792cabfb2caab27c7da5c"
        let url = URL(string: "https://api.logmeal.es/v2/recognition/dish")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(api_token)", forHTTPHeaderField: "Authorization")
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var data = Data()
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"image\"; filename=\"image.jpeg\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
        data.append(image.jpegData(compressionQuality: 1)!)
        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        
        URLSession.shared.uploadTask(with: request, from: data){data,
            response, error in
            if error != nil {
                DispatchQueue.main.async {onFailure(error!.localizedDescription)}
            }
            if let data = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any]{
                if data.keys.contains("recognition_results"){
                    if let recognitionOptions = try? data["recognition_results"] as! [[String: Any]] {
                        if recognitionOptions.count > 0{
                            DispatchQueue.main.async {onSuccess(recognitionOptions[0]["name"] as! String)}
                        }
                    }
                }
                else{
                    DispatchQueue.main.async {onFailure("Could not identify item!")}
                }
            }
        }.resume()
    }
    
    static func getNutritionDetails(foodItem: String, onSuccess: @escaping ([NSDictionary]) -> Void, onFailure: @escaping (String) -> Void){
        
        let url = "https://api.nal.usda.gov/fdc/v1/foods/search?"
        let key = "0W3hjLg8oNFCqQmj0H0uJcgc9yEgrZ8ZrTFVPc1E"
        let item = foodItem
        sendRequest(url: url, parameters: ["query": item, "api_key": key]){ responseObject, error in
            if error != nil {
                DispatchQueue.main.async {onFailure(error!.localizedDescription)}
            }
            if let responseObject = responseObject{
                let nutrients = responseObject["foods"] as! [NSDictionary]
                let nutrient = nutrients[0]
                let foodNutrition = nutrient["foodNutrients"] as! [NSDictionary]
                DispatchQueue.main.async {onSuccess(foodNutrition)}
            }
        }
    }
    
    
    static func sendRequest(url: String, parameters: [String: String], completion: @escaping ([String: Any]?, Error?) -> Void) {
        var components = URLComponents(string: url)!
        components.queryItems = parameters.map { (key, value) in
            URLQueryItem(name: key, value: value)
        }
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        let request = URLRequest(url: components.url!)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,
                let response = response as? HTTPURLResponse,
                (200 ..< 300) ~= response.statusCode,
                error == nil else {
                    completion(nil, error)
                    return
            }
            let responseObject = (try? JSONSerialization.jsonObject(with: data)) as? [String: Any]
            completion(responseObject, nil)
        }
        task.resume()
    }
}


