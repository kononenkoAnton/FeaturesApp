//
//  LoadImageRepository.swift
//  CountryCodeExample
//
//  Created by Anton Kononenko on 11/2/24.
//

import UIKit

protocol PosterImageRepository {
    func loadImage(imagePath: String,
                   width: Int) async throws -> UIImage
}

// Thinks about optimization to load big if exist, resize and save both
class DefaultPosterImageRepository: PosterImageRepository {
    let networkService: any NetworkServiceProtocol

    init(networkService: any NetworkServiceProtocol) {
        self.networkService = networkService
    }
}

enum ImageError: Error {
    case decodingFailed
}

class ImageDecoder: DTODecodable {
    func decodeDTO(from data: Data) throws -> UIImage {
        guard let image = UIImage(data: data) else {
            // TODO: think about error that will be universal
            throw ImageError.decodingFailed
        }

        return image
    }
}

extension DefaultPosterImageRepository {
    func loadImage(imagePath: String, width: Int) async throws -> UIImage {
        let endpoint = APIStorage.posterImageEndpoint(path: imagePath, width: width)

        return try await networkService.fetchURL(endPoint: endpoint,
                                                 decoder: ImageDecoder())
    }
}
