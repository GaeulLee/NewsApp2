//
//  RealmManager.swift
//  NewsApp2
//
//  Created by 이가을 on 6/26/24.
//

import Foundation
import RealmSwift

protocol RealmManagerDelegate {
    func successToDeleteAnArticle()
}

class RealmManager {
    
    static let shared = RealmManager()
    private init() {}
    
    var delegate: RealmManagerDelegate?
    
    private let realm = try! Realm()
    
    
    func readSavedArticles() -> [ArticleModel] {
        let articles = realm.objects(ArticleModel.self).sorted(byKeyPath: "savedDate", ascending: false) // 모든 객체 얻기 + 정렬
        return Array(articles)
    }
    
    func addArticleToRealmDB(newArticle: Article) {
        // 같은 기사 저장 안되도록 필터링
        let articles = realm.objects(ArticleModel.self)
        let filter = articles.where({ $0.title == "\(newArticle.title)" })
        print(filter)
        if filter.first != nil {
            print("The article is duplicated.")
            return
        }
        
        var article = ArticleModel()
        article.title = newArticle.title
        article.desc = newArticle.description
        article.url = newArticle.url
        article.urlToImage = newArticle.urlToImage
        article.date = newArticle.date
        article.name = newArticle.source.name
        article.savedDate = Date()
        
        do {
            try realm.write {
                realm.add(article)
            }
            print("Successfully saved an article.")
        } catch {
            print("Fiaild to save an article.")
        }
        
    }

    func deleteSavedArticle(articleToDelete: ArticleModel) {

        let articles = realm.objects(ArticleModel.self)
        let filter = articles.filter("title='\(articleToDelete.title)'")
        if let filterdData = filter.first {
            do {
                try realm.write {
                    realm.delete(filterdData)
                }
                self.delegate?.successToDeleteAnArticle()
                print("Successfully deleted an article.")
            } catch {
                print("Fiaild to delete an article.")
            }
        }
    }
}
