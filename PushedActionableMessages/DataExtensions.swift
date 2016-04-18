//
//  DataExtensions.swift
//  PushedActionableMessages
//
//  Created by Samuel Geno on 17/04/2016.
//  Copyright © 2016 Geno. All rights reserved.
//

import Foundation

extension String {
    
    /**
     Capitalizes the first letter of words in a string
     */
    
    var wordCaps:String {
        let listOfWords:[String] = self.componentsSeparatedByString(" ")
        var returnString: String = ""
        for word in listOfWords {
            if word != "" {
                var capWord = word.lowercaseString as String
                capWord.replaceRange(startIndex...startIndex, with: String(capWord[capWord.startIndex]).uppercaseString)
                returnString = returnString + capWord + " "
            }
        }
        if returnString.hasSuffix(" ") {
            returnString.removeAtIndex(returnString.endIndex.predecessor())
        }
        return returnString
    }
}