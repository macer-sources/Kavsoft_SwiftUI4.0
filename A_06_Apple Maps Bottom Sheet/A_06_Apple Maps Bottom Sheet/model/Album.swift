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
    Album(name: "Positions", image: "Funny Bunny-1"),
    Album(name: "The Best", image: "Funny Bunny-2",liked: true),
    Album(name: "My Everything", image: "Funny Bunny-3"),
    Album(name: "Yours Truly", image: "Funny Bunny-4", liked: true),
    Album(name: "Sweetener", image: "Funny Bunny-5"),
    Album(name: "Rain On Me", image: "Funny Bunny-6"),
    Album(name: "Struck With U", image: "Funny Bunny-7", liked:true),
    Album(name: "7 rings", image: "Funny Bunny-8"),
    Album(name: "Bang Bang", image: "Funny Bunny-9"),
]



