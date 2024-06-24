//
//  SavedArticleViewController.swift
//  NewsApp2
//
//  Created by 이가을 on 6/20/24.
//

import UIKit

class SavedArticleViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setNavigaionBar()
    }
    

    private func setNavigaionBar() {
        view.backgroundColor = .systemBackground
        
        // (네비게이션바 설정관련) iOS버전 업데이트 되면서 바뀐 설정⭐️⭐️⭐️
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .backColor
        
        navigationController?.navigationBar.tintColor = .iconColor
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        title = "Saved Articles"
    }

}
