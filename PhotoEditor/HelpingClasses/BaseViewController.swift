//
//  BaseViewController.swift
//  PhotoEditor
//
//  Created by Raees on 11/01/2023.
//

import UIKit

class BaseViewController: UIViewController {

    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    let greyView = UIView()
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func activityIndicatorBegin() {
        activityIndicator = UIActivityIndicatorView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 50, height: 50)))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.large
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        self.view.isUserInteractionEnabled = false

        greyView.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: self.view.bounds.width, height: self.view.bounds.height))
        greyView.backgroundColor = UIColor.black
        greyView.alpha = 0.5
        self.view.addSubview(greyView)
    }

    func activityIndicatorEnd() {
        self.activityIndicator.stopAnimating()
        self.view.isUserInteractionEnabled = true
        self.greyView.removeFromSuperview()
    }

}

