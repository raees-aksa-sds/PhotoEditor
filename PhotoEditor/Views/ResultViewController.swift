//
//  ResultViewController.swift
//  PhotoEditor
//
//  Created by Raees on 11/01/2023.
//
import UIKit
class ResultViewController: UIViewController {
    @IBOutlet weak var resultImageView: UIImageView!
    var resultImage = UIImage()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.resultImageView.image = resultImage
        // Do any additional setup after loading the view.
    }
}
