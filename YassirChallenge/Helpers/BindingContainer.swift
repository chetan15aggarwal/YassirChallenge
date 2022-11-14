//
// YassirChallenge
// Created by Chetan Aggarwal.

import Foundation

final class Container<Element> {
    typealias CompletionHandler = (Element?) -> Void

    var handler: CompletionHandler?
    var value: Element? {
        didSet {
            guard let value = self.value else {return}
            handler?(value)
        }
    }

    init(value: Element?, handler: CompletionHandler? = nil) {
        self.value = value
        self.handler = handler
    }

    func bind(withHandler handler: @escaping CompletionHandler) {
        self.handler = handler
        self.handler!(value)
    }
}
