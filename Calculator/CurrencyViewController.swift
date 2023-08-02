//
//  CurrencyViewController.swift
//  Calculator
//
//  Created by Jeanine Chuang on 2023/8/1.
//

import UIKit

class CurrencyViewController: UIViewController {

    //接收前一頁的資料
    let selectedCurrency:String
    let currentCurrencyBox:Int
    init?(coder:NSCoder, currency:String, box:Int){
        self.selectedCurrency = currency
        self.currentCurrencyBox = box
        super.init(coder: coder)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //國旗按鈕
    @IBOutlet var FlagButtons: [UIButton]!{
        didSet {
            for button in FlagButtons{
                button.configurationUpdateHandler = { button in
                    button.alpha = button.isHighlighted ? 0.8 : 1
                }
            }
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //highlight
        for flag in FlagButtons {
            if flag.accessibilityIdentifier == selectedCurrency {
                flag.configuration?.background.strokeColor = HColor
                flag.configuration?.background.strokeWidth = 10
            }else{
                flag.configuration?.background.strokeColor = UIColor.lightGray
                flag.configuration?.background.strokeWidth = 1
            }
        }
    }
    
    //點選國旗按鈕
    @IBAction func selectCurrency(_ sender: UIButton) {
        if currentCurrencyBox==1 {
            CurrencyOne = sender.accessibilityIdentifier ?? "TWD"
        }else{
            CurrencyTwo = sender.accessibilityIdentifier ?? "TWD"
        }
        dismiss(animated: true, completion: nil)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
