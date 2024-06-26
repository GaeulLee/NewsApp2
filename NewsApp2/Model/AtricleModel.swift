//
//  AtricleModel.swift
//  NewsApp2
//
//  Created by 이가을 on 6/26/24.
//

import Foundation
import RealmSwift

class ArticleModel: Object {
    @Persisted var title: String
    @Persisted var desc: String?
    @Persisted var url: String
    @Persisted var urlToImage: String?
    @Persisted var date: String
    @Persisted var name: String
    @Persisted var savedDate: Date
}
