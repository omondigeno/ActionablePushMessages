//
//  NLP.swift
//  PushedActionableMessages
//
//  Created by Samuel Geno on 15/04/2016.
//  Copyright © 2016 Geno. All rights reserved.
//

import Foundation

/** Shows how natural language processing can be used to extract actions from messages. It is a naive implementation but the aim is just to show an interesting possibility. Verbs/actions to look out for can be defined in a database that can be updated remotely to allow ability to add actions dynamically. How they are handled can also be defined by rules in a database. With time we can use methods like link grammar parsing to extract actions from any sentence.
*/
class NLP {
    
    /// Adverbs to look out for
    static let adverbs = ["Please", "Kindly"]
    /// Adverbs to look out for. Could be stored in a database
    static let verbs = ["pay"]
    
    class func extractAction (sentence: String) -> Action? {
        
        let options: NSLinguisticTaggerOptions = [.OmitWhitespace, .OmitPunctuation, .JoinNames]
        
        let schemes = NSLinguisticTagger.availableTagSchemesForLanguage("en")
        
        let tagger = NSLinguisticTagger(tagSchemes: schemes, options: Int(options.rawValue))
        
        tagger.string = sentence
        
        var previousTagOrEntity: String?
        var previousWord: String?
        var action: Action?
        
        tagger.enumerateTagsInRange(NSMakeRange(0, (sentence as NSString).length), scheme: NSLinguisticTagSchemeNameTypeOrLexicalClass, options: options) { (tag, tokenRange, _, _) in
            
            let token = (sentence as NSString).substringWithRange(tokenRange)

            if tag == NSLinguisticTagVerb, let previousTag = previousTagOrEntity,  previousToken = previousWord where previousTag == NSLinguisticTagAdverb {
            
                for verb  in verbs {
                    if (verb.caseInsensitiveCompare(token) == .OrderedSame){
                        
                        for adverb  in adverbs {
                            if (adverb.caseInsensitiveCompare(previousToken) == .OrderedSame ){
                               action = Action(type: verb)
                                break
                            }
                        }
                        
                    }
                    if action != nil {
                    break
                    }
                }
                
            }else if let foundAction = action where tag == NSLinguisticTagNumber {
            foundAction.addObject(token)
            }
            
            previousTagOrEntity = tag
            previousWord = token
            print("\(token): \(tag)")

        }
        
        print("\(action?.objects?[0])")

        return action
    }
}
    