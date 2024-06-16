import Foundation

class ProductsViewModel {
    // MARK: - Properties

    let networkManager: NetworkServicing
    var products: [AllProduct] = []
    var filteredProducts: [AllProduct] = []
    private var timer: Timer?

    // MARK: - Initialization

    init(networkManager: NetworkServicing) {
        self.networkManager = networkManager
        startFetching()
    }

    deinit {
        stopFetching()
    }

    // MARK: - Public Methods

    func startFetching() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.getAllProducts(completionHandler: { _ in })
        }
        timer?.fire() // Immediately fetch products on start
    }

    func stopFetching() {
        timer?.invalidate()
        timer = nil
    }

    // MARK: - Networking Methods

    func getAllProducts(completionHandler: @escaping (Bool) -> Void) {
        let endpoint = ShopifyEndpoint.allProducts
        
        networkManager.fetchDataFromAPI(endpoint: endpoint) { [weak self] (response: AllProductResponse?) in
            guard let self = self else { return }
            
            if let response = response {
                self.products = response.products
                self.filteredProducts = response.products // Initial setup or reset filtered products
                print("Fetched products. Count: \(self.products.count)")
                completionHandler(true)
            } else {
                print("Failed to fetch products.")
                completionHandler(false)
            }
        }
    }

    // MARK: - Filtering Methods

    func filterProducts(searchText: String) {
        if searchText.isEmpty {
            filteredProducts = products // Reset to all products
        } else {
            let lowercasedSearchText = searchText.lowercased()
            filteredProducts = products.filter { $0.title.lowercased().contains(lowercasedSearchText) }
        }
        print("Filtered products count: \(filteredProducts.count)")
    }
}
