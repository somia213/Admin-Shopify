//
//  EditableProductDetailsViewController.swift
//  AdminShopify
//
//  Created by Somia on 05/06/2024.
//

import UIKit

class EditableProductDetailsViewController: UIViewController, AddNewProductView {
    
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
    @IBOutlet weak var indecatorView: UIActivityIndicatorView!
    
    
    var viewModel = EditableProductDetailsViewModel()
    var presenter: AddNewProductPresenter!
    var fetchTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
               
        indecatorView.style = .large
        indecatorView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        
        if let product = viewModel.product {
            viewModel.arrProductImg = product.images.map { $0.src }
        }
        
        if let product = viewModel.product {
            titleProductDetails.text = product.title
            DescriptionProductDetails.text = product.body_html
            
            pageController.numberOfPages = max(viewModel.arrProductImg.count, 1)
            pageController.currentPage = 0
            
            if let firstSize = product.options.first(where: { $0.name.lowercased() == "size" })?.values.first {
                viewModel.selectedSize = firstSize
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
        pageController.numberOfPages = viewModel.arrProductImg.count
        startTimer()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.viewWillAppear(animated)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let productId = viewModel.product?.id else {
            print("Product ID is nil, cannot update product.")
            return
        }
        
        viewModel.fetchProduct(productId: productId) { [weak self] productData in
            if let product = productData {
                DispatchQueue.main.async {
                    self?.updateUI(with: product)
                    self?.updatePriceAndQuantityForSelectedSize()
                    self?.productPrice.text = productData?.variants.first?.price
                    self?.indecatorView.stopAnimating()
                    self?.indecatorView.isHidden = true
                    
                    self?.viewModel.arrProductImg = product.images.map { $0.src }
                    self?.imgCollectionView.reloadData()
                    self?.pageController.numberOfPages = self?.viewModel.arrProductImg.count ?? 0
                    
                    if let quantity = product.variants.first?.inventory_quantity {
                        self?.productAvailabilityInStore.text = "\(quantity)"
                    } else {
                        self?.productAvailabilityInStore.text = "Not Available"
                    }
                }
            } else {
                print("Failed to fetch product details.")
            }
        }
    }

    
    @IBAction func addImage(_ sender: Any) {
        showAddImageAlert()
    }
    
    @IBAction func backBtn(_ sender: Any) {
        navigateBack()
    }
    
    @IBAction func editTitle(_ sender: Any) {
        showTitleEditAlert()
    }
    
    @IBAction func editDescription(_ sender: Any) {
        showDescriptionEditAlert()
    }
    
    @IBAction func addVariant(_ sender: Any) {
        guard let variants = viewModel.product?.variants, variants.count > 1 else {
                    presentAddNewVariantViewController(with: viewModel.product?.variants.first)
                    return
                }
                
                let alert = UIAlertController(title: "Select Variant", message: "Enter variant position to update", preferredStyle: .alert)
                
                alert.addTextField { textField in
                    textField.placeholder = "Variant Position"
                    textField.keyboardType = .numberPad
                }
                
                alert.addAction(UIAlertAction(title: "Select", style: .default, handler: { action in
                    if let positionStr = alert.textFields?.first?.text,
                       let position = Int(positionStr),
                       position > 0 && position <= variants.count {
                        let selectedVariant = variants[position - 1]
                        self.presentAddNewVariantViewController(with: selectedVariant)
                    } else {
                        print("Invalid input for variant position")
                    }
                }))
                
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                
                present(alert, animated: true, completion: nil)
    }

    
    func fetchProductDetails(productId: Int) {
        viewModel.fetchProduct(productId: productId) { [weak self] productData in
            if let product = productData {
                DispatchQueue.main.async {
                    self?.updateUI(with: product)
                    self?.updatePriceAndQuantityForSelectedSize() // ----->1
                }
            } else {
                print("Failed to fetch product details.")
            }
        }
    }

    
    func updateUI(with product: ProductData) {
        titleProductDetails.text = product.title
        DescriptionProductDetails.text = product.body_html
        
        updateSizeOptions(product: product)
        updateColorOptions(product: product)
        
        updatePriceAndQuantityForSelectedSize()
    }
    
    func updateSizeOptions(product: ProductData) {
        let firstSizeView = sizeStackView.arrangedSubviews.first
        
        sizeStackView.arrangedSubviews.filter { $0 != firstSizeView }.forEach { $0.removeFromSuperview() }
        
        for option in product.options {
            if option.name.lowercased() == "size" {
                for value in option.values {
                    addSize(size: value)
                }
                if let firstSizeView = firstSizeView {
                    sizeStackView.insertArrangedSubview(firstSizeView, at: 0)
                }
                break
            }
        }
    }
    
    func updateColorOptions(product: ProductData) {
        colorView.arrangedSubviews.dropFirst().forEach { $0.removeFromSuperview() }
        
        for option in product.options {
            if option.name.lowercased() == "color" {
                for value in option.values {
                    addColor(color: value)
                }
                break
            }
        }
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
        } else {
            print("No variant found for size \(selectedSize)")
            productPrice.text = "Not Available"
            productAvailabilityInStore.text = "Not Available"
        }
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
    
    func showTitleEditAlert() {
        let alert = UIAlertController(title: "Edit Title", message: "Enter new title", preferredStyle: .alert)
        
        let textView = UITextView()
        textView.text = self.viewModel.product?.title
        textView.font = UIFont.systemFont(ofSize: 14.0)
        textView.textColor = .black
        textView.isScrollEnabled = true
        textView.dataDetectorTypes = .all
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.heightAnchor.constraint(greaterThanOrEqualToConstant: 50.0).isActive = true
        textView.widthAnchor.constraint(equalToConstant: 250.0).isActive = true
        
        alert.view.addSubview(textView)
        
        textView.topAnchor.constraint(equalTo: alert.view.topAnchor, constant: 80.0).isActive = true
        textView.leadingAnchor.constraint(equalTo: alert.view.leadingAnchor, constant: 20.0).isActive = true
        textView.trailingAnchor.constraint(equalTo: alert.view.trailingAnchor, constant: -20.0).isActive = true
        textView.bottomAnchor.constraint(equalTo: alert.view.bottomAnchor, constant: -60.0).isActive = true
        
        alert.addAction(UIAlertAction(title: "Update", style: .default, handler: { action in
            self.updateProductTitle(textView.text)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func deleteImageIcon(_ sender: Any) {
        let currentImagePosition = pageController.currentPage
        showDeleteImageAlert(at: currentImagePosition)
    }
    
    func showDeleteImageAlert(at position: Int) {
           let alert = UIAlertController(title: "Delete Image", message: "Are you sure you want to delete this image?", preferredStyle: .alert)
           
           alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { action in
               self.deleteImage(at: position)
           }))
           
           alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
           
           present(alert, animated: true, completion: nil)
       }

    func showDescriptionEditAlert() {
        let alert = UIAlertController(title: "Edit Description", message: "Enter new description", preferredStyle: .alert)
        
        let textView = UITextView()
        textView.text = self.viewModel.product?.body_html
        textView.font = UIFont.systemFont(ofSize: 14.0)
        textView.textColor = .black
        textView.isScrollEnabled = true
        textView.dataDetectorTypes = .all
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.heightAnchor.constraint(equalToConstant: 150.0).isActive = true
        textView.widthAnchor.constraint(equalToConstant: 250.0).isActive = true
        
        alert.view.addSubview(textView)
        
        textView.topAnchor.constraint(equalTo: alert.view.topAnchor, constant: 80.0).isActive = true
        textView.leadingAnchor.constraint(equalTo: alert.view.leadingAnchor, constant: 20.0).isActive = true
        textView.trailingAnchor.constraint(equalTo: alert.view.trailingAnchor, constant: -20.0).isActive = true
        textView.bottomAnchor.constraint(equalTo: alert.view.bottomAnchor, constant: -60.0).isActive = true
        
        alert.addAction(UIAlertAction(title: "Update", style: .default, handler: { action in
            self.updateProductDescription(textView.text)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
     
    
    func updateProductImageURL(_ newImageURL: String) {
        guard let productId = viewModel.product?.id else {
            print("Product ID is nil, cannot update image URL.")
            return
        }
        
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
        
        viewModel.updateProductDetails(productId: "\(productId)", updatedData: encodedData) { [weak self] data, error in
            if let error = error {
                print("Failed to update product image URL: \(error.localizedDescription)")
            } else if data != nil {
                let newProductImage = BrandProductImage(id: 0, src: newImageURL)
                
                self?.viewModel.product?.images.append(newProductImage)
                self?.viewModel.arrProductImg.append(newImageURL)
                
                DispatchQueue.main.async {
                    self?.pageController.numberOfPages = self?.viewModel.arrProductImg.count ?? 0
                    self?.imgCollectionView.reloadData()
                }
                
                print("Product image URL updated successfully.")
            }
        }
    }

    
    func deleteImage(at position: Int) {
        guard position >= 0 && position < viewModel.arrProductImg.count else {
            print("Invalid image position")
            return
        }

        print("Deleting image at position: \(position)")
        deleteProductImage(at: position)
    }


    func deleteProductImage(at position: Int) {
        guard let productId = viewModel.product?.id else {
            print("Product ID is nil, cannot update product.")
            return
        }
        
        viewModel.fetchProduct(productId: productId) { [weak self] productData in
            guard let self = self, let product = productData else {
                print("Failed to fetch updated product data.")
                return
            }
            
            // Ensure position is valid
            guard position >= 0, position < product.images.count else {
                print("Invalid position or product images are nil.")
                return
            }
            
            let imageToDelete = product.images[position]
            let imageIdToDelete = imageToDelete.id
            
            print("Deleting image with ID: \(imageIdToDelete ?? 0) at position: \(position)")
            print("Image details: \(imageToDelete)")
            
            viewModel.deleteImage(imageIdToDelete: imageIdToDelete!) { result in
                switch result {
                case .success:
                    print("Image with ID \(imageIdToDelete ?? 0) deleted from API successfully")
                    
                    DispatchQueue.main.async {
                        self.viewModel.product?.images.remove(at: position)
                        self.viewModel.arrProductImg.remove(at: position)
                        
                        self.pageController.numberOfPages = self.viewModel.arrProductImg.count
                        if self.pageController.currentPage >= self.viewModel.arrProductImg.count {
                            self.pageController.currentPage = max(self.viewModel.arrProductImg.count - 1, 0)
                        }
                        self.imgCollectionView.reloadData()
                    }
                    
                case .failure(let error):
                    print("Failed to delete image with ID \(imageIdToDelete ?? 0) from API: \(error)")
                }
            }
        }
    }

        
    func updateProductTitle(_ newTitle: String) {
        guard let productId = viewModel.product?.id else {
            print("Product ID is nil, cannot update title.")
            return
        }
        
        let updateData: [String: Any] = [
            "product": [
                "title": newTitle
            ]
        ]
        
        guard let encodedData = try? JSONSerialization.data(withJSONObject: updateData) else {
            print("Failed to encode updated product data.")
            return
        }
        
        viewModel.updateProductDetails(productId: "\(productId)", updatedData: encodedData) { [weak self] data, error in
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
    
    func updateProductDescription(_ newDescription: String) {
        guard let productId = viewModel.product?.id else {
            print("Product ID is nil, cannot update description.")
            return
        }
        
        let updateData: [String: Any] = [
            "product": [
                "body_html": newDescription
            ]
        ]
        
        guard let encodedData = try? JSONSerialization.data(withJSONObject: updateData) else {
            print("Failed to encode updated product data.")
            return
        }
        
        viewModel.updateProductDetails(productId: "\(productId)", updatedData: encodedData) { [weak self] data, error in
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
    
    func startTimer() {
        viewModel.timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(moveToNextProductImg), userInfo: nil, repeats: true)
    }
    
    @objc func moveToNextProductImg() {
        guard !viewModel.arrProductImg.isEmpty else {
            return
        }
        
        viewModel.currentCellIndex = (viewModel.currentCellIndex + 1) % viewModel.arrProductImg.count
        
        imgCollectionView.scrollToItem(at: IndexPath(item: viewModel.currentCellIndex, section: 0), at: .centeredHorizontally, animated: true)
        
        pageController.currentPage = viewModel.currentCellIndex
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
        
        newSizeView.isUserInteractionEnabled = true
        newSizeView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(sizeTapped(_:))))
        
        sizeStackView.addArrangedSubview(newSizeView)
    }
    
    @objc func sizeTapped(_ sender: UITapGestureRecognizer) {
        guard let selectedSizeView = sender.view,
              let newSizeLabel = selectedSizeView.subviews.first as? UILabel,
              let newSize = newSizeLabel.text
        else {
            return
        }

        print("Selected size tapped: \(newSize)")

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
        
        colorView.arrangedSubviews.dropFirst().forEach { $0.removeFromSuperview() }
        
        availableColors.forEach { addColor(color: $0) }
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
    
    func presentAddNewVariantViewController(with variant: Variant?) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newVariantVC = storyboard.instantiateViewController(withIdentifier: "AddNewVarientViewController") as! AddNewVarientViewController
        
        newVariantVC.viewModel.newVariants = [variant].compactMap { $0 }
        newVariantVC.viewModel.productIdString = "\(viewModel.product?.id ?? 0)"
        newVariantVC.modalPresentationStyle = .fullScreen
        
        self.present(newVariantVC, animated: true, completion: nil)
    }
    
}
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }


extension EditableProductDetailsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        showDeleteImageAlert(at: indexPath.row)
    }
}

extension EditableProductDetailsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.arrProductImg.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productImg", for: indexPath) as! EditableProductDetailsCollectionViewCell
        
        let imageUrl = URL(string: viewModel.arrProductImg[indexPath.row])
        cell.productImg.kf.setImage(with: imageUrl)
        
        return cell
    }
}


extension EditableProductDetailsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
}
