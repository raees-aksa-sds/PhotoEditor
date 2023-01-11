//
//  FiltersViewModel.swift
//  PhotoEditor
//
//  Created by Raees on 09/01/2023.
//

import Foundation
import GPUImage
import CoreGraphics
class EditorViewModel {
    let filters = [Filters.original,Filters.blur,Filters.hue,Filters.rgb, Filters.toon, Filters.sepia]
    let collages = [Collage.diagonal, Collage.horizantal, Collage.vertical]
    var filterEffectedImages = [UIImage]()
    func applyFilter(filter : Filters, image : UIImage,complition: @escaping(UIImage) -> Void) {
        var filterToApply = GPUImageFilter()
        switch filter {
        case .blur:
            let blurFilter = GPUImageGaussianBlurFilter()
            blurFilter.blurRadiusInPixels = 10.0
            filterToApply = blurFilter
        case.toon:
            filterToApply = GPUImageToonFilter()
        case .rgb:
            filterToApply  = GPUImageRGBFilter()
        case .hue:
            filterToApply  = GPUImageHueFilter()
        case .sepia:
            filterToApply  = GPUImageSepiaFilter()
        case .original:
            break
        }
        if let inputImage = GPUImagePicture(image: image) {
            inputImage.addTarget(filterToApply)
            filterToApply.useNextFrameForImageCapture()
            inputImage.processImage {
                if let outputImage = filterToApply.imageFromCurrentFramebuffer() {
                    complition(outputImage)
                }
                
            }
        }
    }
    func applyFiltersOnImages(image: UIImage,completion: @escaping([UIImage]) -> Void) {
        let filtersGroup = DispatchGroup()
        var resultImages = [UIImage]()
        for filter in filters {
            filtersGroup.enter()
            if filter == .original {
                resultImages.append(image)
                filtersGroup.leave()
            } else {
                applyFilter(filter: filter,image: image) { image in
                    resultImages.append(image)
                    filtersGroup.leave()
                }
            }
        }
        filtersGroup.notify(queue: DispatchQueue.main) {
            self.filterEffectedImages = resultImages
            completion(resultImages)
        }
    }
    func applyCollageOnImages(images: [UIImage],collage: Collage,imageViewWidth: CGFloat, imageViewHeight: CGFloat) -> CAShapeLayer {
        switch collage {
        case .diagonal:
            return diagonalBazierPath(width: imageViewWidth, height: imageViewHeight)
        case .horizantal:
            return horizantalBazierPath(width: imageViewWidth, height: imageViewHeight)
        case .vertical:
            return verticalBazierPath(width: imageViewWidth, height: imageViewHeight)
        }
    }
    func diagonalBazierPath(width: CGFloat, height: CGFloat) -> CAShapeLayer {
        let shapeBezierPath = UIBezierPath()
        let pointA = CGPoint(x: width, y: 0)
        let pointB = CGPoint(x: width - 70, y: 0)
        let pointC = CGPoint(x: 70, y: height)
        let pointD = CGPoint(x: width, y: height)
        shapeBezierPath.move(to: pointA)
        shapeBezierPath.addLine(to: pointB)
        shapeBezierPath.addLine(to: pointC)
        shapeBezierPath.addLine(to: pointD)
        shapeBezierPath.close()
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = shapeBezierPath.cgPath
        return shapeLayer
        
    }
    func horizantalBazierPath(width: CGFloat, height: CGFloat) -> CAShapeLayer {
        let rect = CGRect(x: 0, y: 0, width: width, height: height / 2)
        let shapeBezierPath = UIBezierPath(rect: rect)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = shapeBezierPath.cgPath
        return shapeLayer
    }
    func verticalBazierPath(width: CGFloat, height: CGFloat) -> CAShapeLayer {
        let rect = CGRect(x: 0, y: 0, width: width / 2, height: height)
        let shapeBezierPath = UIBezierPath(rect: rect)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = shapeBezierPath.cgPath
        return shapeLayer
    }
}
