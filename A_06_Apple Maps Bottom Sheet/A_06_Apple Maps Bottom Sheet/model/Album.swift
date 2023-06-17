//
//  Album.swift
//  A_06_Apple Maps Bottom Sheet
//
//  Created by Kan Tao on 2023/6/16.
//

import Foundation


struct Album: Identifiable {
    var id = UUID().uuidString
    var name: String
    var image: String
    var liked: Bool = false
}

var albums:[Album] = [
    Album(name: "Positions", image: "Album1"),
    Album(name: "The Best", image: "Album2",liked: true),
    Album(name: "My Everything", image: "Album3"),
    Album(name: "Yours Truly", image: "Album4", liked: true),
    Album(name: "Sweetener", image: "Album5"),
    Album(name: "Rain On Me", image: "Album6"),
    Album(name: "Struck With U", image: "Album7", liked:true),
    Album(name: "7 rings", image: "Album8"),
    Album(name: "Bang Bang", image: "Album9"),
]



