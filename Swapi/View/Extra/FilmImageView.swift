//
//  FilmImageView.swift
//  Swapi
//
//  Created by Jose Alberto Garcia Collado on 17/12/21.
//

import Foundation
import SwiftUI

// Vista de una imagen a partir de una url
struct FilmImageView: View {
    @ObservedObject var imageLoader:ImageLoaderURL
    @State var image:UIImage = UIImage()

    init(withURL url:String) {
        imageLoader = ImageLoaderURL(urlString:url)
    }

    var body: some View {
        // Si data tiene el tamaño de una petición a una url inexistente
        if imageLoader.data.count == 11 {
            Image(systemName: "film")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width:100)
                .foregroundColor(.white)
                .padding(.leading, 15)
        } else {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width:120)
                .onReceive(imageLoader.didChange) { data in
                    self.image = UIImage(data: data) ?? UIImage()
                }
        }
        
    }
}
