//
//  FilmCardView.swift
//  Swapi
//
//  Created by Jose Alberto Garcia Collado on 15/12/21.
//

import SwiftUI

struct CardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .cornerRadius(20)
    }
}

/// Vista de la carta de una película
struct FilmCardView: View {
    let film: Film
    var sinNombre = false
    
    var body: some View {
        HStack {
            FilmImageView(withURL: "https://images-na.ssl-images-amazon.com/images/I/81xumDEQaKL.jpg")
            
            Spacer(minLength: 25)
            
            VStack(alignment: .center) {
                if (!sinNombre){
                    Text(film.title)
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        .foregroundColor(Color.white)
                        .padding(.top, 5)
                }
                
                ExpandableTextView(film.opening_crawl, lineLimit: 7)
                    .foregroundColor(Color.white)
                    .frame(alignment: .leading)
                    .padding(.top, 6)
                
                HStack {
                    Spacer()
                    
                    Text(film.release_date.prefix(4))
                        .foregroundColor(Color.white)
                        .padding(.trailing, 10)
                        .padding(.bottom, 5)
                }.padding(.top, 5)
            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
        //.background(Color("filmCard"))
        .modifier(CardModifier())
        /*.overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color("border"), lineWidth: 2)
            )*/
        .padding(.all, 5)
    }
}
