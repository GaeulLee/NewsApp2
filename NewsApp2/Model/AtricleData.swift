//
//  AtricleData.swift
//  NewsApp2
//
//  Created by 이가을 on 6/22/24.
//

import Foundation

// MARK: - ArticleData
struct ArticleData: Codable {
    let articles: [Article]
}
    
// MARK: - Article
struct Article: Codable {
    let source: Source
    let title: String
    let description: String?
    let url: String
    let urlToImage: String?
    private let publishedAt: String
    
    var date: String {
        guard let isoDate = ISO8601DateFormatter().date(from: publishedAt ) else { return "" }
        
        let myFormatter = DateFormatter()
        myFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let dateString = myFormatter.string(from: isoDate)

        return dateString
    }
}

// MARK: - Source
struct Source: Codable {
    let name: String
}
