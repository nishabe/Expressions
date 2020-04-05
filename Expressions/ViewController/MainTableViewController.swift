//
//  MainTableViewController.swift
//  Expressions
//
//  Created by Aneesh Abraham on 4/3/20.
//  Copyright © 2020 qaz. All rights reserved.
//

import UIKit

protocol MainTableViewUpdateProtocol : class {
    func updateResult(_ amount:String)
    func refreshTableView()
}

class MainTableViewController: UITableViewController, UITextFieldDelegate, MainTableViewUpdateProtocol {
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var cursorView: UIView!
    @IBOutlet weak var amountTextField: UITextField!
    var isKeyboardShown = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cursorView.isHidden = true
        addGesture()
    }
    
    private func addGesture() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapOnLabelView))
        resultLabel.addGestureRecognizer(tapRecognizer)
    }
    
    @objc func didTapOnLabelView (tapGestureRecognizer: UITapGestureRecognizer) {
        self.animate(layer: resultLabel.layer)
        isKeyboardShown = true
        resultLabel.text = ""
        tableView.beginUpdates()
        tableView.endUpdates()
        self.addBlinkingAnimation(view: cursorView)
        cursorView.isHidden = false

    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.row == 4 && !isKeyboardShown) {
            return 0
        }
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "expressionView" {
            if let childViewController = segue.destination as? ExpressionViewController {
                childViewController.delegate = self
            }
        }
    }

    func updateResult(_ amount: String) {
        resultLabel.text = amount
        self.animate(layer: resultLabel.layer)
    }
    
    func refreshTableView() {
        isKeyboardShown = false
        tableView.beginUpdates()
        tableView.endUpdates()
    }
}
