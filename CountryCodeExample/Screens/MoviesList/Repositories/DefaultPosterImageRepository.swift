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

enum RepositoryError: Error {
    case canNotCreateURL
}

// Thinks about optimization to load big if exist, resize and save both
class DefaultPosterImageRepository<ImageCachable: InMemoryNSCacheable>: PosterImageRepository where ImageCachable.Value == UIImage {
    let networkService: any NetworkServiceProtocol
    let cache: ImageCachable
    let requestBuilder: RequestBuilder

    init(networkService: any NetworkServiceProtocol,
         requestBuilder: RequestBuilder,
         cache: ImageCachable = DefaultInMemoryNSCacheable()) {
        self.networkService = networkService
        self.cache = cache
        self.requestBuilder = requestBuilder
    }

    func loadImage(imagePath: String, width: Int) async throws -> UIImage {
        // Create request
        let endpoint = APIStorage.posterImageEndpoint(path: imagePath,
                                                      width: width)
        let request = try requestBuilder.request(endpoint: endpoint)

        guard let urlString = request.url?.absoluteString else {
            throw RepositoryError.canNotCreateURL
        }

        if let cachedImage = cache.get(forKey: urlString) {
            return cachedImage
        }

        let image = try await networkService.fetchRequest(request: request,
                                                          decoder: ImageDecoder())
        cache.set(value: image, forKey: urlString)

        return image
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
