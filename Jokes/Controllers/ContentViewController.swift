//
//  ContentViewController.swift
//  Jokes
//
//  Created by Кирилл on 06.04.2020.
//  Copyright © 2020 Кирилл. All rights reserved.
//

import UIKit
import Firebase
import Alamofire

class ContentViewController: UIViewController {
    
    //MARK: Var
    var contentCollectionView: UICollectionView!
    var loadIndicatorView:UIActivityIndicatorView!
    
    let server = Server()
    var dataList:[String] = []
    
    //MARK: Lifecycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setup()
        loadData()
    }
    
    //MARK:
    func loadData(){
        server.request { [weak self](data) in
            self?.dataList += data
            self?.loadIndicatorView.stopAnimating()
            self?.contentCollectionView.reloadData()
        }
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
extension ContentViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReturn(cell: .contentCV), for: indexPath) as! ContentCVCell

        server.loadImage(url: dataList[indexPath.row]) { (data) in
            cell.setImage(image: UIImage(data: data)!)
        }
        
        if indexPath.row == dataList.count - 4 { loadData() }
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height + 7)
    }
}

//MARK: Setup
extension ContentViewController{
    func setup(){
        //CollectionView
        let flowLayout = UICollectionViewFlowLayout(scrollDirection: .horizontal, minimumLineSpacing: 0)
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height + 7)
        contentCollectionView = UICollectionView(frame: frame,flowLayout: flowLayout, isPagingEnabled: true)
        contentCollectionView.dataSource = self
        contentCollectionView.delegate = self
        contentCollectionView.register(ContentCVCell.self, forCellWithReuseIdentifier: cellReturn(cell: .contentCV))
        view.addSubview(contentCollectionView)
        
        //ActivityIndicatorView
        loadIndicatorView = UIActivityIndicatorView()
        loadIndicatorView.startAnimating()
        view.addSubview(loadIndicatorView)
        loadIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        loadIndicatorView.color = .blackColor()
        NSLayoutConstraint.activate([
            loadIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loadIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}
