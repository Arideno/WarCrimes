//
//  FileDataLoader.swift
//  WarCrimes
//
//  Created by Anonymous on 30.09.2022.
//

import Foundation
import Combine

final class FileDataLoader: DataLoder {
    var fileName: String
    var bundle: Bundle

    init(fileName: String, in bundle: Bundle = .main) {
        self.fileName = fileName
        self.bundle = bundle
    }

    func load() -> AnyPublisher<Data, Error> {
        if let fileUrl = bundle.url(forResource: fileName, withExtension: nil) {
            do {
                let data = try Data(contentsOf: fileUrl)
                return Just(data).setFailureType(to: Error.self).eraseToAnyPublisher()
            } catch {
                return Fail(error: FileLoaderError.errorReadFile).eraseToAnyPublisher()
            }
        } else {
            return Fail(error: FileLoaderError.fileNotFound).eraseToAnyPublisher()
        }
    }
}

enum FileLoaderError: Error {
    case fileNotFound
    case errorReadFile
}
