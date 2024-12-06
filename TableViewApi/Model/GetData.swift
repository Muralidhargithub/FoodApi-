//
//  GetData.swift
//  TableViewApi
//
//  Created by Muralidhar reddy Kakanuru on 12/1/24.
//

import Foundation
import UIKit

protocol GitData {
    func getdata<T: Decodable>(url:String, completion: @escaping @Sendable (T) -> Void)
    func getImage(url: String, completion: @escaping (UIImage?) -> Void)
}

final class DataGit: GitData{
    
    static let shared = DataGit()
    private let urlsession: URLSession
    private var imageCache = NSCache<NSString, UIImage>()
    private init(){
        let config = URLSessionConfiguration.default
        self.urlsession = URLSession(configuration: config)
    }
    
    func getdata<T: Decodable>(url:String, completion: @escaping @Sendable (T) -> Void){
        guard let serverurl = URL(string: url) else{
            print("invalid url")
            return
        }
        urlsession.dataTask(with: serverurl) { data, _, error in
            
            if let error = error {
                print("error \(error.localizedDescription)")
                return
            }
            guard let data = data else{
                print("no data")
                return
            }
            do{
                let decod = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async(){
                    completion(decod)
                }
            }
            catch{
                print("Decoding error: \(error)")
            }
        }.resume()
    }
    func getImage(url: String, completion: @escaping (UIImage?) -> Void){
        if let cachedImage = imageCache.object(forKey: url as NSString){
            completion(cachedImage)
            return
        }
        guard let url = URL(string: url) else {
            print("Invalid Image URL")
            completion(nil)
            return
        }
        urlsession.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Error fetching image: \(error.localizedDescription)")
                completion(nil)
                return
            }
            guard let data = data, let image = UIImage(data: data) else{
                print("Failed to load image data")
                completion(nil)
                return
            }
            self.imageCache.setObject(image, forKey: url.absoluteString as NSString)
            DispatchQueue.main.async{
                completion(image)
            }
        }.resume()
        
        
        
    }
    
}
