//
//  ArticleTableViewCell.swift
//  NewsApp2
//
//  Created by 이가을 on 6/20/24.
//

import UIKit

class ArticleTableViewCell: UITableViewCell {

    var article: Article? {
        didSet {
            titleLabel.text = article?.title
            descLabel.text = article?.description
            nameLabel.text = article?.source.name
            dateLabel.text = article?.date
        }
    }
    
    var articleModel: ArticleModel? {
        didSet {
            titleLabel.text = articleModel?.title
            descLabel.text = articleModel?.desc
            nameLabel.text = articleModel?.name
            dateLabel.text = articleModel?.date
        }
    }
    
    var articleImageUrl: String? {
        didSet {
            loadImage()
        }
    }
    
    
    // MARK: - UI Eelements
    let articleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private func loadImage() {
        articleImageView.isHidden = true
        guard let urlString = self.articleImageUrl, let url = URL(string: urlString) else { return }
        if !urlString.contains("https://") {
            print("invalid imageUrl ->  \(urlString)")
            return
        }
        
        articleImageView.isHidden = false
        
        DispatchQueue.global().async { // 오래 걸리는 작업이기 때문에 다른 스레드에서 동작시킴
            guard let data = try? Data(contentsOf: url) else { return }
            // 오래걸리는 작업이 일어나고 있는 동안에 url이 바뀔 가능성 제거 ⭐️⭐️⭐️
            guard urlString == url.absoluteString else { return }
            
            DispatchQueue.main.async {
                self.articleImageView.image = UIImage(data: data)
            }
        }
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let descLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 3
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 10)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let bottomLabelStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.distribution = .fillEqually
        sv.alignment = .fill
        sv.spacing = 0
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    let topLabelStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.distribution = .fill
        sv.alignment = .fill
        sv.spacing = 0
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    let imageNLabelStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.distribution = .fill
        sv.alignment = .fill
        sv.spacing = 5
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    let outterStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.distribution = .fill
        sv.alignment = .fill
        sv.spacing = 1
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    
    // MARK: - override init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        setStackView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - private
    private func setStackView() {
        self.addSubview(topLabelStackView)
        topLabelStackView.addArrangedSubview(titleLabel)
        topLabelStackView.addArrangedSubview(descLabel)
        
        self.addSubview(imageNLabelStackView)
        imageNLabelStackView.addArrangedSubview(topLabelStackView)
        imageNLabelStackView.addArrangedSubview(articleImageView)
        
        self.addSubview(bottomLabelStackView)
        bottomLabelStackView.addArrangedSubview(nameLabel)
        bottomLabelStackView.addArrangedSubview(dateLabel)
        
        self.addSubview(outterStackView)
        outterStackView.addArrangedSubview(imageNLabelStackView)
        outterStackView.addArrangedSubview(bottomLabelStackView)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.heightAnchor.constraint(equalToConstant: 25),
            descLabel.heightAnchor.constraint(equalToConstant: 55),
            articleImageView.widthAnchor.constraint(equalToConstant: 120),
            
            outterStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 2),
            outterStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            outterStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
            outterStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -2)
        ])
    }
}
