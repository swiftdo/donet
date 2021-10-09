//
//  IncomingMessage.swift
//  donet
//
//  Created by laijihua on 2020/11/2.
//

import NIOHTTP1

open class IncomingMessage {
    
    public let header : HTTPRequestHead
    
    public var userInfo = [String: Any]()
    
    init(header: HTTPRequestHead) {
        self.header = header
    }
    
}
