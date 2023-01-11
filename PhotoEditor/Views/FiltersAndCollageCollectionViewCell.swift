//
//  FiltersCollectionViewCell.swift
//  PhotoEditor
//
//  Created by Raees on 09/01/2023.
//

import UIKit

class FiltersAndCollageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var collageNameLbl: UILabel!
    @IBOutlet weak var collageContainerView: CustomView!
    @IBOutlet weak var filterName: UILabel!
    @IBOutlet weak var filterImageView: UIImageView!
    let viewModel = FiltersViewModel()
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    func setupCell(filterToApply: Filters,image : UIImage, forCollage: Bool = false, collage: Collage = .diagonal) {
        if forCollage{
            self.collageContainerView.isHidden = false
            self.collageNameLbl.text = collage.rawValue
            self.filterImageView.image = nil
            self.filterName.text = ""
        } else {
            self.collageContainerView.isHidden = true
            self.collageNameLbl.text = ""
            self.filterImageView.image = image
            self.filterName.text = filterToApply.rawValue
        }

    }

}
