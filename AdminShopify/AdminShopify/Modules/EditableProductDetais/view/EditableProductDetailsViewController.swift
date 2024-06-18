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
        
    @IBOutlet weak var productAvailabilityInStore: UILabel!
    
    @IBAction func backBtn(_ sender: Any) {
        navigateBack()
    }
    
    var viewModel = EditableProductDetailsViewModel()
    
    var presenter: AddNewProductPresenter!

    var timer : Timer?
    var currentCellIndex = 0
    
    var arrProductImg: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
     
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
    
    @IBAction func addImage(_ sender: Any) {
        showAddImageAlert()
    }
    
    func showAddImageAlert() {
           let alert = UIAlertController(title: "Add Image", message: "Enter image URL", preferredStyle: .alert)
           
           alert.addTextField { textField in
               textField.placeholder = "Image URL"
           }
           
           alert.addAction(UIAlertAction(title: "Update", style: .default, handler: { action in
               if let imageURL = alert.textFields?.first?.text {
                   self.updateProductImageURL(imageURL)
               }
           }))
           
           alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
           
           present(alert, animated: true, completion: nil)
       }
    
       
    
    func updateProductImageURL(_ newImageURL: String) {
        guard let productId = viewModel.product?.id else {
            print("Product ID is nil, cannot update image URL.")
            return
        }
        
        let productIdString = "\(productId)"
        
        var imagesData: [[String: String]] = []
        
        if let productImages = viewModel.product?.images {
            for image in productImages {
                let imageData: [String: String] = [
                    "src": image.src
                ]
                imagesData.append(imageData)
            }
        }
        
        let newImageData: [String: String] = [
            "src": newImageURL
        ]
        imagesData.append(newImageData)
        
        let updateData: [String: Any] = [
            "product": [
                "images": imagesData
            ]
        ]
        
        guard let encodedData = try? JSONSerialization.data(withJSONObject: updateData) else {
            print("Failed to encode updated product data.")
            return
        }
        
        viewModel.updateProductDetails(productId: productIdString, updatedData: encodedData) { [weak self] data, error in
            if let error = error {
                print("Failed to update product image URL: \(error.localizedDescription)")
            } else if data != nil {
                let newProductImage = BrandProductImage(id: 0, src: newImageURL)
                self?.viewModel.product?.images.append(newProductImage)
                self?.arrProductImg.append(newImageURL)
                
                DispatchQueue.main.async {
                    self?.pageController.numberOfPages = self?.arrProductImg.count ?? 0
                    self?.imgCollectionView.reloadData()
                }
                
                print("Product image URL updated successfully.")
            }
        }
    }

    
    
    @IBAction func editTitle(_ sender: Any) {
        showTitleEditAlert()
    }
    
    func showTitleEditAlert() {
           let alert = UIAlertController(title: "Edit Title", message: "Enter new title", preferredStyle: .alert)
           
           alert.addTextField { textField in
               textField.placeholder = "New Title"
               textField.text = self.viewModel.product?.title
           }
           
           alert.addAction(UIAlertAction(title: "Update", style: .default, handler: { action in
               if let newTitle = alert.textFields?.first?.text {
                   self.updateProductTitle(newTitle)
               }
           }))
           
           alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
           
           present(alert, animated: true, completion: nil)
       }
       
    func updateProductTitle(_ newTitle: String) {
        guard let productId = viewModel.product?.id else {
            print("Product ID is nil, cannot update title.")
            return
        }
        
        let productIdString = "\(productId)"
        
        let updateData: [String: Any] = [
            "product": [
                "title": newTitle
            ]
        ]
        
        guard let encodedData = try? JSONSerialization.data(withJSONObject: updateData) else {
            print("Failed to encode updated product data.")
            return
        }
        
        viewModel.updateProductDetails(productId: productIdString, updatedData: encodedData) { [weak self] data, error in
            if let error = error {
                print("Failed to update product title: \(error.localizedDescription)")
            } else if data != nil {
                self?.viewModel.product?.title = newTitle
                
                DispatchQueue.main.async {
                    self?.titleProductDetails.text = newTitle
                }
                
                print("Product title updated successfully.")
            }
        }
    }

    
    @IBAction func editDescription(_ sender: Any) {
        showDescriptionEditAlert()
    }
    
    func showDescriptionEditAlert() {
            let alert = UIAlertController(title: "Edit Description", message: "Enter new description", preferredStyle: .alert)
            
            alert.addTextField { textField in
                textField.placeholder = "New Description"
                textField.text = self.viewModel.product?.body_html
            }
            
            alert.addAction(UIAlertAction(title: "Update", style: .default, handler: { action in
                if let newDescription = alert.textFields?.first?.text {
                    self.updateProductDescription(newDescription)
                }
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            present(alert, animated: true, completion: nil)
        }
        
        func updateProductDescription(_ newDescription: String) {
            guard let productId = viewModel.product?.id else {
                print("Product ID is nil, cannot update description.")
                return
            }
            
            let productIdString = "\(productId)"
            
            let updateData: [String: Any] = [
                "product": [
                    "body_html": newDescription
                ]
            ]
            
            guard let encodedData = try? JSONSerialization.data(withJSONObject: updateData) else {
                print("Failed to encode updated product data.")
                return
            }
            
            viewModel.updateProductDetails(productId: productIdString, updatedData: encodedData) { [weak self] data, error in
                if let error = error {
                    print("Failed to update product description: \(error.localizedDescription)")
                } else if data != nil {
                    self?.viewModel.product?.body_html = newDescription
                    
                    DispatchQueue.main.async {
                        self?.DescriptionProductDetails.text = newDescription
                    }
                    
                    print("Product description updated successfully.")
                }
            }
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

    
