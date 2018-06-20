//
//  BeverageController .swift
//  alphaWine
//
//  Created by Hayden Murdock on 6/4/18.
//  Copyright © 2018 Hayden Murdock. All rights reserved.
//

import Foundation
import UIKit
class BeverageController {
    
    static let shared = BeverageController()
    
    func fetchBeverage(with searchTerm: String,with pageNumber: Int, completion: @escaping ([Beverage]?)->Void){
        
      let trimmedString = searchTerm.replacingOccurrences(of: " ", with: "")
        
        let newURL = URL(string:"https:lcboapi.com/products?&access_key=MDpmOTEyMjhiOC02ODJmLTExZTgtOTVmNS1iM2MwZjI5N2Y0NDk6dUJoc0FyN1NtSmlBbjlsN3dVQ1VmYUhXVGZudEVhNjZ0WjZk&q=wine+\(trimmedString)&page=\(pageNumber)&per_page=40")!
        print("\(newURL)")
        
        let dataTask = URLSession.shared.dataTask(with: newURL) { (data, _, error) in
            if let data = data {
            do {
                let jsonDecoder = JSONDecoder()
                let decodedObject = try jsonDecoder.decode(JSONDictionary.self, from: data)
                let beverages = decodedObject.result
                completion(beverages)
            } catch let error {
                print("There was an error decoding the data: \(error.localizedDescription)")
                    completion(nil)
            }
        }
    }
    dataTask.resume()
}

    func fetchRandomBeverage(with pageNumber: Int, completion: @escaping ([Beverage]?)->Void){
        let newURL = URL(string:"https:lcboapi.com/products?&access_key=MDpmOTEyMjhiOC02ODJmLTExZTgtOTVmNS1iM2MwZjI5N2Y0NDk6dUJoc0FyN1NtSmlBbjlsN3dVQ1VmYUhXVGZudEVhNjZ0WjZk&q=wine&page=\(pageNumber)&per_page=5")!
        print("\(newURL)")
        
        let dataTask = URLSession.shared.dataTask(with: newURL) { (data, _, error) in
            if let data = data {
                do {
                    let jsonDecoder = JSONDecoder()
                    let decodedObject = try jsonDecoder.decode(JSONDictionary.self, from: data)
                    let beverages = decodedObject.result
                    completion(beverages)
                } catch let error {
                    print("There was an error decoding the data: \(error.localizedDescription)")
                    completion(nil)
                }
            }
        }
        dataTask.resume()
    }
        
    
    
    func fetchBeverageImage(with beverage: Beverage, completion: @escaping(UIImage?)->Void) {
        guard let url = beverage.image_url else { return }
        let datatask = URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let data = data {
                let image = UIImage(data: data)
                completion(image)
            }
            if let error = error {
                print(error.localizedDescription)
                completion(nil)
            }
        }
    datatask.resume()
    }
}
