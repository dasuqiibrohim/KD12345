//
//  ContentViewModel.swift
//  KD12345
//
//  Created by Ibrohim Dasuqi on 02/03/22.
//

import Foundation
import Combine

class ContentViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var showToast: Bool = false
    @Published var errorText: String = ""
    
    @Published var token: String = ""
    @Published var searchTextSKU: String = ""
    @Published var searchProducts: [ItemProductResponse]? = nil
    
    @Published var authRegister: Bool = true
    @Published var emailText: String = ""
    @Published var passwText: String = ""
    @Published var showAuth: Bool = false
    
    @Published var listProduct: [ItemProductResponse] = []
    @Published var addProd: Bool = true
    @Published var showProd: Bool = false
    @Published var skuText: String = ""
    @Published var nameText: String = ""
    @Published var qtyText: String = ""
    @Published var priceText: String = ""
    @Published var unitText: String = ""
    @Published var statusProduct: Bool = false
    
    private let networkRegister: Network<RegisterResponse> = Network<RegisterResponse>()
    private let networkLogin: Network<LoginResponse> = Network<LoginResponse>()
    private let networkListProduct: Network<ListProductsResponse> = Network<ListProductsResponse>()
    private let networkItemProduct: Network<ItemProductResponse> = Network<ItemProductResponse>()
    private var searchCancellable: AnyCancellable?
    
    init() {
        searchCancellable = self.$searchTextSKU.removeDuplicates()
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .sink(receiveValue: { str in
                if str != "" {
                    self.FiturSearchProductsByData()
                } else {
                    self.searchProducts = nil
                }
            })
    }
    deinit {
        searchCancellable?.cancel()
    }
    
    func GETListProduct() {
        isLoading = true
        networkListProduct.fetch(EndpointAll.ListProducts) { response in
            self.isLoading = false
            switch response {
            case .failure(let error):
                self.errorText = error.localizedDescription
                self.showToast = true
            case .success(let object):
                self.listProduct = object
            }
        }
    }
    func POSTAuth() {
        showToast = true
        errorText = ""
        if authRegister {
            networkRegister.fetch(EndpointAll.Register(email: emailText, password: passwText)) { response in
                switch response {
                case .failure(let error):
                    self.errorText = error.localizedDescription
                    self.showToast = true
                case .success(_):
                    self.showAuth = false
                    self.errorText = "Register Succsess"
                    self.showToast = true
                }
            }
        } else {
            networkLogin.fetch(EndpointAll.Login(email: emailText, password: passwText)) { response in
                switch response {
                case .failure(let error):
                    self.errorText = error.localizedDescription
                    self.showToast = true
                case .success(let object):
                    self.showAuth = false
                    self.token = object.token
                    self.errorText = "Login Succsess"
                    self.showToast = true
                }
            }
        }
    }
    func POSTProduct() {
        showToast = true
        errorText = ""
        let product = ItemProductResponse(id: 0, sku: skuText, productName: nameText, qty: .string(qtyText), price: .string(priceText), unit: unitText, image: nil, status: .integer(statusProduct ? 1: 0), createdAt: "", updatedAt: "")
        if addProd {
            networkItemProduct.fetch(EndpointAll.AddProducts(token: token, prod: product)) { reponse in
                switch reponse {
                case .failure(let error):
                    self.errorText = error.localizedDescription
                    self.showToast = true
                    self.showProd = false
                case .success(let obj):
                    self.listProduct.append(obj)
                    self.errorText = "Add Product Succsess"
                    self.showToast = true
                    self.showProd = false
                }
            }
        } else {
            networkItemProduct.fetch(EndpointAll.UpdateProducts(token: token, prod: product)) { reponse in
                switch reponse {
                case .failure(let error):
                    self.errorText = error.localizedDescription
                    self.showToast = true
                    self.showProd = false
                case .success(let obj):
                    if let ind = self.listProduct.firstIndex(where: { $0.id == obj.id }) {
                        self.listProduct[ind] = obj
                    }
                    self.errorText = "Update Product Succsess"
                    self.showToast = true
                    self.showProd = false
                    
                }
            }
        }
    }
    func POSTDeleteProduct(sku: String) {
        showToast = true
        errorText = ""
        networkItemProduct.fetch(EndpointAll.DeleteProducts(token: token, sku: sku)) { response in
            switch response {
            case .failure(let error):
                self.errorText = error.localizedDescription
                self.showToast = true
            case .success(_):
                if let ind = self.listProduct.firstIndex(where: { $0.sku == sku }) {
                    self.listProduct.remove(at: ind)
                }
                self.errorText = "Delete Product Succsess"
                self.showToast = true
            }
        }
    }
    func FiturSearchProductsByData() {
        DispatchQueue.global(qos: .userInteractive).async {
            let result = self.listProduct
                .lazy
                .filter { prd in
                    return prd.sku.lowercased().contains(self.searchTextSKU.lowercased())
                }
            
            DispatchQueue.main.async {
                self.searchProducts = result.compactMap({ gwr in
                    return gwr
                })
            }
        }
    }
}
