//
//  ContentView.swift
//  KD12345
//
//  Created by Ibrohim Dasuqi on 25/02/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 16) {
                HStack(spacing: 8) {
                    Spacer()
                    Text("Register")
                        .font(.title)
                        .fontWeight(.bold)
                    Text("|")
                        .foregroundColor(.gray)
                    Text("Login")
                        .font(.title)
                        .fontWeight(.bold)
                }
                HStack {
                    Text("Search By SKU")
                    Spacer()
                    Text("Add Product")
                        .font(.title2)
                        .fontWeight(.black)
                        .foregroundColor(.gray)
                }
                Divider()
            }
            ScrollView(showsIndicators: false) {
                ForEach(0..<5) { i in
                    ProductItem()
                        .padding(.top, i == 0 ? 8: 0)
                }
            }
        }
        
        .padding()
    }
    
    func ProductItem() -> some View {
        HStack(alignment: .top, spacing: 8) {
            VStack(alignment: .leading, spacing: 4) {
                Text("OBT-2317")
                    .font(.headline)
                    .fontWeight(.medium)
                Text("Ponstan | IDR200000 | @Carton")
                    .font(.subheadline)
                    .fontWeight(.thin)
            }
            Spacer(minLength: 0)
            Text("Habis")
                .font(.caption)
                .foregroundColor(.gray)
                .padding(.vertical, 4)
                .padding(.horizontal, 8)
                .background(Color.gray.opacity(0.4))
                .cornerRadius(100)
            Image(systemName: "pencil")
                .foregroundColor(.white)
                .frame(width: 12, height: 12)
                .padding(8)
                .background(Color.blue)
                .cornerRadius(8)
            Image(systemName: "trash")
                .foregroundColor(.white)
                .frame(width: 12, height: 12)
                .padding(8)
                .background(Color.red)
                .cornerRadius(8)
        }
        .padding(.vertical, 8)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
