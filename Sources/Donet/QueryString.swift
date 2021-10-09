//
//  QueryString.swift
//  donet
//
//  Created by laijihua on 2020/11/2.
//

import Foundation

fileprivate let paramDictKey = "site.loveli.donet"

public func querystring(req: IncomingMessage, res: ServerResponse, next: @escaping Next) {
    if let queryItems = URLComponents(string: req.header.uri)?.queryItems {
        req.userInfo[paramDictKey] = Dictionary(grouping: queryItems, by: { $0.name })
            .mapValues { $0.compactMap {$0.value}.joined(separator: ",") }
    }
    next()
}

public extension IncomingMessage {
    func param(_ id: String) -> String? {
        return (userInfo[paramDictKey] as? [String : String])?[id]
    }
}
