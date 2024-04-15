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
        outputString += "TOTAL: $\(String(format: "%.2f", Double(items.reduce(0) { $0 + $1.price() }) / 100))\n"
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

    func scan(_ item: SKU) {
        currentReceipt.addItem(item)
    }
    func subtotal() -> Int {
        return currentReceipt.itemsList().reduce(0) { $0 + $1.price() }
    }
    func total() -> Receipt {
        let finishedReceipt = currentReceipt
        currentReceipt = Receipt()
        return finishedReceipt
    }
}

func testAddingSingleItem() {
    let register = Register()
    let beans = Item(name: "Beans (8oz Can)", priceEach: 199)
    register.scan(beans)
    assert(register.subtotal() == 199)
    print("Subtotal after adding Beans: $\(Double(register.subtotal()) / 100.0)")
    let receipt = register.total()
    receipt.output()
}

class Store {
    let version = "0.1"
    func helloWorld() -> String {
        return "Hello world"
    }
}

