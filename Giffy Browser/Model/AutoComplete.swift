//
//  AutoComplete.swift
//  Giffy Browser
//
//  Created by Vineet Rai on 19/03/21.
//

import Foundation

class AutoComplete {
    static let storedTriePath = "/tmp/trieDict"
    static let dictonaryWordsPath = "/usr/share/dict/words"
    
    let trie : Trie
    
    init() throws {
        do {
            self.trie = try Trie(storedDataPath: AutoComplete.storedTriePath)
        } catch  {
            trie = try Trie(dictonaryWordsPath: AutoComplete.dictonaryWordsPath)
            try trie.save(path: AutoComplete.storedTriePath)
        }
    }
    
    func reset() throws {
        try Trie.remove(path: AutoComplete.storedTriePath)
    }
    
    func findValues(forTerm string : String) -> [String] {
        if string == "resetme" {
            do {
                try reset()
                print("reset complete")
                
            } catch {
                print("reset failed")
            }
        }
        // need more than 2 chars otherwise lists are too long. 
        return string.count >= 2 ? trie.findValues(forTerm: string) : []
    }
}
