//
//  EditableProductDetailsViewController.swift
//  AdminShopify
//
//  Created by Somia on 05/06/2024.
//

import UIKit
import Kingfisher

class EditableProductDetailsViewController: UIViewController , AddNewProductView {
    
    @IBOutlet weak var imgCollectionView: UICollectionView!
    @IBOutlet weak var pageController: UIPageControl!
    @IBOutlet weak var sizeScrollable: UIScrollView!
    @IBOutlet weak var sizeStackView: UIStackView!
    @IBOutlet weak var colorScrollStackView: UIScrollView!
    @IBOutlet weak var colorView: UIStackView!
    @IBOutlet weak var productPrice: UILabel!
    
    @IBOutlet weak var titleProductDetails: UILabel!
    
    @IBOutlet weak var DescriptionProductDetails: UITextView!
    
    @IBOutlet weak var editDescription: UIButton!
    @IBOutlet weak var addImage: UIButton!
    
    @IBOutlet weak var productAvailabilityInStore: UILabel!
    
    @IBAction func backBtn(_ sender: Any) {
        navigateBack()
    }
    
    @IBAction func editTitleTapped(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Edit Title", message: nil, preferredStyle: .alert)

        alertController.addTextField { textField in
            textField.text = self.viewModel.product?.title
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(cancelAction)

        let updateAction = UIAlertAction(title: "Update", style: .default) { _ in
            guard let newTitle = alertController.textFields?.first?.text else {
                return
            }
            self.viewModel.updateTitle(newTitle: newTitle)
            
        }
        alertController.addAction(updateAction)

        present(alertController, animated: true)
    }

    
    var viewModel = EditableProductDetailsViewModel()
    
    var presenter: AddNewProductPresenter!

    var timer : Timer?
    var currentCellIndex = 0
    
    var arrProductImg: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        func updateTitle(newTitle: String) {
            self.viewModel.product?.title = newTitle
        }


        if let product = viewModel.product {
                arrProductImg = product.images.map { $0.src }
            }
        
        if let product = viewModel.product {
                   titleProductDetails.text = product.title
                   DescriptionProductDetails.text = product.body_html
                   
            pageController.numberOfPages = max(arrProductImg.count, 1)
            pageController.currentPage = 0
                           
                   if let firstSize = product.options.first(where: { $0.name.lowercased() == "size" })?.values.first {
                       viewModel.selectedSize = firstSize
                       updateColorPriceQuantity()
                   }
                           
                   for option in product.options {
                       if option.name.lowercased() == "size" {
                           for value in option.values {
                               addSize(size: value)
                           }
                       } else if option.name.lowercased() == "color" {
                           for value in option.values {
                               addColor(color: value)
                           }
                       }
                   }
               }
        
        presenter = AddNewProductPresenter(view: self)

        pageController.numberOfPages = arrProductImg.count
        startTimer()
    
    }
    
    
    func navigateBack() {
           dismiss(animated: true, completion: nil)
       }
    
    func startTimer(){
        timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector:#selector(moveToNextProductImg) , userInfo: nil, repeats: true)
    }
    
    @objc func moveToNextProductImg() {
        guard !arrProductImg.isEmpty else {
            return
        }
        
        currentCellIndex = (currentCellIndex + 1) % arrProductImg.count
        
        guard currentCellIndex < arrProductImg.count else {
            currentCellIndex = 0
            return
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
            
            newSizeView.isUserInteractionEnabled = true
            newSizeView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(sizeTapped(_:))))
            
            NSLayoutConstraint.activate([
                newSizeLabel.topAnchor.constraint(equalTo: newSizeView.topAnchor, constant: 8),
                newSizeLabel.leadingAnchor.constraint(equalTo: newSizeView.leadingAnchor, constant: 8),
                newSizeLabel.trailingAnchor.constraint(equalTo: newSizeView.trailingAnchor, constant: -8),
                newSizeLabel.bottomAnchor.constraint(equalTo: newSizeView.bottomAnchor, constant: -8)
            ])
            
            sizeStackView.addArrangedSubview(newSizeView)
        }
        
    @objc func sizeTapped(_ sender: UITapGestureRecognizer) {
        guard let selectedSizeView = sender.view,
              let newSizeLabel = selectedSizeView.subviews.first as? UILabel,
              let newSize = newSizeLabel.text
        else {
            return
        }
        viewModel.selectedSize = newSize
        
        updateColorOptionsForSelectedSize()
        
        updatePriceAndQuantityForSelectedSize()
    }

    func updateColorOptionsForSelectedSize() {
        guard let product = viewModel.product,
              let selectedSize = viewModel.selectedSize
        else {
            return
        }
        
        let availableColors = product.variants
            .filter { $0.option1 == selectedSize }
            .map { $0.option2 }
        
        if colorView.arrangedSubviews.count > 1 {
                colorView.arrangedSubviews.dropFirst().forEach { $0.removeFromSuperview() }
            }
        
        availableColors.forEach { addColor(color: $0) }
    }
    
    func updateColorPriceQuantity() {
            let (price, quantity) = viewModel.updatePriceAndQuantity()
            productPrice.text = price
            productAvailabilityInStore.text = quantity
        }
    
    func updatePriceAndQuantityForSelectedSize() {
        guard let product = viewModel.product,
              let selectedSize = viewModel.selectedSize
        else {
            return
        }
        
        if let variant = product.variants.first(where: { $0.option1 == selectedSize }) {
            productPrice.text = "\(variant.price)"
            productAvailabilityInStore.text = "\(variant.inventory_quantity)"
        }
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


    
    @IBAction func addVariant(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let newVarient = storyboard.instantiateViewController(withIdentifier: "AddNewVarientViewController") as! AddNewVarientViewController
        
        newVarient.modalPresentationStyle = .fullScreen

                self.present(newVarient, animated: true, completion: nil)
    }
    
}

extension EditableProductDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrProductImg.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productImg", for: indexPath) as! EditableProductDetailsCollectionViewCell
        
        if !arrProductImg.isEmpty {
            if let product = viewModel.product, indexPath.row < product.images.count {
                let imageUrl = URL(string: product.images[indexPath.row].src)
                cell.productImg.kf.setImage(with: imageUrl)
            }
        } else {
            cell.productImg.image = UIImage(named: "unnamed")
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

    
