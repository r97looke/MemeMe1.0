//
//  MemeDetailViewController.swift
//  MeMe1.0
//
//  Created by slchen on 2018/11/5.
//  Copyright © 2018 slchen. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {

    var meme: MemeModel!

    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = meme.memedImage
    }

}
