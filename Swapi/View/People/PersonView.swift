//
//  PersonView.swift
//  Swapi
//
//  Created by Jose Alberto Garcia Collado on 15/12/21.
//

import SwiftUI

/// Vista de la información completa de un personaje, pudiendo editarla
struct PersonView: View {
    @State var person: Person
    
    @State private var editing = false
    
    @EnvironmentObject var infoPeople: PeopleViewModel
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(entity: PersonCD.entity(), sortDescriptors: [], animation: .spring())
    var peopleCD: FetchedResults<PersonCD>
    
    var body: some View {
        ZStack {
            Color("navBar").edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            
            ScrollView {
                VStack {
                    HStack {
                        Spacer()
                        Image(systemName: "person")
                            .resizable()
                            .frame(width: 150, height: 150, alignment: .center)
                            .foregroundColor(.white)
                        Spacer()
                    }.padding()
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Género").bold().font(.system(size: 30)).foregroundColor(.white)
                            
                            if editing {
                                TextEditor(text: $person.gender)
                                    .padding(.trailing, 50)
                            } else {
                                Text(person.gender).font(.system(size: 25)).foregroundColor(.white)
                            }
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing) {
                            Text("Nacimiento").bold().font(.system(size: 30)).foregroundColor(.white)
                            if editing {
                                TextEditor(text: $person.birth_year)
                                    .padding(.leading, 50)
                            } else {
                                Text(person.birth_year).font(.system(size: 25)).foregroundColor(.white)
                            }
                        }
                    }.padding()
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Altura").bold().font(.system(size: 30)).foregroundColor(.white)
                            if editing {
                                TextEditor(text: $person.height)
                                    .padding(.trailing, 50)
                            } else {
                                Text(person.height).font(.system(size: 25)).foregroundColor(.white)
                            }
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing) {
                            Text("Peso").bold().font(.system(size: 30)).foregroundColor(.white)
                            if editing {
                                TextEditor(text: $person.mass)
                                    .padding(.leading, 50)
                            } else {
                                Text(person.mass).font(.system(size: 25)).foregroundColor(.white)
                            }
                        }
                    }.padding()
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Color ojos").bold().font(.system(size: 30)).foregroundColor(.white)
                            if editing {
                                TextEditor(text: $person.eye_color)
                                    .padding(.trailing, 50)
                            } else {
                                Text(person.eye_color).font(.system(size: 25)).foregroundColor(.white)
                            }
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing) {
                            Text("Color pelo").bold().font(.system(size: 30)).foregroundColor(.white)
                            if editing {
                                TextEditor(text: $person.hair_color)
                                    .padding(.leading, 50)
                            } else {
                                Text(person.hair_color).font(.system(size: 25)).foregroundColor(.white)
                            }
                        }
                    }.padding()
                }
            }
            
            VStack {
                HStack {
                    Spacer()
                    
                    Button(action:{
                        if editing {
                            infoPeople.saveInfoPerson(context: viewContext, newInfoPerson: person)
                            infoPeople.updatePeopleCD(newPeopleCD: peopleCD)
                        }
                        
                        editing.toggle()
                    }){
                        if editing {
                            Image(systemName: "square.and.arrow.down")
                                .font(.system(size: 25))
                        } else {
                            Image(systemName: "pencil")
                                .font(.system(size: 30))
                        }
                    }
                    .frame(width: 40, height: 40)
                    .foregroundColor(Color("navBar"))
                    .background(Color.white)
                    .cornerRadius(30)
                    .padding()
                    .shadow(color: Color.black.opacity(0.3),
                            radius: 3,
                            x: 3,
                            y: 3)
                }
                
                Spacer()
            }
        }.navigationTitle(person.name)
        .alert(isPresented: $infoPeople.alertError) {
            Alert(title: Text("Error"), message: Text("API desde donde se obtienen los datos no disponible"), dismissButton: .default(Text("Ok")))
        }
    }
}

