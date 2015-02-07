//
//  StateModel.swift
//  CalcolatriceModulare
//
//  Created by Darka on 06/12/14.
//  Copyright (c) 2014 Darka. All rights reserved.
//

import Foundation

class StateModel{
    
    var id:Int = 0
    
    var value0:Int = 0
    
    var value1:Int = 0
    
    var moduloEnabled:Bool = true
    
    var cancelString:String = "AC"
    
    var moduloValue:Int = 0;
    
    var operation: Oper = Oper.none
    
    enum Oper{
        case sum
        case sub
        case molt
        case div
        case inv
        case opp
        case none
    }
    
    func getRootViewString()->String{
        return String(value0)
    }
    
    func isInvertible()->Bool{
        if(value0 != 0 && moduloValue != 0 && isPrime(moduloValue)){
            return true
        }
        return false
    }
    private func isPrime(num:Int)->Bool{
        if(num >= 4){
        var fin:Int = Int(floor( sqrt(Double(num))))
        for var i:Int = 2 ; i<fin ; ++i {
            if(num % i == 0){
                return false
            }
        }
        }
        return true
    }
}

class CoreCalc{
    let MAXNUMBER:Int = 11
    var state:StateModel;
    
    //Init with state 0
    init(){
        state = StateModel()
    }
    
    func initState(){
        state.id = 0
        state.operation = StateModel.Oper.none
        state.value0 = 0
        state.value1 = 0
        state.moduloEnabled = true
        state.cancelString = "AC"
    }
    
    func setState(index:Int){
        switch index{
            case 0:
                initState()
            case 1:
                state.id = 1
                state.value0 = 0
                state.value1 = 0
                state.moduloEnabled = true
                state.cancelString = "C"
            case 2:
                state.id = 2
                state.value1 = state.value0
                state.moduloEnabled = false
                state.cancelString = "C"
            case 3:
                state.id = 3
                state.moduloEnabled = false
                state.cancelString = "C"
            //if press equal
            case 4:
                state.id = 4
                doCalc()
                state.value1=0
                state.operation = StateModel.Oper.none
                state.moduloEnabled = false
                state.cancelString = "C"
            //if don't press equal
        case 6:
            state.id = 6
            doCalc()
            state.value1=state.value0
            state.moduloEnabled = false
            state.cancelString = "C"
        case 5:
            state.id=5
            state.value0 = 0
            state.cancelString = "CA"
            
            default:
                initState()
        }
    }
    
    func deleteClick(){
        switch state.id{
        case 0,1,4,5:
            setState(0)
        case 2,3:
            setState(5)
        default:
            NSLog("Error on delete click")
        }
    }
    
    func insertNumber(number:Int){
        switch state.id{
        case 0,4:
            setState(1)
            addNumber(number)
        case 2:
            setState(3)
            state.value0 = 0
            addNumber(number)
        case 5:
            setState(3)
            addNumber(number)
        default:
            addNumber(number)
        }
    }
    
    func insertOperation(operation:StateModel.Oper){
        if(operation == StateModel.Oper.inv){
            state.value0 = getInverse(state.value0)
            state.operation = StateModel.Oper.none
        }
        else if (operation == StateModel.Oper.opp){
            if(state.moduloValue != 0){
                state.value0 =  state.moduloValue - state.value0 % state.moduloValue
            }
            else
            {
                state.value0 = -state.value0;
            }
            state.operation = StateModel.Oper.none
        }
        else
        {
        switch state.id{
        case 0,1,4:
            setState(2)
            state.operation = operation
        case 3:
            setState(6)
            state.operation = operation
            setState(2)
        default:
            state.operation = operation
            }}

    }
    
    func addNumber(number:Int){
        if(state.getRootViewString().utf16Count<MAXNUMBER){
            state.value0 = state.value0*10+number;
        }
    }
    
    func doCalc()
    {
        var result:Int = 0;
        switch state.operation{
            case StateModel.Oper.div:
                result = state.value1 * getInverse(state.value0)
            case StateModel.Oper.molt:
                result = state.value0 * state.value1
            case StateModel.Oper.sub:
                result = subTrate(state.value1, b: state.value0)
            case StateModel.Oper.sum:
                result = state.value0 + state.value1
            case StateModel.Oper.none:
                result = state.value0 + state.value1
        default:
            state.value0 = 0
        }
        if(state.moduloValue != 0){
            state.value0 = result % state.moduloValue
        }
        else
        {
            state.value0 = result;
        }
    }
    
    func getInverse(num:Int)->Int{
        if(state.moduloValue != 0 && state.moduloValue != 1){
        for i in 2...(state.moduloValue-1){
            if(i*num % state.moduloValue == 1)
            {return i}
        }
        }
        var alert:U
        return 1
    }
    
    func subTrate(a:Int,b:Int)->Int{
        if(state.moduloValue != 0){
            return (a + state.moduloValue - b % state.moduloValue) % state.moduloValue
        }
        return a-b
    }
}