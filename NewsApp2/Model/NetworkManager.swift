//
//  NetworkManager.swift
//  NewsApp2
//
//  Created by 이가을 on 6/22/24.
//

import Foundation

protocol NetworkManagerDelegate {
    func didUpdateArticles(_ updatedArticles: [Article])
    func didFailWithError(error: Error)
}

final class NetworkManager {

    static let shared = NetworkManager()
    private init() {}
    
    var delegate: NetworkManagerDelegate?
    
    func fetchArticles() {
        let url = "https://newsapi.org/v2/top-headlines?apiKey=\(K.apiKey)&country=kr"
        print(url)
        performRequest(with: url)
    }
    
    func fetchArticles(searchFor: String) {
        let url = "https://newsapi.org/v2/everything?apiKey=\(K.apiKey)&q=\(searchFor)"
        print(url)
        performRequest(with: url)
    }
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let articles = self.parseJSON(safeData) {
                        print(#function)
                        print("count: \(articles.count)")
                        self.delegate?.didUpdateArticles(articles)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ articleData: Data) -> [Article]? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(ArticleData.self, from: articleData)
            let updatedArticles = decodedData.articles
            
            let filterdArticles = updatedArticles.filter { article in
                return article.title != "[Removed]"
            }
            
            return filterdArticles
        } catch {
            print(#function)
            self.delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
