import Hummingbird
import Logging
import NIOCore

struct MultipartRequestContext: RequestContext {
    var requestDecoder: MultipartRequestDecoder { .init() }
    var coreContext: CoreRequestContextStorage
    public var maxUploadSize: Int { 2000 * 1024 * 1024 }

    init(source: Source) {
        self.coreContext = .init(source: source)
    }
}

