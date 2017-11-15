//
//  GameModal.swift
//  hw8
//
//  Created by BruceLee on 2017/11/15.
//  Copyright © 2017年 BruceLee. All rights reserved.
//

import GameplayKit
import Foundation

class Player{
    var DiceList = Array<Int>(repeating:0,count:6)
    var Dice1:Int=0,Dice2:Int=0
    init(){
        DiceList=generateDiceList()
    }
    func generateDiceList()->Array<Int>{
        let randomDice = GKRandomDistribution(lowestValue: 1, highestValue: 6)
        var diceList=Array<Int>(repeating:0,count:6)
        for i in 0...diceList.count-1{
            diceList[i]=randomDice.nextInt()
        }
        diceList.sort(by: <)
        return diceList
    }
}

class Com:Player{
    var face:String="", name:String=""
    override init(){
        super.init()
        let temp=generateComFaceAndName()
        face=temp.face
        name=temp.name
    }
    func generateComFaceAndName()->(face:String,name:String){
        let randomCom = GKRandomDistribution(lowestValue: 1, highestValue: 3)
        let randomComResult:Int=randomCom.nextInt()
        var randomComName:String=""
        switch randomComResult {
            case 1:randomComName="賭神"
            case 2:randomComName="賭俠"
            case 3:randomComName="賭聖"
            default:break
        }
        print("generateComFaceAndName")
        return ("com\(randomComResult)",randomComName)
    }
}


class GameModal{
    var player = Player()
    var com = Com()
    var totalDiceList = Array<Int>(repeating:0,count:6)
    var callHistory = Array(repeating:Array<String>(repeating:"",count:3),count:0)
    var oneCalled:Bool=false
    var gameResultDetail:String=""
    var gameResult:String=""
    var isGameFinal:Bool=false
    
    
    public func resetGame(){
        player = Player()
        com = Com()
        callHistory = Array(repeating:Array<String>(repeating:"",count:3),count:0)
        oneCalled=false
        totalDiceList = Array<Int>(repeating:0,count:6)

        print("comDiceList:\(com.DiceList)")
        print("playerDiceList:\(player.DiceList)")
        
    }
    func appendCallHistory(_ caller:String,_ dice1:Int, _ dice2:Int){
        print("\(caller)叫牌：\(dice1)個\(dice2)")
        callHistory.append([caller,String(dice1),String(dice2)])
        isOneCalled(dice2)
        if caller=="player"{
            player.Dice1=dice1
            player.Dice2=dice2
        }
        if caller=="com"{
            com.Dice1=dice1
            com.Dice2=dice2
        }
        
    }
    func isOneCalled(_ dice2:Int){
        if dice2==1 {oneCalled=true}
    }
    
    func comCall()->(comDice1:Int,comDice2:Int){
        let randomComDice1 = GKRandomDistribution(lowestValue: self.player.Dice1, highestValue:min(self.player.Dice1+2,7))
        let randomComDice2 = GKRandomDistribution(lowestValue: 1, highestValue: 6)
        self.com.Dice1=randomComDice1.nextInt()
        self.com.Dice2=randomComDice2.nextInt()
        while self.com.Dice1<=self.player.Dice1 && self.com.Dice2<=self.player.Dice2{
            self.com.Dice1=randomComDice1.nextInt()
            self.com.Dice2=randomComDice2.nextInt()
        }
        return (self.com.Dice1,self.com.Dice2)
    }
    func isComCallBluff()-> Bool {
        var isComCallBluff:Bool=false
        var comHas:Int=0
        var comHas0:Int=0
        for i in 0...5{
            if self.com.DiceList[i]==self.player.Dice2{
                comHas+=1
            }
            if self.com.DiceList[i]==1{
                comHas0+=1
            }
        }
        if oneCalled && self.player.Dice1-comHas>=3{
            isComCallBluff=true
        }
        if !oneCalled && self.player.Dice1-comHas-comHas0>=3{
            isComCallBluff=true
        }
        return isComCallBluff
    }
    func getCallHistory()->String{
        var content:String=""
        if isGameFinal{
            for i in 0...callHistory.count-1{
                if i==callHistory.count-1{
                    content+="\(callHistory[i][0])\t叫開牌"
                }else{
                    content+="\(callHistory[i][0])\t叫\t\(callHistory[i][1])個\(callHistory[i][2])\n"
                }
            }
        }else{
            for i in 0...callHistory.count-1{
                content+="\(callHistory[i][0])\t叫\t\(callHistory[i][1])個\(callHistory[i][2])\n"
            }
        }
        return content
    }
    

    public func showGameResult(_ whoCalled:String) {
        isGameFinal=true
        //計算骰子加總
        for i in 0...player.DiceList.count-1{
            for j in 1...player.DiceList.count{
                if player.DiceList[i]==j{totalDiceList[j-1]+=1}
                if com.DiceList[i]==j{totalDiceList[j-1]+=1}
            }
        }
        print("totalDiceList:\(totalDiceList)")
        
        //計算gameResultDetail
        for i in 0...5{
            if i<5{gameResultDetail+="\(totalDiceList[i])\t個\t\(i+1)\n"
            }else{gameResultDetail+="\(totalDiceList[i])\t個\t\(i+1)"
            }
        }
        
        if whoCalled == "player"{
            print("玩家叫開牌")
            if oneCalled{
                if com.Dice1<=totalDiceList[com.Dice2-1]{
                    gameResult="\(com.name)獲勝"
                }else{
                    gameResult="玩家獲勝"
                }
            }else{
                if com.Dice1<=totalDiceList[com.Dice2-1]+totalDiceList[0]{
                    gameResult="\(com.name)獲勝"
                }else{
                    gameResult="玩家獲勝"
                }
            }
        } else if whoCalled == "com"{
            print("\(com.name)叫開牌")
  
            if oneCalled{
                if player.Dice1<=totalDiceList[player.Dice2-1]{
                    gameResult="玩家獲勝"
                }else{
                    gameResult="\(com.name)獲勝"
                }
            }else{
                if player.Dice1<=totalDiceList[player.Dice2-1]+totalDiceList[0]{
                    gameResult="玩家獲勝"
                }else{
                    gameResult="\(com.name)獲勝"
                }
            }
        }
        print(gameResult)
    }
}
