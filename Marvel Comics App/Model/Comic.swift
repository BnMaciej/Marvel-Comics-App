//
//  Comic.swift
//  Marvel Comics App
//
//  Created by Maciej Banaszyński on 18/06/2021.
//

import SwiftUI

struct APIResult: Codable{
    var data: APIComicData
}

struct APIComicData: Codable{
    var count: Int
    var results: [Comic]
}

struct CreatorList:Codable{
    var items: [CreatorSummary]
    
}

struct CreatorSummary: Codable{
    var name: String
}

struct Comic: Identifiable,Codable{
    var id: Int
    var title: String
    var creators: CreatorList
    var description: String?
    var thumbnail: [String: String]
    var urls: [[String: String]]
}


