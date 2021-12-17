//
//  PersonCardView.swift
//  Swapi
//
//  Created by Jose Alberto Garcia Collado on 15/12/21.
//

import SwiftUI

/// Vista de la carta de un personaje
struct PersonCardView: View {
    let person: Person
    
    var body: some View {
        HStack {
            Image(systemName: "person")
                .resizable()
                .frame(width: 100, height: 100)
                .foregroundColor(Color.white)
            
            Spacer(minLength: 25)
            
            VStack(alignment: .leading) {
                Text(person.name)
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    .foregroundColor(Color.white)
                
                HStack {
                    Text(person.gender)
                        .foregroundColor(Color.white)
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                        .padding(.top, 6)
                    
                    Spacer()
                    
                    Text(person.birth_year)
                        .foregroundColor(Color.white)
                }.padding(.top, 5)
            }
        }.padding()
        .background(Color("navBarFuerte"))
    }
}
