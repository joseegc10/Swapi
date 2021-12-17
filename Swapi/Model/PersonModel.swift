//
//  PersonModel.swift
//  Swapi
//
//  Created by Jose Alberto Garcia Collado on 15/12/21.
//

import Foundation

/// Almacenar el resultado de la petición /people a Swapi
struct PeopleAPICall : Decodable {
    let message: String
    let results: [PersonURL]
    let next: String?
    let total_records: Int
    let total_pages: Int
}

/// Almacenar url de acceso a un personaje
struct PersonURL: Decodable, Hashable {
    let name: String
    let url: String
}

/// Almacenar el resultado de la petición /people/uid a Swapi
struct PersonAPICall : Decodable {
    let message: String
    let result: PropertyPerson
}

/// Almacenar variable que representa al personaje y su identificador
struct PropertyPerson : Decodable {
    let properties: Person
    let uid: String
}

/// Almacenar información de un personaje
struct Person: Decodable, Hashable {
    var name: String
    var gender: String
    var mass: String
    var height: String
    var birth_year: String
    var eye_color: String
    var hair_color: String
    var url: String
}
