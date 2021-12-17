//
//  PeopleView.swift
//  Swapi
//
//  Created by Jose Alberto Garcia Collado on 15/12/21.
//

import SwiftUI

/// Vista del conjunto de personajes de Swapi
struct PeopleView: View {
    @StateObject var infoPeople = PeopleViewModel()
    
    @FetchRequest(entity: PersonCD.entity(), sortDescriptors: [], animation: .spring())
    var peopleCD: FetchedResults<PersonCD>
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("navBar").edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                
                // Vemos si está cargando todavía
                if infoPeople.people.isEmpty {
                    ProgressView()
                        .frame(width: 20, height: 20)
                        .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                } else {
                    ScrollView {
                        VStack(alignment: .leading) {
                            ForEach(infoPeople.people, id: \.self) { person in
                                NavigationLink(destination: PersonView(person: person, infoPeople: infoPeople)) {
                                    PersonCardView(person: person)
                                }
                                
                                Spacer()
                            }
                            
                            // Obtener siguiente página
                            HStack {
                                Spacer()
                                
                                Button(action: {
                                    infoPeople.cargandoMas = true
                                    infoPeople.getNextPagePeople()
                                }){
                                    
                                    if (!infoPeople.allPeopleGetted() || infoPeople.cargandoMas) {
                                        ProgressView()
                                            .frame(width: 20, height: 20)
                                            .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                                            .opacity(infoPeople.actualPage == infoPeople.peopleURL.total_pages ? 0 : 1)
                                    } else {
                                        Text("Obtener más...")
                                            .foregroundColor(.white)
                                            .font(.headline)
                                            .opacity(infoPeople.peopleURL.next == nil ? 0 : 1)
                                    }
                                }.disabled(infoPeople.peopleURL.next == nil || (!infoPeople.allPeopleGetted() || infoPeople.cargandoMas))
                                
                                Spacer()
                            }
                            
                            Spacer()
                        }
                    }
                }
            }.navigationTitle("Personajes")
            .navigationBarColor(backgroundColor: UIColor(Color("navBarFuerte")), tintColor: UIColor(Color.white))
            .onAppear{
                if infoPeople.peopleURL.next != nil {
                    infoPeople.updatePeopleCD(newPeopleCD: peopleCD)
                    infoPeople.getNextPagePeople()
                }
            }
            .alert(isPresented: $infoPeople.alertError) {
                Alert(title: Text("Error"), message: Text("API desde donde se obtienen los datos no disponible"), dismissButton: .default(Text("Ok")))
            }
        }
    }
}
