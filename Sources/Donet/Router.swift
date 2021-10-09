//
//  Router.swift
//  donet
//
//  Created by laijihua on 2020/11/2.
//

open class Router {
    
    public init() {}
    
    private var middleware = [Middleware]()
    
    open func use(_ middleware: Middleware...) {
        self.middleware.append(contentsOf: middleware)
    }
    
    func handle(request: IncomingMessage, response: ServerResponse, next upperNext:@escaping Next) {
        
        let stack = self.middleware
        
        guard !stack.isEmpty else { return upperNext() }
        
        var next: Next = { (args: Any...) in }
        var i = stack.startIndex
        
        next = { (args: Any...) in
            let middleware = stack[i]

            i = stack.index(after: i)
            
            let isLast = i == stack.endIndex
            
            middleware(request, response, isLast ? upperNext : next)
        }
        
        next()
        
    }
}

public extension Router {
    func get(_ path: String, middleware: @escaping Middleware) {
        use{ req, res, next in
            guard req.header.method == .GET, req.header.uri.hasPrefix(path) else { return next() }
            middleware(req, res, next)
        }
    }
}
