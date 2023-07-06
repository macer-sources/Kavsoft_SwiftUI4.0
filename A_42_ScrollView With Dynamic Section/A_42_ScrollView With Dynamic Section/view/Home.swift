//
//  Home.swift
//  A_42_ScrollView With Dynamic Section
//
//  Created by Kan Tao on 2023/7/6.
//

import SwiftUI

struct Home: View {
    // MARK: View Properties
    @State var characters:[Character] = []
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 0) {
                    // MARK: Sample Contacts View
                    ForEach(characters) { char in
                        ContactsForCharacter(character: char)
                    }
                }
                .padding(.top, 15)
            }
            .navigationTitle("Contact's")
        }
        .onAppear {
            characters = fetchingCharacters()
        }
    }
    
    // MARK: Contact Row For Each Alphabet
    @ViewBuilder
    func ContactsForCharacter(character: Character) -> some View {
        VStack(alignment: .leading, spacing: 15) {
            Text(character.value)
                .font(.largeTitle.bold())
            ForEach(1...4, id: \.self) { index  in
                HStack(spacing: 10) {
                    Circle().fill(character.color.gradient)
                        .frame(width: 45, height: 45)
                    VStack(alignment: .leading, spacing: 8) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(character.color.opacity(0.4).gradient)
                            .frame(height: 20)
                        RoundedRectangle(cornerRadius: 4)
                            .fill(character.color.opacity(0.6).gradient)
                            .frame(height: 20)
                            .padding(.trailing, 80)
                    }
                }
            }
        }
        .padding(15)
    }
    
    // MARK: Fetching Characters
    func fetchingCharacters() -> [Character] {
        let alphabets:String = "ABCDEFGHIGKLMNOPQRSTUVWXYZ"
        var characters = alphabets.compactMap { char -> Character in
            return Character.init(value: String(char))
        }
        
        let colors:[Color] = [.red,.yellow,.pink,.orange,.cyan,.indigo,.purple,.blue]
        
        // MARK: Setting Index And Random Color
        for index in characters.indices {
            characters[index].index = index
            characters[index].color = colors.randomElement() ?? .red
        }
        return characters
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
