//
//  LoadImageRepository.swift
//  CountryCodeExample
//
//  Created by Anton Kononenko on 11/2/24.
//

import UIKit

protocol PosterImageRepository: AnyObject {
    func loadImage(posterPath: String,
                   width: Int) async throws -> UIImage
    func cancelLoad(posterPath: String,
                    width: Int) throws
    func cancelLoadAll() throws
}

enum RepositoryError: Error {
    case canNotCreateURL
}

// Thinks about optimization to load big if exist, resize and save both
class DefaultPosterImageRepository<ImageCachable: InMemoryNSCacheable>: PosterImageRepository where ImageCachable.Value == UIImage {
    let networkService: any NetworkServiceProtocol
    let imageCache: ImageCachable
    let taskCache: any TaskCacheable
    let requestBuilder: RequestBuilder

    init(networkService: any NetworkServiceProtocol,
         requestBuilder: RequestBuilder,
         cache: ImageCachable = DefaultInMemoryCache(),
         taskCache: any TaskCacheable = DefaultPosterImageTaskCache()) {
        self.networkService = networkService
        imageCache = cache
        self.requestBuilder = requestBuilder
        self.taskCache = taskCache
    }

    func loadImage(posterPath: String, width: Int) async throws -> UIImage {
        // Create request
        let endpoint = APIStorage.posterImageEndpoint(path: posterPath,
                                                      width: width)
        let request = try requestBuilder.request(endpoint: endpoint)

        guard let urlString = request.url?.absoluteString else {
            throw RepositoryError.canNotCreateURL
        }

        if let cachedImage = imageCache.get(forKey: urlString) {
            return cachedImage
        }

        let image = try await networkService.fetchRequest(request: request,
                                                          decoder: ImageDecoder())
        imageCache.set(value: image, forKey: urlString)
        taskCache.remove(forKey: urlString)
        return image
    }

    func cancelLoad(posterPath: String, width: Int) throws {
        let endpoint = APIStorage.posterImageEndpoint(path: posterPath,
                                                      width: width)

        guard let url = try requestBuilder.url(endpoint: endpoint) else {
            return
        }

        taskCache.remove(forKey: url.absoluteString)
    }

    func cancelLoadAll() throws {
        taskCache.removeAll()
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
