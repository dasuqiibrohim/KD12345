//
//  ContentView.swift
//  KD12345
//
//  Created by Ibrohim Dasuqi on 25/02/22.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel: ContentViewModel = ContentViewModel()
    @State private var showPassword: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 16) {
                HStack(spacing: 8) {
                    Spacer()
                    Text("Register")
                        .font(.title)
                        .fontWeight(.bold)
                        .onTapGesture {
                            withAnimation {
                                viewModel.emailText = ""
                                viewModel.passwText = ""
                                viewModel.showAuth = true
                                viewModel.authRegister = true
                            }
                        }
                    Text("|")
                        .foregroundColor(.gray)
                    Text("Login")
                        .font(.title)
                        .fontWeight(.bold)
                        .onTapGesture {
                            withAnimation {
                                viewModel.emailText = ""
                                viewModel.passwText = ""
                                viewModel.showAuth = true
                                viewModel.authRegister = false
                            }
                        }
                }
                HStack {
                    TextField("Search By SKU...", text: $viewModel.searchTextSKU)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Spacer()
                    Text("Add Product")
                        .font(.title2)
                        .fontWeight(.black)
                        .foregroundColor(.gray)
                        .onTapGesture {
                            withAnimation {
                                if viewModel.token == "" {
                                    viewModel.errorText = "You must login first."
                                    viewModel.showToast = true
                                } else {
                                    viewModel.showProd = true
                                    viewModel.addProd = true
                                    
                                    viewModel.skuText = ""
                                    viewModel.nameText = ""
                                    viewModel.qtyText = ""
                                    viewModel.priceText = ""
                                    viewModel.unitText = ""
                                    viewModel.statusProduct = true
                                }
                            }
                        }
                }
                Divider()
            }
            ScrollView(showsIndicators: false) {
                if viewModel.isLoading {
                    ProgressView()
                        .padding()
                        .background(Color.clear)

                }
                
                if viewModel.searchTextSKU != "" {
                    if let sProduct = viewModel.searchProducts {
                        if sProduct.isEmpty {
                            Text("Product With SKU \(viewModel.searchTextSKU), not found.")
                        } else {
                            ForEach(sProduct) { itm in
                                ProductItem(item: itm)
                                    .padding(.top, itm.id == viewModel.listProduct.first?.id ? 8: 0)
                            }
                        }
                    } else {
                        ProgressView()
                            .padding(.top, 30)
                            .opacity(viewModel.searchTextSKU == "" ? 0: 1)
                    }
                } else {
                    ForEach(viewModel.listProduct) { itm in
                        ProductItem(item: itm)
                            .padding(.top, itm.id == viewModel.listProduct.first?.id ? 8: 0)
                    }
                }
            }
        }
        .padding()
        .disabled(viewModel.showAuth ? true: false)
        .toast(isShowing: $viewModel.showToast, text: viewModel.errorText)
        .overlay(
            ZStack {
                if viewModel.showAuth {
                    AuthView()
                }
                if viewModel.showProd {
                    ProductView()
                }
            }
            .contentShape(Rectangle())
            
        )
        .onAppear {
            viewModel.GETListProduct()
        }
    }
    
    func ProductItem(item: ItemProductResponse) -> some View {
        HStack(alignment: .top, spacing: 8) {
            VStack(alignment: .leading, spacing: 4) {
                Text(item.sku)
                    .font(.headline)
                    .fontWeight(.medium)
                Text("\(item.productName) | IDR\(item.price.endcodeStr()) | @\(item.unit)")
                    .font(.subheadline)
                    .fontWeight(.thin)
            }
            Spacer(minLength: 0)
            if item.status.endcodeInt() == 0 {
                Text("Habis")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.vertical, 4)
                    .padding(.horizontal, 8)
                    .background(Color.gray.opacity(0.4))
                    .cornerRadius(100)
            }
            Image(systemName: "pencil")
                .foregroundColor(.white)
                .frame(width: 12, height: 12)
                .padding(8)
                .background(Color.blue)
                .cornerRadius(8)
                .onTapGesture {
                    withAnimation {
                        if viewModel.token == "" {
                            viewModel.errorText = "You must login first."
                            viewModel.showToast = true
                        } else {
                            viewModel.showProd = true
                            viewModel.addProd = false
                            
                            viewModel.skuText = item.sku
                            viewModel.nameText = item.productName
                            viewModel.qtyText = item.qty.endcodeStr()
                            viewModel.priceText = item.price.endcodeStr()
                            viewModel.unitText = item.unit
                            viewModel.statusProduct = item.status.endcodeInt() == 0 ? false: true
                        }
                    }
                }
            Image(systemName: "trash")
                .foregroundColor(.white)
                .frame(width: 12, height: 12)
                .padding(8)
                .background(Color.red)
                .cornerRadius(8)
                .onTapGesture {
                    withAnimation {
                        if viewModel.token == "" {
                            viewModel.errorText = "You must login first."
                            viewModel.showToast = true
                        } else {
                            viewModel.POSTDeleteProduct(sku: item.sku)
                        }
                    }
                }
        }
        .padding(.vertical, 8)
    }
    func AuthView() -> some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                Text(viewModel.authRegister ? "Register": "Login")
                    .font(.title)
                    .fontWeight(.bold)
                TextField("Input your email...", text: $viewModel.emailText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                ZStack {
                    if showPassword {
                        TextField("Input your password...", text: $viewModel.passwText)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    } else {
                        SecureField("Input your password...", text: $viewModel.passwText)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    HStack {
                        Spacer()
                        Image(systemName: showPassword ? "eye.slash": "eye")
                            .padding(.trailing, 8)
                            .onTapGesture {
                                withAnimation {
                                    showPassword.toggle()
                                }
                            }
                    }
                    
                }
                HStack {
                    Spacer()
                    Text(viewModel.authRegister ? "Register": "Login")
                        .foregroundColor(.white)
                        .padding(8)
                        .background(Color.blue)
                        .cornerRadius(8)
                        .onTapGesture {
                            withAnimation {
                                UIApplication.shared.endEditing()
                                viewModel.POSTAuth()
                            }
                        }
                    
                }
                
            }
            .padding(.vertical)
            .frame(width: 280)
            .padding(.horizontal)
            .background(Color.gray)
            .cornerRadius(8)
            Image(systemName: "xmark")
                .frame(width: 24, height: 24)
                .background(Color.white)
                .cornerRadius(8)
                .offset(x: -24, y: -12)
                .shadow(radius: 1)
                .onTapGesture {
                    withAnimation {
                        viewModel.showAuth = false
                    }
                }
        }
        
    }
    func ProductView() -> some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 12) {
                Text("Product")
                    .font(.title)
                    .fontWeight(.bold)
                VStack(alignment: .leading, spacing: 4) {
                    Text("SKU")
                    TextField("Input sku...", text: $viewModel.skuText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                VStack(alignment: .leading, spacing: 4) {
                    Text("Product Name")
                    TextField("Input product name...", text: $viewModel.nameText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                VStack(alignment: .leading, spacing: 4) {
                    Text("Quantity")
                    TextField("Input Quantity product...", text: $viewModel.qtyText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                VStack(alignment: .leading, spacing: 4) {
                    Text("Price")
                    TextField("Input Price product...", text: $viewModel.priceText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                VStack(alignment: .leading, spacing: 4) {
                    Text("Unit")
                    TextField("Input Unit product...", text: $viewModel.unitText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                Toggle("Status product", isOn: $viewModel.statusProduct)
                HStack {
                    Spacer()
                    Text(viewModel.addProd ? "Add": "Update")
                        .foregroundColor(.white)
                        .padding(8)
                        .background(Color.blue)
                        .cornerRadius(8)
                        .onTapGesture {
                            withAnimation {
                                UIApplication.shared.endEditing()
                                viewModel.POSTProduct()
                            }
                        }
                    
                }
            }
            .padding(.vertical)
            .frame(width: 240)
            .padding(.horizontal)
            .background(Color.gray)
            .cornerRadius(8)
            Image(systemName: "xmark")
                .frame(width: 24, height: 24)
                .background(Color.white)
                .cornerRadius(8)
                .offset(x: -24, y: -12)
                .shadow(radius: 1)
                .onTapGesture {
                    withAnimation {
                        viewModel.showProd = false
                    }
                }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Toast<Presenting>: View where Presenting: View {
    @Binding var isShowing: Bool
    let presenting: () -> Presenting
    let text: String

    var body: some View {
        ZStack(alignment: .center) {
            self.presenting()
            VStack {
                Spacer()
                ZStack {
                    if text == "" {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                            .padding()
                        
                    } else  {
                        Text(text)
                            .foregroundColor(.white)
                            .padding(.vertical, 13)
                            .padding(.horizontal, 32)
                    }
                }
                .background(Color.black)
                .cornerRadius(50)
                .padding(.bottom, 24)
                .transition(.slide)
                .opacity(self.isShowing ? 1 : 0)
                .onChange(of: isShowing) { newValue in
                    if newValue {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            withAnimation {
                                isShowing = false
                            }
                            
                        }
                    }
                }
            }
        }
    }
}
extension View {
    func toast(isShowing: Binding<Bool>, text: String) -> some View {
        Toast(isShowing: isShowing,
              presenting: { self },
              text: text)
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
