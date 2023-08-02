//
//  ViewController.swift
//  Calculator
//
//  Created by Jeanine Chuang on 2023/7/31.
//

import UIKit
import Foundation

//全域變數
var CurrencyOne:String = "" //貨幣-1
var CurrencyTwo:String = "" //貨幣-2
let HColor:UIColor = UIColor(red: 118/255, green: 214/255, blue: 1, alpha: 0.7)
let DColor:UIColor = UIColor.clear

class ViewController: UIViewController {
    
    var ExchangeRates: [String: [String:Double]] = [
        "TWD": ["TWD":1.0, "USD":0.03224, "JPY":4.71921, "KRW":43.64906, "GBP":0.02549, "EUR":0.02954],
        "USD": ["TWD":31.02, "USD":1.0, "JPY":146.38981, "KRW":1353.99389, "GBP":0.79072, "EUR":0.9164],
        "JPY": ["TWD":0.2119, "USD":0.00683, "JPY":1.0, "KRW":9.24924, "GBP":0.0054, "EUR":0.00626],
        "KRW": ["TWD":0.02291, "USD":0.00074, "JPY":0.10812, "KRW":1.0, "GBP":0.00058, "EUR":0.00068],
        "GBP": ["TWD":39.23, "USD":1.26467, "JPY":185.1345, "KRW":1712.35268, "GBP":1.0,  "EUR":1.15894],
        "EUR": ["TWD":33.85, "USD":1.09123, "JPY":159.74516, "KRW":1477.52073, "GBP":0.86286, "EUR":1.0]
    ]
    
    let operators = ["+","-","*","/"]
    var currentNumber:String = ""   //目前輸入的數字
    var currentOperator:String = "" //目前輸入的符號
    var currentCurrencyBox:Int = 0  //目前輸入的貨幣
    var currentResult:Double = 0.0  //目前加總的結果
    var hasResult:Bool = false      //是否按過等於=

    //貨幣-1
    @IBOutlet weak var CurrencyOneView: UIView!
    @IBOutlet weak var CurrencyOneButton: UIButton!
    @IBOutlet weak var CurrencyOneLabel: UILabel!
    @IBOutlet weak var CurrencyOneNote: UILabel!
    //貨幣-2
    @IBOutlet weak var CurrencyTwoView: UIView!
    @IBOutlet weak var CurrencyTwoButton: UIButton!
    @IBOutlet weak var CurrencyTwoLabel: UILabel!
    @IBOutlet weak var CurrencyTwoNote: UILabel!
    
    //折扣、稅、小費 TextField
    @IBOutlet weak var OffTextField: UITextField!
    @IBOutlet weak var TaxTextField: UITextField!
    @IBOutlet weak var TipTextField: UITextField!
    @IBOutlet weak var OffTaxTipView: UIView!
    
    //計算機按鈕
    @IBOutlet var NumberButtons: [UIButton]!
    @IBOutlet var OperatorButtons: [UIButton]!{
        didSet {
            for button in OperatorButtons{
                button.configurationUpdateHandler = { button in
                    button.alpha = button.isHighlighted ? 0.8 : 1
                }
            }
            
        }
    }
    //折扣、稅、小費 Button
    @IBOutlet weak var OffButton: UIButton!
    @IBOutlet weak var TaxButton: UIButton!
    @IBOutlet weak var TipButton: UIButton!
    //清空 Button
    @IBOutlet weak var ClearButton: UIButton!
    //等於 Button
    @IBOutlet weak var ResultButton: UIButton!{
        didSet {
            ResultButton.configurationUpdateHandler = { ResultButton in
                ResultButton.alpha = ResultButton.isHighlighted ? 0.8 : 1
            }
        }
    }
    
    //畫面初始
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        initUI()
        
    }
    //畫面重繪 - 子畫面dismiss返回
    override func viewWillAppear(_ animated: Bool){
        initUI()
    }
    
    //畫面初始化
    @objc func initUI(){
        //貨幣-1
        setViewStyle(CurrencyOneView)
        setFlagStyle(CurrencyOneButton)
        CurrencyOne = CurrencyOne.isEmpty ? "TWD" : CurrencyOne
        CurrencyOneButton.configuration?.background.image = UIImage(named: CurrencyOne)
        
        //貨幣-2
        setViewStyle(CurrencyTwoView)
        setFlagStyle(CurrencyTwoButton)
        CurrencyTwo = CurrencyTwo.isEmpty ? "USD" : CurrencyTwo
        CurrencyTwoButton.configuration?.background.image = UIImage(named: CurrencyTwo)
        
        //折扣、稅、小費
        setViewStyle(OffTaxTipView)
        
        //計算機按鈕
        for nButton in NumberButtons{
            setButtonStyle(nButton)
        }
        for oButton in OperatorButtons{
            setButtonStyle(oButton)
        }
        setButtonStyle(ClearButton)
        setButtonStyle(ResultButton)
        setButtonStyle(OffButton)
        setButtonStyle(TaxButton)
        setButtonStyle(TipButton)
        
        //選擇輸入框 Tap
        let tapGestureRecognizerOne = UITapGestureRecognizer(target: self, action: #selector(focusCurrencyOne(_:)))
        CurrencyOneView.isUserInteractionEnabled = true
        CurrencyOneView.addGestureRecognizer(tapGestureRecognizerOne)
        let tapGestureRecognizerTwo = UITapGestureRecognizer(target: self, action: #selector(focusCurrencyTwo(_:)))
        CurrencyTwoView.isUserInteractionEnabled = true
        CurrencyTwoView.addGestureRecognizer(tapGestureRecognizerTwo)
    }
    //方框樣式
    func setViewStyle(_ view:UIView){
        //view
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.cornerRadius = 10
    }
    //國旗按鈕樣式
    func setFlagStyle(_ button:UIButton){
        //Flag Button
        button.layer.cornerRadius = 50
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        button.layer.shadowOpacity = 0.2
    }
    //計算機按鈕樣式
    func setButtonStyle(_ button:UIButton){
        button.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        button.layer.shadowOpacity = 1
        button.layer.shadowColor = UIColor.lightGray.cgColor
    }
    
    //選擇輸入框 Tap
    @objc func focusCurrencyOne(_ sender: UITapGestureRecognizer) {
        focusCurrencyBox(1)
    }
    @objc func focusCurrencyTwo(_ sender: UITapGestureRecognizer) {
        focusCurrencyBox(2)
    }
    
    //選擇輸入框 func
    func focusCurrencyBox(_ boxIndex:Int){
        CurrencyOneView.backgroundColor = boxIndex==1 ? HColor : DColor
        CurrencyTwoView.backgroundColor = boxIndex==2 ? HColor : DColor
        currentCurrencyBox = boxIndex
        clearData()
    }
    
    //呼叫選擇貨幣Currency View Controller
    //傳入目前選擇的貨幣-1
    @IBSegueAction func changeCurrencyOne(_ coder: NSCoder, sender: Any?, segueIdentifier: String?) -> CurrencyViewController? {
        CurrencyViewController(coder: coder, currency: CurrencyOne, box: 1)
    }
    
    //傳入目前選擇的貨幣-2
    @IBSegueAction func changeCurrencyTwo(_ coder: NSCoder, sender: Any?, segueIdentifier: String?) -> CurrencyViewController? {
        CurrencyViewController(coder: coder, currency: CurrencyTwo, box: 2)
    }
    
    //按空白處收鍵盤
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
            view.endEditing(true)
    }
    
    //輸入數字
    @IBAction func pressNumber(_ sender: UIButton) {
        //先選擇貨幣
        if currentCurrencyBox<1 {
            currencyNotSelectAlert()
            return
        }
        let number = NumberButtons.firstIndex(of: sender)!
        //尚未輸入數字或目前為0，不動作
        if currentNumber=="" && number==0 {
            return
        }
        
        //小數點
        let numberText = number==10 ? "." : String(number)
        
        //輸入框
        updateCurrencyBoxNumber(numberText)
    
    }
    //更新輸入框內容 - 數字
    func updateCurrencyBoxNumber(_ numberText:String){
        
        var label:UILabel = CurrencyOneLabel
        var note:UILabel = CurrencyOneNote
        if currentCurrencyBox==2 {
            label = CurrencyTwoLabel
            note = CurrencyTwoNote
        }
        
        if hasResult {
            label.text = ""
            note.text = ""
            hasResult = false
        }
        
        note.text?.append(numberText)
        currentNumber.append( numberText )
        label.text = currentNumber
        
    }
    
    //輸入符號
    @IBAction func pressOperator(_ sender: UIButton) {
        //先選擇貨幣
        if currentCurrencyBox<1 {
            currencyNotSelectAlert()
            return
        }
        //尚未輸入數字，不動作
        if currentNumber=="" {
            return
        }
        //處理符號
        let op = operators[OperatorButtons.firstIndex(of: sender)!]
        currentOperator = op
        
        //輸入框
        updateCurrencyBoxOperator(op)
    }
    //更新輸入框內容 - 符號
    func updateCurrencyBoxOperator(_ op:String){
        var note:UILabel = CurrencyOneNote
        if currentCurrencyBox==2 {
            note = CurrencyTwoNote
        }
        
        //若有計算結果，結果的數字當作下一個運算式的第一個數字
        if hasResult {
            note.text = currentNumber
            hasResult = false
        }
        note.text?.append(op)
        currentNumber = ""
    }
    
    //清空
    @IBAction func clearAll(_ sender: Any) {
        clearData()
    }
    //清除畫面上數字和算式
    func clearData(){
        currentNumber = ""
        CurrencyOneLabel.text = "0.00"
        CurrencyOneNote.text = ""
        CurrencyTwoLabel.text = "0.00"
        CurrencyTwoNote.text = ""
    }
    
    //計算結果
    @IBAction func getResult(_ sender: Any) {
        //輸入框
        var label:UILabel = CurrencyOneLabel
        var note:UILabel = CurrencyOneNote
        if currentCurrencyBox==2 {
            label = CurrencyTwoLabel
            note = CurrencyTwoNote
        }
        if note.text=="" {
            return
        }
        //顯示結果
        currentResult = calculateAndUpdateUI(label:label, note:note)
    }
    //計算並顯示結果
    func calculateAndUpdateUI(label:UILabel, note:UILabel) -> Double{
        var resultDouble:Double = 0.00
        if let result:Double = calculateExpression(note.text ?? ""){
            label.text = String(result)
            currentNumber = String(result)
            hasResult = true
            currencyExchange()
            resultDouble = result
        }
        return resultDouble
    }
    
    //計算折扣 - OFF
    @IBAction func getOff(_ sender: Any) {
        if OffTextField.text=="" || currentResult==0.00 {
            return
        }
        
        //輸入框
        var label:UILabel = CurrencyOneLabel
        var note:UILabel = CurrencyOneNote
        if currentCurrencyBox==2 {
            label = CurrencyTwoLabel
            note = CurrencyTwoNote
        }
        
        //計算省下多少
        if let offRate:Double = Double(OffTextField.text ?? "0.00") {
            note.text?.append("-"+String(format: "%.2f", currentResult * offRate / 100))
            //顯示結果
            currentResult = calculateAndUpdateUI(label:label, note:note)
        }
    }
    
    
    //計算稅 - TAX
    @IBAction func getTax(_ sender: Any) {
        if TaxTextField.text=="" || currentResult==0.00 {
            return
        }
        
        //輸入框
        var label:UILabel = CurrencyOneLabel
        var note:UILabel = CurrencyOneNote
        if currentCurrencyBox==2 {
            label = CurrencyTwoLabel
            note = CurrencyTwoNote
        }
        
        //計算加多少稅
        if let taxRate:Double = Double(TaxTextField.text ?? "0.00") {
            note.text?.append("+"+String(format: "%.2f", currentResult * taxRate / 100))
            //顯示結果
            let result = calculateAndUpdateUI(label:label, note:note)
        }
    }
    
    //計算小費 - TIP
    @IBAction func getTip(_ sender: Any) {
        if TipTextField.text=="" || currentResult==0.00 {
            return
        }
        
        //輸入框
        var label:UILabel = CurrencyOneLabel
        var note:UILabel = CurrencyOneNote
        if currentCurrencyBox==2 {
            label = CurrencyTwoLabel
            note = CurrencyTwoNote
        }
        
        //計算給多少小費
        if let tipRate:Double = Double(TipTextField.text ?? "0.00") {
            note.text?.append("+"+String(format: "%.2f", currentResult * tipRate / 100))
            //顯示結果
            let result = calculateAndUpdateUI(label:label, note:note)
        }
    }
    
    //換匯
    func currencyExchange() {
        var originalCurrency:String = ""
        var exchangeCurrency:String = ""
        var originalNumber:String = ""
        var exchangeLabel:UILabel?
        
        if currentCurrencyBox==1 {
            originalCurrency = CurrencyOne
            exchangeCurrency = CurrencyTwo
            originalNumber = CurrencyOneLabel.text ?? "0.00"
            exchangeLabel = CurrencyTwoLabel
        }else{
            originalCurrency = CurrencyTwo
            exchangeCurrency = CurrencyOne
            originalNumber = CurrencyTwoLabel.text ?? "0.00"
            exchangeLabel = CurrencyOneLabel
        }
        
        if let exchangeRates = ExchangeRates[originalCurrency], let exchangeRate = exchangeRates[exchangeCurrency],
           let doubleNumber:Double = Double(originalNumber) {
            exchangeLabel?.text = String(format: "%.2f", doubleNumber*exchangeRate)
        }
    }
    
    // 計算給定數學運算式的結果
    func calculateExpression(_ expression: String) -> Double? {
        let cleanedExpression = expression.replacingOccurrences(of: " ", with: "") // 移除所有空格

        // 透過正則表達式來將運算符號與數字分開
        let pattern = #"(\d+(\.\d+)?)|([+\-*/])"#
        let regex = try! NSRegularExpression(pattern: pattern, options: [])
        let matches = regex.matches(in: cleanedExpression, options: [], range: NSRange(location: 0, length: cleanedExpression.utf16.count))

        // 將匹配到的token依序加入到tokens陣列中
        var tokens: [String] = []
        for match in matches {
            if let range = Range(match.range, in: cleanedExpression) {
                tokens.append(String(cleanedExpression[range]))
            }
        }

        // 建立兩個Stack，一個用來存放數字，一個用來存放運算符號
        var numbersStack: [Double] = []
        var operatorsStack: [String] = []

        // 定義優先順序字典，指定運算符號的優先順序
        let precedence: [String: Int] = ["+": 1, "-": 1, "*": 2, "/": 2]

        // 處理token陣列，計算運算式的結果
        for token in tokens {
            if let number = Double(token) {
                // 如果是數字，直接加入數字Stack
                numbersStack.append(number)
            } else if token == "(" {
                // 如果是左括號，將其加入運算符號Stack
                operatorsStack.append(token)
            } else if token == ")" {
                // 如果是右括號，處理括號內的運算，直到左括號
                while !operatorsStack.isEmpty && operatorsStack.last != "(" { //當符號stack有值 & 前一個符號不是 ( 時
                    if let operatorToken = operatorsStack.popLast(),  //取出上一個符號
                       let b = numbersStack.popLast(),   //取出前一個數值
                       let a = numbersStack.popLast() {  //取出前前一個數值
                            let result = calculate(a, b, operatorToken) //將括號內從右邊開始的一組運算式，計算出結果
                            numbersStack.append(result)  //將結果存入數值stack
                    }
                }
                // 移除左括號
                operatorsStack.popLast()
                
            } else if let tokenPrecedence = precedence[token] { //如果在優先順序字典可以取得1或2，代表此token是符號
                // 如果是運算符號，處理運算符號的優先順序
                while !operatorsStack.isEmpty, //當符號stack有值
                      let lastOperator = operatorsStack.last, //前一個符號
                      let lastOperatorPrecedence = precedence[lastOperator], //前一個符號的優先順序 1或2
                      tokenPrecedence <= lastOperatorPrecedence { //當目前符號的優先順序 小於 前一個符號
                                                                  //就先處理上一個符號的運算式
                        if let b = numbersStack.popLast(),  //取出前一個數值
                           let a = numbersStack.popLast() { //取出前前一個數值
                                let operatorToken = operatorsStack.popLast()    //取出上一個符號
                                if let operatorToken = operatorToken {          //上一個符號取出無誤
                                    let result = calculate(a, b, operatorToken) //將該組運算式，計算出結果
                                    numbersStack.append(result)                 //將結果存入數值stack
                                }
                        }
                }
                // 將目前運算符號加入運算符號Stack
                operatorsStack.append(token)
            }
        }

        // 處理剩餘的運算符號（優先的乘和除應該都處理完畢，剩下的是加或減）
        while !operatorsStack.isEmpty {
            if let b = numbersStack.popLast(),  //取出前一個數值
               let a = numbersStack.popLast() { //取出前前一個數值
                    let operatorToken = operatorsStack.popLast()    //取出上一個符號
                    if let operatorToken = operatorToken {          //上一個符號取出無誤
                        let result = calculate(a, b, operatorToken) //將該組運算式，計算出結果
                        numbersStack.append(result)                 //將結果存入數值stack
                    }
            }
        }

        return numbersStack.last // 回傳最終結果
    }

    // 計算兩數之間的運算結果
    func calculate(_ a: Double, _ b: Double, _ operatorToken: String) -> Double {
        switch operatorToken {
        case "+":
            return a + b
        case "-":
            return a - b
        case "*":
            return a * b
        case "/":
            return a / b
        default:
            fatalError("Unknown operator: \(operatorToken)")
        }
    }

    //訊息 - 檢查是否選擇輸入框
    func currencyNotSelectAlert() {
        let alertController = UIAlertController(title: "請先選擇貨幣", message: "", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        present(alertController, animated: true)
    }

    
}

