//
//  NLP.swift
//  PushedActionableMessages
//
//  Created by Samuel Geno on 15/04/2016.
//  Copyright © 2016 Geno. All rights reserved.
//

import Foundation

/** Shows how natural language processing can be used to extract actions from messages. It is a naive implementation but the aim is just to show an interesting possibility. Verbs/actions to look out for can be defined in a database that can be updated remotely to allow ability to add actions dynamically. How they are handled can also be defined by rules in a database. With time we can use methods like **link grammar** parsing to extract actions from any sentence.
*/
class NLP {
    
    /// Adverbs to look out for
    static let adverbs = ["Please", "Kindly"]
    /// Adverbs to look out for. Could be stored in a database
    static let verbs = ["pay"]
    
    /**
     Uses NSLinguisticTagger, a Foundation class, to determine parts of speech of words in a sentence then
     uses that knowledge to extract actions
     
     - Parameters:
     - sentence: sentence to investigate. Currently a whole message is considered a sentence. In future a sentence detector can be used.
     
     - Returns: an action if found.
     */
    class func extractAction (sentence: String) -> Action? {
        
        ///We are not interested in whitespace or punctuations now. We also need names to be joined
        let options: NSLinguisticTaggerOptions = [.OmitWhitespace, .OmitPunctuation, .JoinNames]
        
        ///We are dealing with english
        let schemes = NSLinguisticTagger.availableTagSchemesForLanguage("en")
        
        ///Initialize tagger with options and english schemes
        let tagger = NSLinguisticTagger(tagSchemes: schemes, options: Int(options.rawValue))
        
        ///specify the sentence we would like to parse
        tagger.string = sentence
        
        ///holds previous tag or class found
        var previousTagOrEntity: String?
        ///holds previous word/token found
        var previousWord: String?
        ///the action that we will find, or nil if we found none
        var action: Action?
        
        ///Parses the sentence and serves us with the tag or entity type together with the range in which it is found in the string
        tagger.enumerateTagsInRange(NSMakeRange(0, (sentence as NSString).length), scheme: NSLinguisticTagSchemeNameTypeOrLexicalClass, options: options) { (tag, tokenRange, _, _) in
            
            ///Get token using the range provided
            let token = (sentence as NSString).substringWithRange(tokenRange)

            ///If currently have a verb, and the previous word was an adverb of interjection. For example, we are looking for "please" used as an interjection or adverb
            if tag == NSLinguisticTagVerb, let previousTag = previousTagOrEntity,  previousToken = previousWord where previousTag == NSLinguisticTagAdverb || previousTag == NSLinguisticTagInterjection{
            
               ///Look for verbs in the verbs array, like pay
                for verb  in verbs {
                    if (verb.caseInsensitiveCompare(token) == .OrderedSame){
                        
                       ///Check if previous word is an adverb/interjection that is in the list we are interested in
                        for adverb  in adverbs {
                            if (adverb.caseInsensitiveCompare(previousToken) == .OrderedSame ){
                                ///if so we have our action, so we move on
                               action = Action(type: verb)
                                break
                            }
                        }
                        
                    }
                    ///We expect one action in a message, once we have one, we are done
                    if action != nil {
                    break
                    }
                }
              
                ///Look for the object of our verb/action. For pay action we are looking for a number
            }else if let foundAction = action where tag == NSLinguisticTagNumber {
            foundAction.addObject(token)
            }
            
            ///Keep track of previous tag and token
            previousTagOrEntity = tag
            previousWord = token
            print("\(token): \(tag)")

        }
        

        return action
    }
}
    