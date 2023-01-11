//
//  ImagePickerManager.swift
//  PhotoEditor
//
//  Created by Raees on 09/01/2023.
//

import Foundation
import HXPHPicker
class ImagePicker {
    typealias SingleImageCompletionBlock = ((_ image: UIImage) -> Void)
    var mediaAssetCallback: SingleImageCompletionBlock?
    static var shared = ImagePicker()
    func openGalleryUsingHXPHImagePicker(from controller: UIViewController,forCollage: Bool = false, completion: @escaping (_ image: UIImage) -> Void)
    {
        let config = setupConfigs(forCollage: forCollage)
        // Method 1：
        let pickerController = PhotoPickerController(picker: config)
        pickerController.pickerDelegate = self
        mediaAssetCallback = completion
        controller.present(pickerController, animated: true, completion: nil)
    }
    func setupConfigs(forCollage: Bool = false) -> PickerConfiguration {
        let config = PhotoTools.getWXPickerConfig()
        //MARK: Add configurationChanges here
        if forCollage {
            config.maximumSelectedCount = 2
        } else {
            config.maximumSelectedCount = 1
        }
        return config
    }
}
extension ImagePicker : PhotoPickerControllerDelegate {
    func pickerController(_ pickerController: PhotoPickerController, didFinishSelection result: PickerResult) {
        result.getImage { image, assets, index in
            if let image = image {
                print("success", image)
                self.mediaAssetCallback?(image)
            }else {
                print("failed")
            }
        } completionHandler: { images in
            print(images)
        }
        

    }
}
