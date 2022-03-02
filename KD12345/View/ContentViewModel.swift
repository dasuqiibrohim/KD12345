//
//  ContentViewModel.swift
//  KD12345
//
//  Created by Ibrohim Dasuqi on 02/03/22.
//

import Foundation

class ContentViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var showToast: Bool = false
    @Published var errorText: String = ""
    
    @Published var token: String = ""
    @Published var searchTextSKU: String = ""
    
    @Published var authRegister: Bool = true
    @Published var emailText: String = ""
    @Published var passwText: String = ""
    @Published var showAuth: Bool = false
    
    @Published var listProduct: [ItemProductResponse] = []
    @Published var showProd: Bool = false
    
    private let networkRegister: Network<RegisterResponse> = Network<RegisterResponse>()
    private let networkLogin: Network<LoginResponse> = Network<LoginResponse>()
    private let networkListProduct: Network<ListProductsResponse> = Network<ListProductsResponse>()
    private let networkItemProduct: Network<ItemProductResponse> = Network<ItemProductResponse>()
    
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
//    func POSTAddProduc() {
//        showToast = true
//        errorText = ""
//        let product = ItemProductResponse(id: 0, sku: <#T##String#>, productName: <#T##String#>, qty: <#T##StrInt#>, price: <#T##StrInt#>, unit: <#T##String#>, image: <#T##String?#>, status: <#T##StrInt#>, createdAt: <#T##String#>, updatedAt: <#T##String#>)
//        networkItemProduct.fetch(EndpointAll.AddProducts(token: token, prod: <#T##ItemProductResponse#>), completionHandler: <#T##(Result<ItemProductResponse, Error>) -> Void#>)
//    }
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
}
