//
//  EditableProductDetailsViewController.swift
//  AdminShopify
//
//  Created by Somia on 05/06/2024.
//

import UIKit

class EditableProductDetailsViewController: UIViewController {
    
    @IBOutlet weak var imgCollectionView: UICollectionView!
    @IBOutlet weak var pageController: UIPageControl!
    @IBOutlet weak var sizeScrollable: UIScrollView!
    @IBOutlet weak var sizeStackView: UIStackView!
    @IBOutlet weak var colorScrollStackView: UIScrollView!
    @IBOutlet weak var colorView: UIStackView!
    @IBOutlet weak var productPrice: UILabel!

    @IBOutlet weak var productAvailabilityInStore: UILabel!
    
    @IBAction func backBtn(_ sender: Any) {
    }
    var arrProductImg = [UIImage(named: "addidus") , UIImage(named: "unnamed") , UIImage(named: "lock") ,UIImage(named: "addidus") ,UIImage(named: "unnamed") ]
    var timer : Timer?
    var currentCellIndex = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pageController.numberOfPages = arrProductImg.count
        startTimer()
        let sizes = ["Small", "Medium", "Large", "XL", "XXL", "XXXL", "US 6", "US 8", "US 10", "US 12"]
        
        for size in sizes {
            addSize(size: size)
        }
        
        let colors = ["Red", "Blue", "Green", "Yellow", "Orange", "Purple", "Black", "White", "Gray", "Pink"]
        for color in colors {
            addColor(color: color)
        }
    
    }
    
    func startTimer(){
        timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector:#selector(moveToNextProductImg) , userInfo: nil, repeats: true)
    }
    
    @objc func moveToNextProductImg(){
        if currentCellIndex < arrProductImg.count - 1 {
            currentCellIndex += 1
        }else{
            currentCellIndex = 0
        }
        imgCollectionView.scrollToItem(at: IndexPath(item: currentCellIndex, section: 0), at: .centeredHorizontally, animated: true)
        pageController.currentPage = currentCellIndex
    }
    
    func styleView(_ view: UIView) {
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.gray.cgColor
        view.layer.shadowColor = UIColor.gray.cgColor
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = CGSize(width: 4, height: 2)
        view.layer.shadowRadius = 4
    }

    func styleLabel(_ label: UILabel) {
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: UIFont.labelFontSize, weight: .regular)
    }


    func addSize(size: String) {
        let newSizeView = UIView()
        newSizeView.backgroundColor = UIColor.white
        styleView(newSizeView)
        
        let newSizeLabel = UILabel()
        newSizeLabel.text = size
        styleLabel(newSizeLabel)
        
        newSizeView.addSubview(newSizeLabel)
        newSizeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            newSizeLabel.topAnchor.constraint(equalTo: newSizeView.topAnchor, constant: 8),
            newSizeLabel.leadingAnchor.constraint(equalTo: newSizeView.leadingAnchor, constant: 8),
            newSizeLabel.trailingAnchor.constraint(equalTo: newSizeView.trailingAnchor, constant: -8),
            newSizeLabel.bottomAnchor.constraint(equalTo: newSizeView.bottomAnchor, constant: -8)
        ])
        
        sizeStackView.addArrangedSubview(newSizeView)
    }

    func addColor(color: String) {
        let newColorView = UIView()
        newColorView.backgroundColor = UIColor(named: color)
        styleView(newColorView)
        
        let newColorLabel = UILabel()
        newColorLabel.text = color
        styleLabel(newColorLabel)
        
        newColorView.addSubview(newColorLabel)
        newColorLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            newColorLabel.topAnchor.constraint(equalTo: newColorView.topAnchor, constant: 8),
            newColorLabel.leadingAnchor.constraint(equalTo: newColorView.leadingAnchor, constant: 8),
            newColorLabel.trailingAnchor.constraint(equalTo: newColorView.trailingAnchor, constant: -8),
            newColorLabel.bottomAnchor.constraint(equalTo: newColorView.bottomAnchor, constant: -8)
        ])
        
        colorView.addArrangedSubview(newColorView)
    }

}

extension EditableProductDetailsViewController : UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrProductImg.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productImg", for: indexPath) as! EditableProductDetailsCollectionViewCell
        
        cell.productImg.image = arrProductImg[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // to size the cell
        CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
