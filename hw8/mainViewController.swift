//
//  mainViewController.swift
//  hw8
//
//  Created by BruceLee on 2017/11/11.
//  Copyright © 2017年 BruceLee. All rights reserved.
//

//modal class
//1. 初始化雙方骰子
//2. 玩家叫牌
//3. 玩家抓
//4. 重置
//5. 作弊


import UIKit
import GameplayKit
import Foundation

class Game{
    var comFace:String="", comName:String=""
    var comDiceList = Array<Int>(repeating:0,count:6)
    var playerDiceList = Array<Int>(repeating:0,count:6)
    var totalDiceList = Array<Int>(repeating:0,count:6)
    var playerDice1:Int=0,playerDice2:Int=0
    var comDice1:Int=0,comDice2:Int=0
    
    var callHistory = Array(repeating:Array<String>(repeating:"",count:3),count:0)
    var oneCalled:Bool=false
    var gameResultDetail:String=""
    var gameResult:String=""
    var cheatOn:Bool=false

    

    public func reset(){
        callHistory = Array(repeating:Array<String>(repeating:"",count:3),count:0)
        playerDice1=0
        playerDice2=0
        comDice1=0
        comDice2=0
        oneCalled=false
        playerDiceList = Array<Int>(repeating:0,count:6)
        comDiceList = Array<Int>(repeating:0,count:6)
        totalDiceList = Array<Int>(repeating:0,count:6)
    }

    public func initGame(){
        let randomComFace = GKRandomDistribution(lowestValue: 1, highestValue: 3)
        let randomComFaceResult:Int=randomComFace.nextInt()
        comFace="com\(randomComFaceResult)"
        switch randomComFaceResult {
            case 1:comName="賭神"
            case 2:comName="賭俠"
            case 3:comName="賭聖"
            default:break
        }

        let randomDice = GKRandomDistribution(lowestValue: 1, highestValue: 6)
        for i in 0...5{
            comDiceList[i]=randomDice.nextInt()
            playerDiceList[i]=randomDice.nextInt()
        }
        comDiceList.sort(by: <)
        
        playerDiceList.sort(by: <)
        
        
        print("comDiceList:\(comDiceList)")
        print("playerDiceList:\(playerDiceList)")
//        return(comFace,comName,comDiceList,playerDiceList)
    }
    public func playerCall(_ playerDice1_para:Int, _ playerDice2_para:Int){
        
        playerDice1 = playerDice1_para
        playerDice2 = playerDice2_para
        print("playerCall:\(playerDice1)個\(playerDice2)")
        callHistory.append(["Player",String(playerDice1),String(playerDice2)])
        if playerDice2_para==1 {oneCalled=true}
        comCall()
    }
    private func comCall(){
        let randomComDice1 = GKRandomDistribution(lowestValue: playerDice1, highestValue:min(playerDice1+2,7))
        let randomComDice2 = GKRandomDistribution(lowestValue: 1, highestValue: 6)
        var comCallBluff:Bool=false
        comDice1=randomComDice1.nextInt()
        comDice2=randomComDice2.nextInt()
        var comHas:Int=0
        var comHas0:Int=0
        for i in 0...5{
            if comDiceList[i]==playerDice2{
                comHas+=1
            }
            if comDiceList[i]==1{
                comHas0+=1
            }
        }
        if oneCalled && playerDice1-comHas>=3{comCallBluff=true}
        if !oneCalled && playerDice1-comHas-comHas0>=3{comCallBluff=true}
        if comCallBluff{showGameResult("com")}
        else{
            while comDice1<=playerDice1 && comDice2<=playerDice2{
                comDice1=randomComDice1.nextInt()
                comDice2=randomComDice2.nextInt()
            }
            callHistory.append([comName,String(comDice1),String(comDice2)])
            print("comCall:\(comDice1)個\(comDice2)")
            if comDice2==1{oneCalled=true}
        }
    }
    
    public func printCallHistory()->String{
        var content:String=""
        for j in 0...callHistory.count-1{
            if callHistory[j][1]==""{
                content+="回合\(j+1)：\(callHistory[j][0])\t叫\(callHistory[j][2])\n"
            }else{
                content+="回合\(j+1)：\(callHistory[j][0])\t叫\(callHistory[j][1])個\(callHistory[j][2])\n"
            }
        }
        return content
    }
    
    public func showGameResult(_ whoCalled:String) {
        //計算骰子加總
        for i in 0...5{
            for j in 1...6{
                if playerDiceList[i]==j{totalDiceList[j-1]+=1}
                if comDiceList[i]==j{totalDiceList[j-1]+=1}
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
            callHistory.append(["玩家","","開牌"])
            if oneCalled{
                if comDice1<=totalDiceList[comDice2-1]{
                    gameResult="\(comName)獲勝"
                }else{
                    gameResult="玩家獲勝"
                }
            }else{
                if comDice1<=totalDiceList[comDice2-1]+totalDiceList[0]{
                    gameResult="\(comName)獲勝"
                }else{
                    gameResult="玩家獲勝"
                }
            }
        } else if whoCalled == "com"{
            print("\(comName)叫開牌")
            callHistory.append([comName,"","開牌"])
            if oneCalled{
                if playerDice1<=totalDiceList[playerDice2-1]{
                    gameResult="玩家獲勝"
                }else{
                    gameResult="\(comName)獲勝"
                }
            }else{
                if playerDice1<=totalDiceList[playerDice2-1]+totalDiceList[0]{
                    gameResult="玩家獲勝"
                }else{
                    gameResult="\(comName)獲勝"
                }
            }
        }
        print(gameResult)
    }
}
    


class mainViewController: UIViewController{
    let newGame = Game()
    override func viewDidLoad() {
        super.viewDidLoad()
        newGame.initGame()
        comFace.image=UIImage(named:"\(newGame.comFace)")
        comName.text=newGame.comName
        d1.image=UIImage(named:"\(newGame.playerDiceList[0])")
        d2.image=UIImage(named:"\(newGame.playerDiceList[1])")
        d3.image=UIImage(named:"\(newGame.playerDiceList[2])")
        d4.image=UIImage(named:"\(newGame.playerDiceList[3])")
        d5.image=UIImage(named:"\(newGame.playerDiceList[4])")
        d6.image=UIImage(named:"\(newGame.playerDiceList[5])")
        cd1.image=UIImage(named:"\(newGame.comDiceList[0])")
        cd2.image=UIImage(named:"\(newGame.comDiceList[1])")
        cd3.image=UIImage(named:"\(newGame.comDiceList[2])")
        cd4.image=UIImage(named:"\(newGame.comDiceList[3])")
        cd5.image=UIImage(named:"\(newGame.comDiceList[4])")
        cd6.image=UIImage(named:"\(newGame.comDiceList[5])")
    }
    
    @IBOutlet weak var comFace: UIImageView!
    @IBOutlet weak var comName: UILabel!
    
    
    @IBOutlet weak var d1: UIImageView!
    @IBOutlet weak var d2: UIImageView!
    @IBOutlet weak var d3: UIImageView!
    @IBOutlet weak var d4: UIImageView!
    @IBOutlet weak var d5: UIImageView!
    @IBOutlet weak var d6: UIImageView!
    
    
    @IBOutlet weak var cd1: UIImageView!
    @IBOutlet weak var cd2: UIImageView!
    @IBOutlet weak var cd3: UIImageView!
    @IBOutlet weak var cd4: UIImageView!
    @IBOutlet weak var cd5: UIImageView!
    @IBOutlet weak var cd6: UIImageView!
    
    @IBOutlet weak var slider1: UISlider!
    @IBOutlet weak var slider2: UISlider!
    @IBOutlet weak var playerCall: UILabel!
    
    @IBOutlet weak var showHistory: UILabel!
    @IBOutlet weak var gameResult: UILabel!
    @IBOutlet weak var gameResultDetail: UILabel!
    
    @IBOutlet weak var gameResultTitle: UILabel!
    @IBOutlet weak var playerCallBluff: UIButton!
    @IBOutlet weak var reset: UIButton!
    

    @IBAction func reset(_ sender: Any) {
        newGame.reset()
    }
//    func initLabelHidden(){
//        gameResult.isHidden=true
//        gameResultDetail.isHidden=true
//        showHistory.isHidden=true
//        gameResultTitle.isHidden=true
//        playerCall.isHidden=true
////        hideComDiceList(true)
//    }
    
    @IBAction func playerCall(_ sender: Any) {
        newGame.playerCall(Int(round(slider1.value)), Int(round(slider2.value)))
        showHistory.text=newGame.printCallHistory()
        showHistory.isHidden=false
    }
    @IBAction func playerCallBluff(_ sender: Any) {
        showHistory.isHidden=false
        gameResultTitle.isHidden=false
        newGame.showGameResult("player")
        gameResultDetail.text=newGame.gameResultDetail
        gameResult.text=newGame.gameResult
        showHistory.text=newGame.printCallHistory()
    }

    @IBAction func sliderChg(_ sender: UISlider) {
        playerCall.text="\(Int(round(slider1.value)))個\(Int(round(slider2.value)))"
        playerCall.isHidden=false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

//    func hideComDiceList(_ isShow:Bool){
//        cd1.isHidden=isShow
//        cd2.isHidden=isShow
//        cd3.isHidden=isShow
//        cd4.isHidden=isShow
//        cd5.isHidden=isShow
//        cd6.isHidden=isShow
//    }
    
//    @IBAction func showComDice(_ sender: Any) {
//        if cheatOn == false{
//            cheatOn=true
//            hideComDiceList(false)
//        }else{
//            cheatOn=false
//            hideComDiceList(true)
//        }
//
    

}
