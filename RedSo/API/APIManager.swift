//
//  RestManager.swift
//  RedSo
//
//  Created by 馬丹君 on 2019/9/3.
//  Copyright © 2019 MaJ. All rights reserved.
//

import Foundation
class APIManager {
    let catalogAPI:String = "/catalog"
    var webServiceProtocol:String = "https://"
    var baseURL:String
    init(baseURL:String) {
        self.baseURL = baseURL
    }
    
}
extension APIManager{
    func getAllData(type:String,completion: @escaping (Array<Result>) -> () ){
        var currentResult:Array<Result> = []
        for i in 0...9 {
            getData(page: i, type: type) { (currentData) in
                for j in 0..<currentData!.results.count{
                    currentResult.append((currentData?.results[j])!)
                }
                completion(currentResult)
            }
        }
    }
    
    func getData(page:Int,type:String,completion: @escaping (CurrentResults?) -> () ){
        var currentResult:CurrentResults?
        if let url = URL(string: "\(webServiceProtocol)\(baseURL)\(catalogAPI)?team=\(type)&page=\(page)"){
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                do{
                    currentResult = try JSONDecoder().decode(CurrentResults.self, from: data!)
                    completion(currentResult)
                }catch{
                    print(error)
                }
                
            }
            task.resume()
        }
    }
    
}
