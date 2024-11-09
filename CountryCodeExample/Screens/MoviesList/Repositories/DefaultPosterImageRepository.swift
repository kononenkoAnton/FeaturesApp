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
    let cache: any InMemoryNSCacheable

    init(networkService: any NetworkServiceProtocol,
         cache: any InMemoryNSCacheable = DefaultInMemoryNSCacheable()) {
        self.networkService = networkService
        self.cache = cache
    }

    func loadImage(imagePath: String, width: Int) async throws -> UIImage {
        //Create request
        let endpoint = APIStorage.posterImageEndpoint(path: imagePath,
                                                      width: width)

        if cachedImage = cache.get(forKey: endpoint)
            
            // Send request
        return try await networkService.fetchURL(endPoint: endpoint,
                                                 decoder: ImageDecoder())
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

// In-Memory Size (bytes) = Width × Height × Bytes Per Pixel
// other option image.pngData()?.count
extension UIImage {
    var memorySize: Int {
        guard let cgImage else {
            return 0
        }

        let bytesPerRow = cgImage.bytesPerRow
        return bytesPerRow * cgImage.height
    }
}
