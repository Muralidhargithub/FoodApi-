//
//  GetData.swift
//  TableViewApi
//
//  Created by Muralidhar reddy Kakanuru on 12/1/24.
//

import Foundation
import UIKit

protocol GitData {
    func getdata<T: Decodable>(url: String, completion: @escaping @Sendable (T) -> Void)
    //func getImage(url: String, completion: @escaping (UIImage?) -> Void)
}

final class DataGit: GitData {
    
    // MARK: - Properties
    static let shared = DataGit()
    private let urlSession: URLSession
    private var imageCache = NSCache<NSString, UIImage>()
    
    // MARK: - Initializer
    private init() {
        let config = URLSessionConfiguration.default
        self.urlSession = URLSession(configuration: config)
    }
    
    // MARK: - Data Fetching
    func getdata<T: Decodable>(url: String, completion: @escaping @Sendable (T) -> Void) {
        guard let serverURL = URL(string: url) else {
            print("Invalid URL")
            return
        }
        urlSession.dataTask(with: serverURL) { data, _, error in
            if let error = error {
                print("Error fetching data: \(error.localizedDescription)")
                return
            }
            guard let data = data else {
                print("No data received")
                return
            }
            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(decoded)
                }
            } catch {
                print("Decoding error: \(error)")
            }
        }.resume()
    }
    
    // MARK: - Image Fetching
    func getImage(url: String, completion: @escaping (UIImage?) -> Void) {
        if let cachedImage = imageCache.object(forKey: url as NSString) {
            completion(cachedImage)
            return
        }
        guard let imageURL = URL(string: url) else {
            print("Invalid Image URL")
            completion(nil)
            return
        }
        urlSession.dataTask(with: imageURL) { data, _, error in
            if let error = error {
                print("Error fetching image: \(error.localizedDescription)")
                completion(nil)
                return
            }
            guard let data = data, let image = UIImage(data: data) else {
                print("Failed to load image data")
                completion(nil)
                return
            }
            self.imageCache.setObject(image, forKey: imageURL.absoluteString as NSString)
            DispatchQueue.main.async {
                completion(image)
            }
        }.resume()
    }
}
