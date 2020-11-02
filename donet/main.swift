//
//  main.swift
//  donet
//
//  Created by laijihua on 2020/11/2.
//

let app = DoNet()

app.use(querystring)

app.use { req, res, next in
    print("\(req.header.method):", req.header.uri)
    next() // 继续处理
}

app.get("/hel") { (_, res, _) in
    res.send("Hello")
}

app.get("/") { (req, res, _) in
    let text = req.param("text") ?? "no text"
    res.send("Hello, \(text) world")
}


app.listen(1338)
