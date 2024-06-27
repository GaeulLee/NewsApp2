//
//  SavedArticleViewController.swift
//  NewsApp2
//
//  Created by 이가을 on 6/20/24.
//

import UIKit
import SafariServices
import RealmSwift
import SnapKit

class SavedArticleViewController: UIViewController {

    // MARK: - UI Property
    private let tableView = UITableView()
    
    
    // MARK: - Property
    var realmManager = RealmManager.shared
    var savedArticles: [ArticleModel] = []
    
    
    // MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        savedArticles = realmManager.readSavedArticles()
        tableView.reloadData()
    }
    
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        realmManager.delegate = self
        
        setNavigaionBar()
        setTableView()
        setConstraints()
    }

    private func setNavigaionBar() {
        view.backgroundColor = .systemBackground
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .backColor
        
        navigationController?.navigationBar.tintColor = .iconColor
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        title = "Saved Articles"
    }
    
    private func setTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(ArticleTableViewCell.self, forCellReuseIdentifier: K.cell)
        tableView.rowHeight = 110
        
        view.addSubview(tableView)
    }
    
    private func setConstraints() {
        tableView.snp.makeConstraints { make in
            make.top.bottom.left.right.equalTo(self.view.safeAreaLayoutGuide)
        }
        
//        tableView.translatesAutoresizingMaskIntoConstraints = false
        
//        NSLayoutConstraint.activate([
//            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
//            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
//            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
//            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
//        ])
    }

}

// MARK: - UITableViewDataSource
extension SavedArticleViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedArticles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cell, for: indexPath) as! ArticleTableViewCell
        
        cell.articleModel = savedArticles[indexPath.row]
        cell.articleImageUrl = savedArticles[indexPath.row].urlToImage
        
        return cell
    }
    
}

// MARK: - UITableViewDelegate
extension SavedArticleViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let url = URL(string: self.savedArticles[indexPath.row].url) else { return }
        
        let safariViewController = SFSafariViewController(url: url)
        present(safariViewController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .normal, title: "Delete") { (UIContextualAction, UIView, success: @escaping (Bool) -> Void) in
            
            self.realmManager.deleteSavedArticle(articleToDelete: self.savedArticles[indexPath.row])
            success(true)
        }
        delete.backgroundColor = .systemPink
        delete.image = UIImage(systemName: "trash.fill")
        
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
}

// MARK: - RealmManagerDelegate
extension SavedArticleViewController: RealmManagerDelegate {
    
    func successToDeleteAnArticle() {
        savedArticles = realmManager.readSavedArticles()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
}

