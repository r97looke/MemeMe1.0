//
//  MemeCollectionViewController.swift
//  MeMe1.0
//
//  Created by slchen on 2018/11/5.
//  Copyright © 2018 slchen. All rights reserved.
//

import UIKit

class MemeCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let width = view.frame.width
        let heigth = view.frame.height
        let space: CGFloat = 3.0

        var itemSize: CGFloat = 0
        if heigth > width {
            itemSize = (width - 2 * space)/3
        } else {
            itemSize = (heigth - 2 * space)/3
        }

        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: itemSize, height: itemSize)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }

    var memes: [MemeModel]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCollectionCell", for: indexPath) as! MemeCollectionCell
        let meme = memes[indexPath.item]
        cell.imageView.image = meme.memedImage
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVC = storyboard?.instantiateViewController(withIdentifier: "MemeDetail") as! MemeDetailViewController
        detailVC.meme = memes[indexPath.item]
        navigationController?.pushViewController(detailVC, animated: true)
    }

}
