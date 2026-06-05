//
//  APIKeys.swift
//  Recap AI
//
//  Created by Hiren on 27/05/26.
//

import Foundation

enum APIKeys {
    
    static var openAI: String {
        KeychainManager.get(key: "openai_api_key") ?? ""
    }

}

