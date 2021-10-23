//
//  ViewController.swift
//  CurrencyExchangeApp
//
//  Created by Stella on 10/19/21.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    
    @IBOutlet weak var fromPickerView: UIPickerView!
    
    @IBOutlet weak var toPickerView: UIPickerView!
    
    
    @IBOutlet weak var fromTxtField: UITextField!
    
    @IBOutlet weak var toLabel: UILabel!
    
    var fromCurrency = "USD"
    var toCurrency = "USD"
    
    let currency = ["USD", "CNY", "CAD", "AUD", "EUR"]
    
    let url = "https://api.exchangeratesapi.io/v1/latest"
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currency.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currency[row]
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case fromPickerView:
            fromCurrency = currency[row]
        case toPickerView:
            toCurrency = currency[row]
        default:
            break
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        fromTxtField.delegate = self
        fromPickerView.dataSource = self
        fromPickerView.delegate = self
        toPickerView.dataSource = self
        toPickerView.delegate = self
        
    }
    
    
    @IBAction func getExchangeRate(_ sender: Any) {
        
        let amount = Double(fromTxtField.text!)
        
        let apiKey = Bundle.main.infoDictionary?["API_KEY"] as!String

        let url = "http://api.exchangeratesapi.io/v1/latest?access_key=" + apiKey + "&symbols=" + fromCurrency + "," + toCurrency;
        
        Alamofire.request(url).responseJSON { response in
            let currencyData = JSON(response.data!)
            let fromCurrencyRate = currencyData["rates"][self.fromCurrency].doubleValue
            let toCurrencyRate = currencyData["rates"][self.toCurrency].doubleValue
            let toAmount = String(format: "%.2f", (toCurrencyRate/fromCurrencyRate)*amount!)
            self.toLabel.text = "\(toAmount)"
        }
    }
    
}

