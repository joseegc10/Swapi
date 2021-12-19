//
//  FilmView.swift
//  Swapi
//
//  Created by Jose Alberto Garcia Collado on 15/12/21.
//

import SwiftUI

/// Vista de la información completa de una película, incluyendo sus personajes
struct FilmView: View {
    let film: Film
    @EnvironmentObject var infoPeople: PeopleViewModel
    
    @FetchRequest(entity: PersonCD.entity(), sortDescriptors: [], animation: .spring())
    var peopleCD: FetchedResults<PersonCD>
    
    var body: some View {
        ZStack {
            Color("navBarFuerte").edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            
            ScrollView {
                VStack(alignment: .leading){
                    FilmCardView(film: film, sinNombre: true)
                    
                    Rectangle()
                        .fill(Color("itemTabBar"))
                        .frame(height: 1.2)
                    
                    Text("Personajes de la película")
                        .font(.system(size: 25))
                        .foregroundColor(Color.white)
                        .padding()
                    
                    if let peopleFilm = infoPeople.peopleByFilm[film.episode_id], !peopleFilm.isEmpty {
                        ForEach(peopleFilm, id: \.self.url) { person in
                            NavigationLink(destination: PersonView(person: person)) {
                                PersonCardView(person: person)
                            }
                            
                            Spacer()
                        }
                    } else {
                        HStack{
                            Spacer()
                            ProgressView()
                                .frame(width: 20, height: 20)
                                .progressViewStyle(CircularProgressViewStyle(tint: Color.black))
                            Spacer()
                        }
                        
                    }
                }
                
            }
        }.navigationTitle(film.title)
        .onAppear{
            if infoPeople.peopleByFilm[film.episode_id] == nil {
                infoPeople.updatePeopleCD(newPeopleCD: peopleCD)
                infoPeople.getPeopleByFilm(film: film)
            }
        }
        .alert(isPresented: $infoPeople.alertError) {
            Alert(title: Text("Error"), message: Text("API desde donde se obtienen los datos no disponible"), dismissButton: .default(Text("Ok")))
        }
    }
}
