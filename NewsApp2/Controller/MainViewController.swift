//
//  ViewController.swift
//  NewsApp2
//
//  Created by 이가을 on 6/20/24.
//

import UIKit
import SafariServices
import Toast_Swift

class MainViewController: UIViewController {
    
    // MARK: - UI Property
    private let tableView = UITableView()
    private let searchBar = UISearchBar()
    
    
    // MARK: - Property
    var networkManager = NetworkManager.shared
    var realmManager = RealmManager.shared
    var articles: [Article] = []
    
    
    // MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        networkManager.fetchArticles()
        tableView.reloadData()
        searchBar.text = ""
        
        view.makeToastActivity(.center)
    }
    
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getDocumentsDirectory()
        
        networkManager.delegate = self
        
        setNavigaionBar()
        setTableView()
        setSearchBar()
        setConstraints()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func getDocumentsDirectory() {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        
        print(documentsDirectory)
    }
    
    // MARK: - UI Setting
    private func setNavigaionBar() {
        view.backgroundColor = .systemBackground
        
        // (네비게이션바 설정관련) iOS버전 업데이트 되면서 바뀐 설정
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .backColor
        appearance.titleTextAttributes = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 22.0)]
        
        navigationController?.navigationBar.tintColor = .iconColor
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance

        title = "News"
    }
    
    private func setTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(ArticleTableViewCell.self, forCellReuseIdentifier: K.cell) // ⭐️⭐️⭐️
        tableView.rowHeight = 110
        
        view.addSubview(tableView)
    }
    
    private func setSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = "Seach articles..."
        
        view.addSubview(searchBar)
    }
    
    private func setConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            searchBar.heightAnchor.constraint(equalToConstant: 45),
            
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        ])
    }
}

// MARK: - UITableViewDataSource
extension MainViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cell, for: indexPath) as! ArticleTableViewCell
        
        cell.article = articles[indexPath.row]
        cell.articleImageUrl = articles[indexPath.row].urlToImage
        
        return cell
    }
    
}

// MARK: - UITableViewDelegate
extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let url = URL(string: self.articles[indexPath.row].url) else { return }
        
        let safariViewController = SFSafariViewController(url: url)
        present(safariViewController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let save = UIContextualAction(style: .normal, title: "Save") { (UIContextualAction, UIView, success: @escaping (Bool) -> Void) in
            
            self.realmManager.addArticleToRealmDB(newArticle: self.articles[indexPath.row])
            print(self.articles[indexPath.row].title)
            self.view.makeToast("Successfully saved an article.", duration: 1.0)
            success(true)
        }
        save.backgroundColor = .systemPink
        save.image = UIImage(systemName: "bookmark.fill")
        
        
        return UISwipeActionsConfiguration(actions: [save])
    }
    
}

// MARK: - UISearchBarDelegate
extension MainViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
        
        guard let searchWord = searchBar.text, !searchWord.isEmpty else { return }
        print("searchWord: \(searchWord)")
        
        DispatchQueue.main.async {
            self.view.makeToastActivity(.center)
        }
        networkManager.fetchArticles(searchFor: searchWord)
    }
    
}


// MARK: - NetworkManagerDelegate
extension MainViewController: NetworkManagerDelegate {
    
    func didUpdateArticles(_ updatedArticles: [Article]) {
        self.articles = updatedArticles
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.view.hideToastActivity()
        }
    }
    
    func didFailWithError(error: Error) {
        print("Failed to load data. : \(error)")
    }
    
}

