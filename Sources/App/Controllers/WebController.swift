//===----------------------------------------------------------------------===//
//
// This source file is part of the Hummingbird server framework project
//
// Copyright (c) 2021-2021 the Hummingbird authors
// Licensed under Apache License v2.0
//
// See LICENSE.txt for license information
// See hummingbird/CONTRIBUTORS.txt for the list of Hummingbird authors
//
// SPDX-License-Identifier: Apache-2.0
//
//===----------------------------------------------------------------------===//

import Hummingbird
import Mustache

struct HTML: ResponseGenerator {
    let html: String

    public func response(from request: Request, context: some RequestContext) throws -> Response {
        let buffer = ByteBuffer(string: self.html)
        return .init(status: .ok, headers: [.contentType: "text/html"], body: .init(byteBuffer: buffer))
    }
}

struct WebController {
    let library: MustacheLibrary
    let enterTemplate: MustacheTemplate
    let enteredTemplate: MustacheTemplate

    init(mustacheLibrary: MustacheLibrary) {
        self.library = mustacheLibrary
        self.enterTemplate = mustacheLibrary.getTemplate(named: "enter-details")!
        self.enteredTemplate = mustacheLibrary.getTemplate(named: "details-entered")!
    }

    func addRoutes(to router: some RouterMethods<some RequestContext>) {
        router.get("/", use: self.input)
        router.post("/", use: self.post)
        router.post("/filepart", use: self.dene)
    }

    @Sendable func input(request: Request, context: some RequestContext) -> HTML {
        let html = self.enterTemplate.render((), library: self.library)
        return HTML(html: html)
    }

    @Sendable func post(request: Request, context: some RequestContext) async throws -> HTML {
        let user = try await request.decode(as: User.self, context: context)
        let html = self.enteredTemplate.render(user, library: self.library)
        return HTML(html: html)
    }
    
    @Sendable func dene(request: Request, context: some RequestContext) async throws -> HTML {
        let encoded = try! await request.decode(as: SomethingWithFile.self, context: context)

        return HTML(html: encoded.parameter)
    }
}

import Foundation

struct SomethingWithFile: Codable {
    let file: Data
    let parameter: String
    let variable: String
}
