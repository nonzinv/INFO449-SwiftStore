//
//  main.swift
//  Store
//
//  Created by Ted Neward on 2/29/24.
//

import Foundation

protocol SKU {
    var name: String { get }
    func price() -> Int
}

protocol PricingScheme {
    func apply(items: [SKU]) -> Int
}

class Item: SKU {
    var name: String
    private var itemPrice: Int
    
    init(name: String, priceEach: Int) {
        self.name = name
        self.itemPrice = priceEach
    }
    func price() -> Int {
            return itemPrice
        }
}

class Receipt {
    private var items: [SKU] = []

    func addItem(_ item: SKU) {
        items.append(item)
    }
    func itemsList() -> [SKU] {
        return items
    }
    func output() -> String {
        var outputString = "Receipt:\n"
        for item in items {
            outputString += "\(item.name): $\(String(format: "%.2f", Double(item.price()) / 100))\n"
        }
        outputString += "------------------\n"
        outputString += "TOTAL: $\(String(format: "%.2f", Double(items.reduce(0) { $0 + $1.price() }) / 100))"
        return outputString
    }
    func total() -> Int {
        return items.reduce(0) { $0 + $1.price() }
    }
    func clear() {
        items.removeAll()
    }
}

class Register {
    private var currentReceipt = Receipt()
    private var pricingScheme: PricingScheme?

    init(pricingScheme: PricingScheme? = nil) {
        self.pricingScheme = pricingScheme
    }

    func scan(_ item: SKU) {
        currentReceipt.addItem(item)
    }

    func subtotal() -> Int {
        guard let pricingScheme = pricingScheme else {
            return currentReceipt.itemsList().reduce(0) { $0 + $1.price() }
        }
        return pricingScheme.apply(items: currentReceipt.itemsList())
    }

    func total() -> Receipt {
        let finishedReceipt = currentReceipt
        currentReceipt = Receipt() // Start a new receipt
        return finishedReceipt
    }
}

func testSingleItem() {
    let register = Register()
    let beans = Item(name: "Beans (8oz Can)", priceEach: 199)
    register.scan(beans)
    assert(register.subtotal() == 199)
    print("Subtotal after adding Beans: $\(Double(register.subtotal()) / 100.0)")
    let receipt = register.total()
    receipt.output()
}

class WeightPricedItem: SKU {
    var name: String
    private var pricePerPound: Int
    private var weight: Double

    init(name: String, pricePerPound: Int, weight: Double) {
        self.name = name
        self.pricePerPound = pricePerPound
        self.weight = weight
    }

    func price() -> Int {
        return Int(Double(pricePerPound) * weight)
    }
}

class TwoForOnePricing: PricingScheme {
    let qualifyingItemName: String
    let pricePerUnit: Int

    init(qualifyingItemName: String, pricePerUnit: Int) {
        self.qualifyingItemName = qualifyingItemName
        self.pricePerUnit = pricePerUnit
    }

    func apply(items: [SKU]) -> Int {
        let filteredItems = items.filter { $0.name == qualifyingItemName }
        let count = filteredItems.count
        let numberOfFreeItems = count / 3
        let numberOfPaidItems = count - numberOfFreeItems
        return numberOfPaidItems * pricePerUnit
    }
}

class Store {
    let version = "0.1"
    func helloWorld() -> String {
        return "Hello world"
    }
}

