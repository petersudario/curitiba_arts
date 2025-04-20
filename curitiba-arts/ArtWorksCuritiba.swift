//
//  ArtWorksCuritiba.swift
//  curitiba-arts
//
//  Created by Pedro Henrique Sudario da Silva on 20/04/25.
//

// Estrutura de dados padrão das obras de arte pra ficar evitando duplicidade de código

public struct ArtWorksCuritiba {
    public let title: String
    public let artist: String
    public let year: Int
    public let style: String
    public let imageName: String
    public let description: String
    
    public init(title: String, artist: String, year: Int, style: String, imageName: String, description: String) {
        self.title = title
        self.artist = artist
        self.year = year
        self.style = style
        self.imageName = imageName
        self.description = description
    }
    
}
