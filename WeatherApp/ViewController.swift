//
//  ViewController.swift
//  WeatherApp
//
//  Created by Tanja Keune on 5/25/17.
//  Copyright © 2017 Tanja Keune. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var locationText: UITextField!
    @IBOutlet var resultLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func submitButton(_ sender: AnyObject) {
        
        let locationWeather = city(city: locationText.text!)
        if let url = URL(string: "http://www.weather-forecast.com/locations/" + locationWeather.replacingOccurrences(of: " ", with: "-") + "/forecasts/latest") {
        let request = NSMutableURLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            var message = ""
            if error != nil {
                print(error)
            } else {
                if let unwrappedData = data {
                    let dataString = NSString(data: unwrappedData, encoding: String.Encoding.utf8.rawValue)
                    var stringSeparator = "Weather Forecast Summary:</b><span class=\"read-more-small\"><span class=\"read-more-content\"> <span class=\"phrase\">"
                    if let contentArray = dataString?.components(separatedBy: stringSeparator) {
                        if contentArray.count > 1 {
                            stringSeparator = "</span>"
                            let newContentArray = contentArray[1].components(separatedBy: stringSeparator)
                            if newContentArray.count > 1 {
                                
                                message = newContentArray[0].replacingOccurrences(of: "&deg;", with: "°")
                            }
                        }
                    }
                }
                
                if message == "" {
                    message = "The weather there couldn't be found. Please try again."
                }
                DispatchQueue.main.sync(execute: {
                    self.resultLabel.text = message
                })
            }
            
            
        }
        task.resume()

        } else {
            resultLabel.text = "The weather there couldn't be found. Please try again."

        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        locationText.resignFirstResponder()
        return true
    }
    
    func city(city: String) -> String {
        var newString = ""
        var str1 = NSString(string: city).components(separatedBy: " ")
        
        for element in str1 as [String] {
            if element != "" {
                if newString == "" {
                    newString = element
                } else {
                    newString.append("-")
                    newString.append(element)
                }
            }
        }
        return newString
    }
}

