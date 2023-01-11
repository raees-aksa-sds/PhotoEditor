//
//  EditorViewController.swift
//  PhotoEditor
//
//  Created by Raees on 09/01/2023.
//

import UIKit
import GPUImage
import Foundation
import CoreGraphics

class EditorViewController: BaseViewController {
    //MARK: IBOutlets
    @IBOutlet weak var changeImagesBtn: UIButton!
    @IBOutlet weak var collageFirstImageView: UIImageView!
    @IBOutlet weak var mainContainer: UIView!
    @IBOutlet weak var collageSecondImageView: UIImageView!
    @IBOutlet weak var filtersCollectionView: UICollectionView! {
        didSet {
            filtersCollectionView.delegate = self
            filtersCollectionView.dataSource = self
            filtersCollectionView.register(UINib(nibName: "FiltersAndCollageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "FiltersAndCollageCollectionViewCell")
        }
    }
    @IBOutlet weak var editorImageView: UIImageView!
    var selectedImage = UIImage()
    var collageImages = [UIImage]()
    var forCollage = false
    var selectedIndex = 0
    
    //MARK: Stored Properties
    let viewModel = EditorViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSaveButton()
        if forCollage {
            self.changeImagesBtn.isHidden = false
            applyCollage(.diagonal)
        } else {
            self.changeImagesBtn.isHidden = true
            self.activityIndicatorBegin()
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !forCollage {
            self.collageFirstImageView.isHidden = true
            self.collageSecondImageView.isHidden = true
            applyImageFilter()
        }
    }
    @IBAction func changeImagesTapped(_ sender: Any) {
        var images = [UIImage]()
        ImagePicker.shared.openGalleryUsingHXPHImagePicker(from: self,forCollage: true) { [weak self] image in
            guard let self = self else {return}
            images.append(image)
            if images.count == 2 {
                self.collageImages = images
                self.applyCollage(Collage(index: self.selectedIndex))
            }
        }
    }
    private func applyCollage (_ collage: Collage) {
        collageFirstImageView.image = collageImages[0]
        collageSecondImageView.image = collageImages[1]
        let shapeLayer = viewModel.applyCollageOnImages(images: collageImages, collage: collage, imageViewWidth: self.collageSecondImageView.frame.width, imageViewHeight: self.collageSecondImageView.frame.height)
            collageSecondImageView.layer.mask = shapeLayer
    }
    private func applyImageFilter () {
        self.editorImageView.image = selectedImage
        if let image = editorImageView.image {
            viewModel.applyFiltersOnImages(image: image) { images in
                self.filtersCollectionView.reloadData()
                self.activityIndicatorEnd()
            }
        }
    }
    private func addSaveButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(rightBarButtonTapped))
    }
    @objc func rightBarButtonTapped() {
        var resultedImage = UIImage()
        if forCollage {
            resultedImage = mainContainer.takeScreenshot()
        } else {
            resultedImage = editorImageView.image ?? UIImage()
        }
        if let vc : ResultViewController = self.storyboard?.instantiateViewController(withIdentifier: "ResultViewController") as? ResultViewController {
            vc.resultImage = resultedImage
            self.navigationController?.pushViewController(vc, animated: true)
        }        
    }
}
extension EditorViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if forCollage {
            return viewModel.collages.count
        } else {
            return viewModel.filterEffectedImages.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : FiltersAndCollageCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "FiltersAndCollageCollectionViewCell", for: indexPath) as! FiltersAndCollageCollectionViewCell
        if forCollage {
            cell.setupCell(filterToApply: viewModel.filters[indexPath.row], image: UIImage(),forCollage: forCollage,collage: viewModel.collages[indexPath.row])
            if selectedIndex == indexPath.row {
                cell.collageContainerView.borderColor = .blue
                cell.collageNameLbl.textColor = .blue
            } else {
                cell.collageContainerView.borderColor = .black
                cell.collageNameLbl.textColor = .black
            }
        } else {
            cell.setupCell(filterToApply: viewModel.filters[indexPath.row], image: viewModel.filterEffectedImages[indexPath.row])
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 158, height: 196)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        if forCollage {
                self.selectedIndex = indexPath.row
                applyCollage(Collage(index: indexPath.row))
                self.filtersCollectionView.reloadData()
            
        } else {
            self.editorImageView.image = viewModel.filterEffectedImages[indexPath.row]
        }
    }
}
