//
//  PeopleViewModel.swift
//  Swapi
//
//  Created by Jose Alberto Garcia Collado on 15/12/21.
//

import Foundation
import CoreData
import SwiftUI


/// Clase para la obtención de los personajes de Swapi
class PeopleViewModel: ObservableObject {
    @Published var peopleURL = PeopleAPICall(message: "", results: [],
                                             next: "https://www.swapi.tech/api/people/",
                                             total_records: 0, total_pages: 0) // Almacena las url de acceso a los personajes
    @Published var people = [Person]() // Almacena los personajes
    @Published var cargandoMas = false // Para comprobar si estamos obteniendo aún personajes
    @Published var actualPage = 0 // Página actual de los personajes
    @Published var peopleByURL = [String:Person]() // Almacena los personajes en función de su URL
    @Published var peopleByFilm = [Int:[Person]]() // Almacena los personajes en función de las películas (episodio de la saga)
    @Published var peopleCD = [PersonCD]() // Almacena los personajes almacenados en Core Data
    @Published var alertError = false // Alerta en caso de que la API no se encuentre disponible

    
    /// Comprobar si hemos obtenido todos los personajes solicitados
    /// - Returns: Proceso finalizado?
    func allPeopleGetted() -> Bool {
        var numPeoplePage = actualPage * 10
        
        if (numPeoplePage > peopleURL.total_records){
            numPeoplePage = peopleURL.total_records
        }
        
        return numPeoplePage == people.count
    }
    
    
    /// Actualizar las variables internas que contienen a un personaje modificado
    /// - Parameter person: personaje modificado
    func updateVarsPerson(person: Person){
        for i in 0..<people.count {
            if (people[i].url == person.url){
                people[i] = person
            }
        }
        
        for (film, peopleFilm) in peopleByFilm {
            var newPeople = [Person]()
            
            for i in 0..<peopleFilm.count {
                if (peopleFilm[i].url == person.url){
                    newPeople.append(person)
                } else {
                    newPeople.append(peopleFilm[i])
                }
            }
            
            peopleByFilm[film] = newPeople
        }
        
        for (url, personURL) in peopleByURL {
            if personURL.url == person.url {
                peopleByURL[url] = person
            }
        }
    }
    
    
    /// Actaulizar variable interna de los personajes de CD
    /// - Parameter newPeopleCD: personaje actualizado
    func updatePeopleCD(newPeopleCD: FetchedResults<PersonCD>) {
        peopleCD = []
        for item in newPeopleCD {
            peopleCD.append(item)
        }
    }
    
    
    /// Comprobar si existe un personaje en Core Data
    /// - Parameter uid: identificador del personaje (url)
    /// - Returns: personaje encontrado / nil
    func exitsInCD(uid: String) -> Person? {
        for person in peopleCD {
            if person.uid == uid {
                let newPerson = Person(name: person.name ?? "", gender: person.gender ?? "", mass: person.mass ?? "", height: person.height ?? "", birth_year: person.birth_year ?? "", eye_color: person.eye_color ?? "", hair_color: person.hair_color ?? "", url: person.uid ?? "")
                return newPerson
            }
        }
        
        return nil
    }
    
    
    /// Obtener personaje de Core Data
    /// - Parameter uid: identificador del personaje (url)
    /// - Returns: personaje encontrado / nil
    func getPersonCD(uid: String) -> PersonCD? {
        for person in peopleCD {
            if person.uid == uid {
                return person
            }
        }
        
        return nil
    }
    
    
    /// Obtener personajes en base a sus urls
    /// - Parameter listPeople: lista de urls
    func getInfoByURL(listPeople: [PersonURL]) {
        // Actualizamos la página
        actualPage += 1
        
        // Obtenemos los personajes
        for person in listPeople {
            // Primero miramos si existe en Core Data
            let personIfExists = exitsInCD(uid: person.url)
            
            // Si no existe, lo pedimos a Swapi
            if personIfExists == nil {
                guard let urlPerson = URL(string: person.url) else { return }
                
                URLSession.shared.dataTask(with: urlPerson){ infoPerson,_,_ in
                    guard let infoPerson = infoPerson else { return }
                    
                    do {
                        let newPerson = try JSONDecoder().decode(PersonAPICall.self, from: infoPerson)
                        DispatchQueue.main.async {
                            self.people.append(newPerson.result.properties)
                            self.peopleByURL[newPerson.result.uid] = newPerson.result.properties
                            
                            // Es el último solicitado?
                            if (newPerson.result.uid == String(self.actualPage*10) ||
                                    (self.actualPage == self.peopleURL.total_pages && newPerson.result.uid == String(self.peopleURL.total_records as Int % 10))){
                                self.cargandoMas = false
                            }
                        }
                    } catch {
                        DispatchQueue.main.async {
                            self.alertError = true
                        }

                        print("Error al obtener personajes desde Swapi: ", error.localizedDescription)
                    }
                }.resume()
            // Si existe, lo cogemos de CD
            } else {
                self.people.append(personIfExists!)
                self.peopleByURL[personIfExists!.url] = personIfExists!
                
                let uid = personIfExists!.url.components(separatedBy: "/").last
                
                // Es el último solicitado?
                if (uid == String(self.actualPage*10) ||
                        (self.actualPage == self.peopleURL.total_pages && uid == String(self.peopleURL.total_records as Int % 10))){
                    self.cargandoMas = false
                }
            }
        }
    }
    
    
    /// Función para obtener la siguiente página de personajes
    func getNextPagePeople() {
        // Obtenemos la url de acceso a la siguiente página
        guard let getPeople = URL(string: peopleURL.next!) else { return }
        
        // Solicitamos los personajes de dicha página
        URLSession.shared.dataTask(with: getPeople){ dataPeople,_,_ in
            guard let dataPeople = dataPeople else { return }
            
            do {
                let listPeople = try JSONDecoder().decode(PeopleAPICall.self, from: dataPeople)
                DispatchQueue.main.async {
                    self.peopleURL = listPeople
                    
                    self.getInfoByURL(listPeople: listPeople.results)
                }
            } catch {
                DispatchQueue.main.async {
                    self.alertError = true
                }
                print("Error al obtener url de los personajes desde Swapi: ", error.localizedDescription)
            }
        }.resume()
    }
    
    
    /// Añadimos personaje al diccionario de películas en base a su url
    /// - Parameters:
    ///   - character: url del personaje
    ///   - episode: episodio de la saga
    func addPersonToFilmByURL(character: String, episode: Int) {
        guard let urlPerson = URL(string: character) else { return }
        
        URLSession.shared.dataTask(with: urlPerson){ infoPerson,_,_ in
            guard let infoPerson = infoPerson else { return }
            
            do {
                let newPerson = try JSONDecoder().decode(PersonAPICall.self, from: infoPerson)
                DispatchQueue.main.async {
                    self.peopleByFilm[episode]!.append(newPerson.result.properties)
                }
            } catch {
                DispatchQueue.main.async {
                    self.alertError = true
                }
                print("Error al obtener personajes desde Swapi a partir de la url: ", error.localizedDescription)
            }
        }.resume()
    }
    
    
    /// Obtener los personajes de una película
    /// - Parameter film: película
    func getPeopleByFilm(film: Film) {
        if peopleByFilm[film.episode_id]?.count != film.characters.count {
            // Eliminamos la información actual
            peopleByFilm[film.episode_id] = []
            
            for character in film.characters {
                let personIfExists = exitsInCD(uid: character)
                
                if personIfExists == nil {
                    if let newPerson = peopleByURL[character] {
                        self.peopleByFilm[film.episode_id]!.append(newPerson)
                    } else {
                        addPersonToFilmByURL(character: character, episode: film.episode_id)
                    }
                } else {
                    self.peopleByFilm[film.episode_id]!.append(personIfExists!)
                }
            }
        }
    }
    
    
    /// Guardar nuevo personaje en Core Data
    /// - Parameters:
    ///   - context: contexto de Core Data
    ///   - newInfoPerson: nuevo personaje
    func savePerson(context: NSManagedObjectContext, newInfoPerson: Person) {
        let newPerson = PersonCD(context: context)
        newPerson.gender = newInfoPerson.gender
        newPerson.height = newInfoPerson.height
        newPerson.mass = newInfoPerson.mass
        newPerson.name = newInfoPerson.name
        newPerson.uid = newInfoPerson.url
        newPerson.eye_color = newInfoPerson.eye_color
        newPerson.hair_color = newInfoPerson.hair_color
        newPerson.birth_year = newInfoPerson.birth_year
        
        do {
            try context.save()
            print("Información guardada correctamente en CoreData")
        } catch let error as NSError {
            // añadir alerta al usuario
            print("Error durante el guardado de información en CoreData: ", error.localizedDescription)
        }
    }
    
    
    /// Editamos la información de un personaje en Core Data
    /// - Parameters:
    ///   - context: contexto de Core Data
    ///   - personIfExists: personaje de CD a actualizar
    ///   - newInfoPerson: información del nuevo personaje
    func editPerson(context: NSManagedObjectContext, personIfExists: PersonCD, newInfoPerson: Person){
        personIfExists.gender = newInfoPerson.gender
        personIfExists.height = newInfoPerson.height
        personIfExists.mass = newInfoPerson.mass
        personIfExists.name = newInfoPerson.name
        personIfExists.uid = newInfoPerson.url
        personIfExists.eye_color = newInfoPerson.eye_color
        personIfExists.hair_color = newInfoPerson.hair_color
        personIfExists.birth_year = newInfoPerson.birth_year
        
        do {
            try context.save()
            print("Información actualizada correctamente en CoreData")
        } catch let error as NSError {
            // añadir alerta al usuario
            print("Error durante la actualización de información en CoreData: ", error.localizedDescription)
        }
    }
    
    
    /// Almacenar información en Core Data, ya sea para añadir nueva información o para actualizar información
    /// - Parameters:
    ///   - context: contexto de Core Data
    ///   - newInfoPerson: nueva información del personaje
    func saveInfoPerson(context: NSManagedObjectContext, newInfoPerson: Person) {
        let personIfExists = getPersonCD(uid: newInfoPerson.url)
        
        updateVarsPerson(person: newInfoPerson)
        
        // Editar
        if let person = personIfExists {
            editPerson(context: context, personIfExists: person, newInfoPerson: newInfoPerson)
        // Añadir
        } else {
            savePerson(context: context, newInfoPerson: newInfoPerson)
        }
    }
    

}
