//
//  Middleware.swift
//  donet
//
//  Created by laijihua on 2020/11/2.
//

public typealias Next = ( Any... ) -> Void

public typealias Middleware = (IncomingMessage, ServerResponse, @escaping Next) -> Void


