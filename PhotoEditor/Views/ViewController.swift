//
//  ViewController.swift
//  PhotoEditor
//
//  Created by Raees on 09/01/2023.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func collageTapped(_ sender: Any) {
        if let vc : EditorViewController = self.storyboard?.instantiateViewController(withIdentifier: "EditorViewController") as? EditorViewController {
            var images = [UIImage]()
            ImagePicker.shared.openGalleryUsingHXPHImagePicker(from: self,forCollage: true) { image in
                images.append(image)
                if images.count == 2 {
                    vc.collageImages = images
                    vc.forCollage = true
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
    @IBAction func filterTapped(_ sender: Any) {
        if let vc : EditorViewController = self.storyboard?.instantiateViewController(withIdentifier: "EditorViewController") as? EditorViewController {
            ImagePicker.shared.openGalleryUsingHXPHImagePicker(from: self) { image in
                vc.selectedImage = image
                vc.forCollage = false
                self.navigationController?.pushViewController(vc, animated: true)
            }
    }
    }
}

