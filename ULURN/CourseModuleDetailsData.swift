//
//  CourseModuleDetailsData.swift
//  ULURN
//
//  Created by Rakesh Chakraborty on 20/05/24.
//

import Foundation

//
// MARK: - Section Data Structure
//
public struct Item {
    var name: String
    var detail: String
    
    public init(name: String, detail: String) {
        self.name = name
        self.detail = detail
    }
}

public struct CourseModule {
    var name: String
    var code: String
    var items: [Item]
    var collapsed: Bool
    
    public init(name: String, code: String, items: [Item], collapsed: Bool = true) {
        self.name = name
        self.code = code
        self.items = items
        self.collapsed = collapsed
    }
}

public var courseModuleData: [CourseModule] = [
    CourseModule(name: "Mac", code: "0", items: [
        Item(name: "MacBook", detail: "Apple's ultraportable laptop, trading portability for speed and connectivity."),
        Item(name: "MacBook Air", detail: "While the screen could be sharper, the updated 11-inch MacBook Air is a very light ultraportable that offers great performance and battery life for the price."),
        Item(name: "MacBook Pro", detail: "Retina Display The brightest, most colorful Mac notebook display ever. The display in the MacBook Pro is the best ever in a Mac notebook."),
        Item(name: "iMac", detail: "iMac combines enhanced performance with our best ever Retina display for the ultimate desktop experience in two sizes."),
        Item(name: "Mac Pro", detail: "Mac Pro is equipped with pro-level graphics, storage, expansion, processing power, and memory. It's built for creativity on an epic scale."),
        Item(name: "Mac mini", detail: "Mac mini is an affordable powerhouse that packs the entire Mac experience into a 7.7-inch-square frame."),
        Item(name: "OS X El Capitan", detail: "The twelfth major release of OS X (now named macOS)."),
        Item(name: "Accessories", detail: "")
    ]),
    CourseModule(name: "iPad", code: "1", items: [
        Item(name: "iPad Pro", detail: "iPad Pro delivers epic power, in 12.9-inch and a new 10.5-inch size."),
        Item(name: "iPad Air 2", detail: "The second-generation iPad Air tablet computer designed, developed, and marketed by Apple Inc."),
        Item(name: "iPad mini 4", detail: "iPad mini 4 puts uncompromising performance and potential in your hand."),
        Item(name: "Accessories", detail: "")
    ]),
    CourseModule(name: "iPhone", code: "2", items: [
        Item(name: "iPhone 6s", detail: "The iPhone 6S has a similar design to the 6 but updated hardware, including a strengthened chassis and upgraded system-on-chip, a 12-megapixel camera, improved fingerprint recognition sensor, and LTE Advanced support."),
        Item(name: "iPhone 6", detail: "The iPhone 6 and iPhone 6 Plus are smartphones designed and marketed by Apple Inc."),
        Item(name: "iPhone SE", detail: "The iPhone SE was received positively by critics, who noted its familiar form factor and design, improved hardware over previous 4-inch iPhone models, as well as its overall performance and battery life."),
        Item(name: "Accessories", detail: "")
    ])
]
