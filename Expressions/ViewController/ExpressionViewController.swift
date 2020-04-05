//
//  ExpressionViewController.swift
//  Expressions
//
//  Created by Aneesh Abraham on 4/3/20.
//  Copyright © 2020 qaz. All rights reserved.
//

import UIKit

class ExpressionViewController: UIViewController {
    
    var expressionCollection = [String]()
    var partialExpression = ""
    let speechBubbleUniCode = "\u{1F4AC}"
    
    @IBOutlet weak var expressionLabel: UILabel!
    weak var delegate: MainTableViewUpdateProtocol? = nil
    
    @IBAction func didTap(_ sender: UIButton) {
        self.animate(layer: sender.layer)
        let keyText = sender.titleLabel?.text
        switch keyText {
        case "0","1","2","3","4","5","6","7","8","9",".":
            processKey(keyText: keyText, operation: nil)
            break
        case "<--":
            NSLog("")
            break
        case "/","*","-","+":
            processKey(keyText: nil, operation: keyText)
            break
        case "AC":
            expressionLabel.text = ""
            expressionCollection.removeAll()
            break
        default:
            break
        }
    }
    
    @IBAction func didTapOnDoneButton(_ sender: UIButton) {
        refreshMainView()
    }
    
    func processKey(keyText: String? , operation: String?) {
        if let keyText = keyText {
            // Continue appending to the last expression in collection in the sequence of input
            if isLastElementAnOperator() {
                expressionCollection.append(keyText)
            } else if var lastPartialExpression = expressionCollection.last {
                 lastPartialExpression = lastPartialExpression + keyText
                expressionCollection.removeLast()
                expressionCollection.append(lastPartialExpression)
            }
            else if (partialExpression.count >= 0) {
                // partialExpression is not yet added to collection. So append it.
                partialExpression = partialExpression + keyText
            }
                // Add to the collection of last element in the collection is an operator
            else if (isLastElementAnOperator()) {
                expressionCollection.append(keyText)
            }
        }
        
        if let operation = operation {
            if (!isFirstElementAnOperator()) { // Add to expression collection only if there is alredy a non-operator present
                // If the last element in the collection is already an operation, replace it with the latest operation
                if(isLastElementAnOperator()) {
                    expressionCollection.removeLast()
                }
                expressionCollection.append(partialExpression)
                expressionCollection.append(operation)
                partialExpression = "" // Reset
            }
        }
        // One of two operands is missing in this scenario
        if expressionCollection.count <= 2 {
            var addedExpression = ""
            for element in expressionCollection {
                addedExpression = addedExpression + " \(element)"
            }
            // Show a thought bubble if the last element in expression collection is an operator
            if isLastElementAnOperator() {
                addedExpression = addedExpression + " \(speechBubbleUniCode)"
            }
            // No mathematical evaluation needed
            expressionLabel.text = addedExpression + partialExpression
        } else {
            evaluateExpression()
        }
    }
    
    private func evaluateExpression() {
        var addedExpression = ""
        for element in getNormalizedExpressionCollection() {
            addedExpression = addedExpression + element
        }
        if let result = getFinalResult(cumulativeExpression: addedExpression) {
            var addedExpressionForReadablilty = ""
            for (element) in expressionCollection {
                addedExpressionForReadablilty = addedExpressionForReadablilty + " \(element)"
            }
            // Show a thought bubble if the last element in expression collection is an operator
            if isLastElementAnOperator() {
                addedExpressionForReadablilty = addedExpressionForReadablilty + " \(speechBubbleUniCode)"
            }
            expressionLabel.text = "\(addedExpressionForReadablilty) \(partialExpression) = \(result)"
            updateMainView(result)
        }
        
    }
    
    private func updateMainView (_ result: String) {
        if let delegate = delegate {
            delegate.updateResult(result)
        }
    }
    
    private func refreshMainView () {
        if let delegate = delegate {
            delegate.refreshTableView()
        }
    }
    
    private func getNormalizedExpressionCollection() -> [String] {
        var normalizedExpression = [String]()
        normalizedExpression.append(contentsOf: expressionCollection)
        
        switch normalizedExpression.last {
        case "+", "-":
            normalizedExpression.append("0")
            break
        case "*", "/":
            normalizedExpression.append("1")
            break
        default:
            print("")
        }
        return normalizedExpression
    }
    
    private func getFinalResult(cumulativeExpression: String) -> String? {
        var evaluatedValue = ""
        let expression = NSExpression(format: cumulativeExpression)
        guard let mathValue = expression.expressionValue(with: nil, context: nil) as? Double else {
            return nil
        }
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        guard let value = formatter.string(from: NSNumber(value: mathValue)) else { return nil }
        evaluatedValue = value
        
        return evaluatedValue
    }
    
    private func isLastElementAnOperator() ->Bool {
        var isLastElementAnOperator = false
        if (expressionCollection.last == "+" ||
            expressionCollection.last == "-" ||
            expressionCollection.last == "/" ||
            expressionCollection.last == "*") {
            isLastElementAnOperator = true
        }
        return isLastElementAnOperator
    }
    
    private func isFirstElementAnOperator() -> Bool {
        var isfirstElementAnOperator = false
        if (expressionCollection.first == "+" ||
            expressionCollection.first == "-" ||
            expressionCollection.first == "/" ||
            expressionCollection.first == "*") {
            isfirstElementAnOperator = true
        }
        return isfirstElementAnOperator
    }
}
