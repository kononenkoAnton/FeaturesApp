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

class PosterImageCaching: Cacheable {
    typealias Key = String
    typealias Value = UIImage
    // Note: Do not forget NSDiscardableContent protocol
    private let cache: NSCache<NSString, UIImage> = NSCache()

    init(countLimit: Int,
         totalCostLimit: Int) {
        cache.countLimit = countLimit
        cache.totalCostLimit = totalCostLimit

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleMemoryWarning),
                                               name: UIApplication.didReceiveMemoryWarningNotification,
                                               object: nil)
    }

    @objc func handleMemoryWarning() {
        clearAll()
    }

    func set(value: UIImage,
             forKey key: String) {
        cache.setObject(value,
                        forKey: key as NSString,
                        cost: value.memorySize)
    }

    func get(forKey key: String) -> UIImage? {
        cache.object(forKey: key as NSString)
    }

    func remove(forKey key: String) {
        cache.removeObject(forKey: key as NSString)
    }

    func clearAll() {
        cache.removeAllObjects()
    }
}
