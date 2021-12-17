//
//  FilmModel.swift
//  Swapi
//
//  Created by Jose Alberto Garcia Collado on 15/12/21.
//

import SwiftUI

/// Almacenar el resultado de la petición /films a Swapi
struct FilmsAPICall : Decodable {
    let message: String
    let result: [Property]
}

/// Almacenar variable que contiene la película
struct Property: Decodable, Hashable {
    let properties: Film
}

/// Almacenar propiedades de la película
struct Film : Decodable, Hashable {
    let title: String
    let opening_crawl: String
    let characters: [String]
    let release_date: String
    let episode_id: Int
}
