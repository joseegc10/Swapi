//
//  FilmViewModel.swift
//  Swapi
//
//  Created by Jose Alberto Garcia Collado on 15/12/21.
//

import Foundation
import CoreData
import SwiftUI

/// Clase para la obtención de las películas desde Swapi
class FilmsViewModel: ObservableObject {
    @Published var films = FilmsAPICall(message: "", result: []) // Almacenamos las películas
    @Published var alertError = false // Alerta en caso de que Swapi no esté disponible
    
    
    /// Método para la obtención de las películas desde Swapi
    func getFilms() {
        // URL de las películas
        guard let urlFilms = URL(string: "https://www.swapi.tech/api/films/") else { return }
        
        // Hacemos la petición
        URLSession.shared.dataTask(with: urlFilms){ dataFilms,_,_ in
            guard let dataFilms = dataFilms else { return }
            
            do {
                let listFilms = try JSONDecoder().decode(FilmsAPICall.self, from: dataFilms)
                DispatchQueue.main.async {
                    self.films = listFilms
                }
            } catch {
                DispatchQueue.main.async {
                    self.alertError = true
                }
                print("Error al obtener películas desde Swapi ", error.localizedDescription)
            }
        }.resume()
    }
}
