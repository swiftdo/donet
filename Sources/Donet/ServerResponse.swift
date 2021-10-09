//
//  ServerResponse.swift
//  donet
//
//  Created by laijihua on 2020/11/2.
//

import NIO
import NIOHTTP1

import struct Foundation.Data
import class  Foundation.JSONEncoder


open class ServerResponse {
    public let channel: Channel
    
    public var status = HTTPResponseStatus.ok
    public var headers = HTTPHeaders()
    
    private var didWriteHeader = false
    private var didEnd = false
    
    public init(channel: Channel) {
        self.channel = channel
    }
    
    open func send(_ s: String) {
        flushHeader()
        
        let utf8 = s.utf8
        var buffer = channel.allocator.buffer(capacity: utf8.count)
        buffer.writeBytes(utf8)
        let part = HTTPServerResponsePart.body(.byteBuffer(buffer))
        
        _ = channel
            .writeAndFlush(part)
            .recover(handleError)
            .map(end)
    }
    
    func flushHeader() {
        guard !didWriteHeader else { return }
        
        didWriteHeader = true
        let head = HTTPResponseHead(version: .init(major: 1, minor: 1), status: status, headers: headers)
        let part = HTTPServerResponsePart.head(head)
        
        _ = channel
            .writeAndFlush(part)
            .recover(handleError)
    }
    
    func handleError(_ error: Error) {
         end()
    }
    
    func end() {
        guard !didEnd else { return }
        
        didEnd = true
        _ = channel
            .writeAndFlush(HTTPServerResponsePart.end(nil))
            .map { self.channel.close() }
    }
    
}

public extension ServerResponse {
    
    func json<T: Encodable>(_ model: T) {
        
        let data : Data
        do {
          data = try JSONEncoder().encode(model)
        } catch {
          return handleError(error)
        }
        
        // setup JSON headers
        self["Content-Type"]   = "application/json"
        self["Content-Length"] = "\(data.count)"
        
        // send the headers and the data
        flushHeader()
        
        var buffer = channel.allocator.buffer(capacity: data.count)
        buffer.writeBytes(data)
        let part = HTTPServerResponsePart.body(.byteBuffer(buffer))

        _ = channel.writeAndFlush(part)
                   .recover(handleError)
                   .map(end)
        
    }
    
}

public extension ServerResponse {

    subscript(name: String) -> String? {
        set {
          assert(!didWriteHeader, "header is out!")
          if let v = newValue {
            headers.replaceOrAdd(name: name, value: v)
          }
          else {
            headers.remove(name: name)
          }
        }
        get {
          return headers[name].joined(separator: ", ")
        }
    }
}
