//
//  ModelLoader.swift
//  Beers
//
//  Created by Olalla Gómez Reyes on 9/6/22.
//

import Foundation

struct ModelLoader<Model: Identifiable & Decodable> {
    var urlSession = URLSession.shared
    var urlResolver: (Model.ID) -> URL

    func loadModel(withID id: Model.ID) -> AnyPublisher<Model, Error> {
        urlSession.publisher(for: urlResolver(id))
    }
}
