//
//  Trie.swift
//  Giffy Browser
//
//  Created by Vineet Rai on 19/03/21.
//

import Foundation

class Trie {
    enum TrieErrors : Error {
        case loadError
        case saveError
    }
    
    private let root: Node
    
    init(dictonaryWordsPath: String, size: Int = Int.max) throws {
        root = try Constructor.constructTrie(dataPath: dictonaryWordsPath, size: size)
    }
    
    init(storedDataPath: String) throws {
        root = try Trie.load(path: storedDataPath)
    }
    
    fileprivate class Node: Encodable, Decodable {
        var children: [String: Node] = [:] // can't encode decode characters
        let isLeaf: Bool
        
        init(isLeaf: Bool) {
            self.isLeaf = isLeaf
        }
        
        func addRemaining(_ word : String) {
            var word = word
            let char = String(word.removeFirst())
            let child = children[char, default:  Node(isLeaf: word.isEmpty)]
            children[char] = child
            
            if !word.isEmpty {
                child.addRemaining(word)
            }
        }
        
        func findBase(_ word  : String) -> Trie.Node? {
            var word = word
            if !word.isEmpty {
                let char = String(word.removeFirst())
                
                if let trie = children[char] {
                    return trie.findBase(word)
                } else {
                    return nil
                }
            }
            return self
        }
        
        func compileResults(fromBase baseString: String,
                                    path : String, results : inout [String]) {
            if isLeaf {
                results.append("\(baseString)\(path)")
            }
            
            for (key, value) in children {
                let newPath = "\(path)\(key)"
                value.compileResults(fromBase: baseString, path: newPath, results: &results)
            }
        }
    }
    
    /// returns results in sorted order
    func findValues(forTerm string : String) -> [String] {
        let transformedString = string.lowercased()
        let base = root.findBase(transformedString)
        var results: [String] = []
        base?.compileResults(fromBase: transformedString, path:"", results: &results)
        results.sort(by: <)
        return results
    }
    
    class Constructor {
        fileprivate static func constructTrie(dataPath: String, size: Int = Int.max) throws -> Trie.Node {
            // just read the first N words from dictionary.
            let file = try String(contentsOfFile: dataPath, encoding: .utf8)
            let split = file.split(separator: "\n")
            let words = size == Int.max ? split[0..<split.count] : split[0..<size]
            return addWords(words)
        }
        
        private static func addWords(_ words : ArraySlice<String.SubSequence>) -> Trie.Node {
            let node =  Node(isLeaf: false)
            for word in words {
                print(word)
                node.addRemaining(word.lowercased())
            }
            return node
        }
    }
    
    func save(path: String) throws {
        let encoder = JSONEncoder()
        let data = try encoder.encode(root)
        let string = String(data: data, encoding: .utf8)
        try string?.write(toFile: path, atomically: true, encoding: .utf8)
    }
    
    fileprivate static func load(path: String) throws -> Node {
        let string = try String(contentsOfFile: path, encoding: .utf8)
        let decoder = JSONDecoder()
        if let data = string.data(using: .utf8, allowLossyConversion: false) {
            return try decoder.decode(Node.self, from: data)
        } else {
            throw TrieErrors.loadError
        }
    }
    
    static func remove(path: String) throws {
        try FileManager.default.removeItem(atPath: path)
    }
}

