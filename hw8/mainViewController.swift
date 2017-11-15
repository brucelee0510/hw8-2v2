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



class mainViewController: UIViewController{
    let game = GameModal()
    override func viewDidLoad() {
        super.viewDidLoad()
        game.resetGame()
        resetScreen()
    }
    func resetScreen(){
        gameResult.isHidden=true
        gameResultTitle.isHidden=true
        gameResultDetail.isHidden=true
        
        for i in playerDiceList{
            i.image=UIImage(named:"\(game.player.DiceList[i.tag])")
        }
        for i in comDiceList{
            i.image=UIImage(named:"\(game.com.DiceList[i.tag])")
        }
        
        comFace.image=UIImage(named:"\(game.com.face)")
        comName.text=game.com.name
    }
    
    @IBOutlet weak var comFace: UIImageView!
    @IBOutlet weak var comName: UILabel!
    
    @IBOutlet var playerDiceList: [UIImageView]!
    @IBOutlet var comDiceList: [UIImageView]!
    
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
    
    @IBOutlet weak var callHistory: UILabel!
    @IBOutlet weak var gameResult: UILabel!
    @IBOutlet weak var gameResultDetail: UILabel!
    
    @IBOutlet weak var gameResultTitle: UILabel!
    @IBOutlet weak var playerCallBluff: UIButton!
    @IBOutlet weak var reset: UIButton!
    

    @IBAction func reset(_ sender: Any) {
        game.resetGame()
        resetScreen()
    }

    
    @IBAction func playerCall(_ sender: Any) {
        
        game.appendCallHistory("player", Int(round(slider1.value)), Int(round(slider2.value)))
        if game.isComCallBluff(){       //電腦叫抓
            game.appendCallHistory("com", 0, 0)
            game.showGameResult("com")
            viewShowGameResult()
        }else{                          //電腦叫牌
            let temp=game.comCall()
            game.appendCallHistory("com", temp.comDice1, temp.comDice2)
        }
        callHistory.text=game.getCallHistory()
    }
    
    @IBAction func playerCallBluff(_ sender: Any) {
        game.appendCallHistory("player", 0, 0)  //玩家叫開牌
        game.showGameResult("player")
        viewShowGameResult()
    }
    func viewShowGameResult(){
        gameResultDetail.text=game.gameResultDetail
        gameResult.text=game.gameResult
        
        print("executed")
        print("\(game.getCallHistory())")
        callHistory.text=game.getCallHistory()
    }

    @IBAction func sliderChg(_ sender: UISlider) {
        playerCall.text="\(Int(round(slider1.value)))個\(Int(round(slider2.value)))"
        playerCall.isHidden=false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }



}
