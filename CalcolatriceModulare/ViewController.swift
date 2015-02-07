//
//  ViewController.swift
//  CalcolatriceModulare
//
//  Created by Darka on 05/12/14.
//  Copyright (c) 2014 Darka. All rights reserved.
//

import UIKit
import QuartzCore

class ViewController: UIViewController {
    
    @IBOutlet weak var ModuloButton: UIButton!
    @IBOutlet weak var DeleteButton: UIButton!
    @IBOutlet weak var InverseButton: UIButton!
    @IBOutlet weak var RootLabel: UILabel!
    @IBOutlet weak var ModuloLabel: UILabel!
    
    @IBAction func ModuloPressed(sender: UIButton) {
        Core.state.moduloValue=Core.state.value0
        Core.state.value0 = 0
        updateUI()
    }
    @IBAction func DeleteButtonPressed(sender: UIButton) {
        Core.deleteClick()
        updateUI()
    }
    @IBAction func NumberInsertAction(sender: UIButton) {
        var number=sender.titleLabel?.text?
        Core.insertNumber(number!.toInt()!)
        updateUI()
    }
    
    @IBAction func OperationButtonActions(sender: UIButton) {
        //parse operation
        var operation=sender.titleLabel?.text?
        switch operation!{
            case "x":
            Core.insertOperation(StateModel.Oper.molt)
            case "-":
            Core.insertOperation(StateModel.Oper.sub)
            case "+":
            Core.insertOperation(StateModel.Oper.sum)
            case "÷":
            Core.insertOperation(StateModel.Oper.div)
            case "-1":
            Core.insertOperation(StateModel.Oper.inv)
            case "-*":
                Core.insertOperation(StateModel.Oper.opp)
            case "=":
                Core.setState(4)
        default:
            NSLog("Error in operation parsing")
        }
        updateUI()
    }
    
    var Core:CoreCalc = CoreCalc()
    
    func updateUI(){
        ModuloLabel.text=String(Core.state.moduloValue)
        RootLabel.text=Core.state.getRootViewString()
        DeleteButton.setTitle(Core.state.cancelString, forState: UIControlState.Normal)
        //Inverse button set
        InverseButton.highlighted = !Core.state.isInvertible()
        InverseButton.enabled = Core.state.isInvertible()
        //Modulo button enabled disabled
        ModuloButton.highlighted = !Core.state.moduloEnabled
        ModuloButton.enabled = Core.state.moduloEnabled
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

