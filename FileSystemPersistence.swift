//
//  FileSystemPersistance.swift
//  Quiz
//
//  Created by Oleksii Mykhalchuk on 8/12/22.
//

import Foundation

protocol Persistencable {
    func readFile<T: Codable>(type: T.Type, forResourse: String, ofType: String) -> T?
    func writeToFile<T: Codable>(fileName: String, data: T)
}

class FileSystemPersistance: Persistencable {

    func readFile<T>(type: T.Type,
                     forResourse: String,
                     ofType: String) -> T?
    where
T: Encodable,
T: Decodable {
        if let path = Bundle.main.path(forResource: forResourse, ofType: ofType) {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let decoder = JSONDecoder()
                let result = try decoder.decode(T.self, from: data)
                print("data")
                return result
            } catch {
                print("****\(String(describing: self)) in \(#function) Error \(error)")
                return nil
            }
        }
        return nil
    }
    
    func writeToFile<T>(fileName: String,
                        data: T)
    where
T: Encodable,
T: Decodable {
        let encoder = JSONEncoder()
        do {
            let encode = try encoder.encode(data)
            if let directory = FileManager.default.urls(
                for: .documentDirectory,
                in: .userDomainMask)
                .first?
                .appendingPathComponent(fileName) {
            try encode.write(to: directory)
            print("Saved")
            }
        } catch {
            print("\(String(describing: self)) in \(#function) Error \(error)")
        }
    }
}
