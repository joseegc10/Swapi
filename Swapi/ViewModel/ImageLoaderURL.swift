//
//  ImageLoaderURL.swift
//  Swapi
//
//  Created by Jose Alberto Garcia Collado on 17/12/21.
//

import Foundation
import Combine


/// Clase para obtener una imagen de internet a partir de una url
class ImageLoaderURL: ObservableObject {
    var didChange = PassthroughSubject<Data, Never>()
    var data = Data() {
        didSet {
            didChange.send(data)
        }
    }

    init(urlString:String) {
        guard let url = URL(string: urlString) else { return }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            DispatchQueue.main.async {
                self.data = data
            }
        }
        task.resume()
    }
}
