//
//  FilmsView.swift
//  Swapi
//
//  Created by Jose Alberto Garcia Collado on 15/12/21.
//

import SwiftUI

/// Vista del conjunto de películas de Swapi
struct FilmsView: View {
    @StateObject var infoFilms = FilmsViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("navBar").edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                
                if infoFilms.films.result.isEmpty {
                    ProgressView()
                        .frame(width: 20, height: 20)
                        .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                } else {
                    ScrollView {
                        VStack(alignment: .leading) {
                            ForEach(infoFilms.films.result, id: \.self) { film in
                                NavigationLink(destination: FilmView(film: film.properties)) {
                                    FilmCardView(film: film.properties)
                                }
                                
                                Rectangle()
                                    .fill(Color("itemTabBar"))
                                    .frame(height: 1.2)
                            }
                        }
                    }
                }
            }.navigationTitle("Películas")
            .navigationBarColor(backgroundColor: UIColor(Color("navBarFuerte")), tintColor: UIColor(Color.white))
            .onAppear{
                infoFilms.getFilms()
            }
            .alert(isPresented: $infoFilms.alertError) {
                Alert(title: Text("Error"), message: Text("API desde donde se obtienen los datos no disponible"), dismissButton: .default(Text("Ok")))
            }
        }
    }
}
