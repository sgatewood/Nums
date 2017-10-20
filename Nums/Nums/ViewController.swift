//
//  ViewController.swift
//  Nums
//
//  Created by Sean Gatewood on 8/5/17.
//  Copyright © 2017 Gatewood Laboratories. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITextFieldDelegate {

    //----------Globals-------------------------
    var last = "none" //===================Tells which was the last box edited to update others
    var ans:Int = 0 //=====================What num you're actually working with
    var checkpoint:Int = 0 //==============Disables other box functionality in quiz mode
    var wait:Int = 0 //====================Keeps "correct!" displayed until you move on
    var question_num:String = "error" //===Displays ans in bin/dec/hex
    var answer_num:String = "error" //=====The correct answer
    var question_format:UInt32 = 0 //======Decides what you're converting from
    
    //----------Alert Box-----------------------
    let alert = UIAlertController(title:"Gurl.",message:"Check yo inputs. -___-",preferredStyle:UIAlertControllerStyle.alert)
    
    //----------Outlets------------------------------
    @IBOutlet weak var dec: UITextField!
    @IBOutlet weak var bin: UITextField!
    @IBOutlet weak var hex: UITextField!
    @IBOutlet weak var quiz: UILabel!
    @IBOutlet weak var submit: UIButton!
    @IBOutlet weak var quizButton: UIButton!
    @IBOutlet weak var decLabel: UILabel!
    @IBOutlet weak var binLabel: UILabel!
    @IBOutlet weak var hexLabel: UILabel!
    @IBOutlet weak var cheatButton: UIButton!
    @IBOutlet weak var cheat_display: UILabel!
    
    //----------If box tapped----------------------------
    @IBAction func decChanged(_ sender: Any) {
        last = "dec"
        clear_all()
        
    }
    
    @IBAction func binChanged(_ sender: Any) {
        last = "bin"
        clear_all()
    }
    
    @IBAction func hexChanged(_ sender: Any) {
        last = "hex"
        clear_all()
    }
    
    //----------If "quiz me" tapped---------------------
    @IBAction func quizMe(_ sender: Any) {
        if checkpoint == 1{
            re_enable(setting:1)
        }else{
            
        checkpoint = 1
        quizButton.setTitle("Cancel", for: .normal)
        clear_all()
        
        ans = Int(arc4random_uniform(300))
        question_format = arc4random_uniform(3) + 1
        var answer_format = arc4random_uniform(3) + 1
        while question_format == answer_format {
            answer_format = arc4random_uniform(3) + 1
        }
        
        switch answer_format{
        case 1:
            question_num = String(ans, radix: 10) + " (decimal)"
        case 2:
            question_num = String(ans, radix: 2) + " (binary)"
        case 3:
            question_num = String(ans, radix: 16) + " (hex)"
        default:
            print("error")
        }
        
        switch question_format {
        case 1:
            bin.isEnabled = false
            bin.alpha = 0
            binLabel.alpha = 0
            hex.isEnabled = false
            hex.alpha = 0
            hexLabel.alpha = 0
            quiz.text = "Convert \(question_num) to decimal!"
            answer_num = String(ans, radix: 10)
        case 2:
            dec.isEnabled = false
            dec.alpha = 0
            decLabel.alpha = 0
            hex.isEnabled = false
            hex.alpha = 0
            hexLabel.alpha = 0
            quiz.text = "Convert \(question_num) to binary!"
            answer_num = String(ans, radix: 2)
        case 3:
            dec.isEnabled = false
            dec.alpha = 0
            decLabel.alpha = 0
            bin.isEnabled = false
            bin.alpha = 0
            binLabel.alpha = 0
            quiz.text = "Convert \(question_num) to hexadecimal!"
            answer_num = String(ans, radix: 16)
        default:
            print("error")
        }
            
            cheatButton.isEnabled = true
            cheatButton.alpha = 1
            cheat_display.alpha = 1
        }
        
        
    }
    
    @IBAction func cheat_tapped(_ sender: Any) {
        if cheat_display.text == ""{
            cheat_display.text = answer_num
        }else{
            cheat_display.text = ""
        }
    }
    
    
    //----------After quiz:------------------------
    func re_enable(setting:Int = 0){
        checkpoint = 0
        quizButton.setTitle("Quiz Me", for: .normal)
        clear_all()
        
        dec.isEnabled = true
        dec.alpha = 1
        decLabel.alpha = 1
        bin.isEnabled = true
        bin.alpha = 1
        binLabel.alpha = 1
        hex.isEnabled = true
        hex.alpha = 1
        hexLabel.alpha = 1
        
        cheatButton.isEnabled = false
        cheatButton.alpha = 0
        cheat_display.text = ""
        cheat_display.alpha = 0
        
        
        if setting == 0{
            quiz.text = "Correct!"
            wait = 1
        }else{
            quiz.text = ""
        }
    }
    
    //----------After you type in a box or hit submit:------------------------
    @IBAction func submitPressed(_ sender: Any) {
        dec.resignFirstResponder()
        bin.resignFirstResponder()
        hex.resignFirstResponder()
        
        if wait == 1{
            quiz.text = "" // Clear "correct!" message
        }
        
        //---------If not in quiz mode:---------------------
        if checkpoint == 0{
            switch last {
            case "dec":
                if Int((dec.text)!) != nil {
                    ans = Int(dec.text!)!
                    bin.text = String(ans, radix: 2)
                    hex.text = String(ans, radix: 16)
                }else{
                    if dec.text != ""{
                        self.present(alert, animated:true, completion: nil)
                    }
                }
            case "bin":
                if Int((bin.text)!,radix:2) != nil {
                    ans = Int(bin.text!,radix:2)!
                    dec.text = String(ans, radix: 10)
                    hex.text = String(ans, radix: 16)
                }else{
                    if bin.text != ""{
                        self.present(alert, animated:true, completion: nil)
                    }
                }
            case "hex":
                if Int((hex.text)!,radix:16) != nil {
                    ans = Int(hex.text!,radix:16)!
                    dec.text = String(ans, radix: 10)
                    bin.text = String(ans, radix: 2)
                }else{
                    if hex.text != ""{
                        self.present(alert, animated:true, completion: nil)
                    }
                }
            default:
                print("error: no box edited yet")
            }
        
        //--------If in quiz mode:------------------
        }else{
            
            switch question_format {
            case 1:
                if dec.text == answer_num{
                    re_enable()
                }else{
                    clear_all()
                }
                
            case 2:
                if bin.text == answer_num{
                    re_enable()
                }else{
                    clear_all()
                }
            case 3:
                if hex.text == answer_num{
                    re_enable()
                }else{
                    clear_all()
                }

            default:
                print("error")
            }

        }
    }
    
    func clear_all(){
        dec.text = ""
        bin.text = ""
        hex.text = ""
    }
    
    // Hits submit if you touch anywhere
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        submitPressed(self)
    }
    
    // Hits submit if you hit Enter
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        submitPressed(self)
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dec.autocorrectionType = .no
        bin.autocorrectionType = .no
        hex.autocorrectionType = .no
        
        dec.keyboardType = UIKeyboardType.numberPad
        bin.keyboardType = UIKeyboardType.numberPad
        hex.keyboardType = UIKeyboardType.namePhonePad
        
        
        alert.addAction(UIAlertAction(title:"Try Again",style: UIAlertActionStyle.default, handler:nil))

        // Do any additional setup after loading the view, typically from a nib.
        dec.delegate = self
        bin.delegate = self
        hex.delegate = self
        
        re_enable(setting:1) // hides cheats
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

