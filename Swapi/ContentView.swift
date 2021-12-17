//
//  ContentView.swift
//  Swapi
//
//  Created by Jose Alberto Garcia Collado on 15/12/21.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(entity: PersonCD.entity(), sortDescriptors: [], animation: .spring())
    var peopleCD: FetchedResults<PersonCD>
    
    init() {
        UITabBar.appearance().barTintColor = UIColor.black
    }

    var body: some View {
        ZStack {
            Color("navBar").edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            
            VStack {
                TabView {
                    FilmsView()
                        .tabItem {
                            Label("Películas", systemImage: "house")
                        }
                    
                    PeopleView()
                        .tabItem {
                            Label("Personajes", systemImage: "person")
                        }
                }.accentColor(Color("itemTabBar"))
            }
        }
    }
}

