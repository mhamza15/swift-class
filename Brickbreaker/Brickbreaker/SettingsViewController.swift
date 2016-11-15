//
//  SettingsViewController.swift
//  Brickbreaker
//
//  Created by Mohamed Hamza on 8/19/16.
//  Copyright © 2016 Mohamed Hamza. All rights reserved.
//

import UIKit

protocol SettingsProtocol {}

class SettingsViewController: UIViewController {
    
    private var userSettings: [String : Int] {
        get {
            return (NSUserDefaults.standardUserDefaults().objectForKey("brickBreakerSettings") as? [String : Int])!
        } set {
            NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: "brickBreakerSettings")
        }
    }
    
    private func valueForSetting(setting: String) -> Int {
        let defaultValues = ["lives" : 3,
                            "bricksPerRow" : 5,
                            "rows" : 4,
                            "ballColor" : 0]
        return NSUserDefaults.standardUserDefaults().dictionaryForKey("brickBreakerSettings")?[setting] as? Int ?? defaultValues[setting]!
    }
    
    private func setValueForSetting(setting: String, value: Int) {
        var settings = NSUserDefaults.standardUserDefaults().dictionaryForKey("brickBreakerSettings") ?? [String:Int]()
        settings[setting] = value
        NSUserDefaults.standardUserDefaults().setObject(settings, forKey: "brickBreakerSettings")
    }
    
    private var colors = [UIColor.darkGrayColor(), UIColor.orangeColor(), UIColor.purpleColor()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        livesSlider.value = Float((valueForSetting("lives")))
        livesLabel.text = "\(Int(round(livesSlider.value)))"
        bricksPerRowSlider.value = Float((valueForSetting("bricksPerRow")))
        bricksPerRowLabel.text = "\(Int(round(bricksPerRowSlider.value)))"
        rowsSlider.value = Float((valueForSetting("rows")))
        rowsLabel.text = "\(Int(round(rowsSlider.value)))"
        ballColorControl.selectedSegmentIndex = valueForSetting("ballColor")
    }

    @IBAction func livesSliderChanged(sender: AnyObject) {
        livesSlider.value = round(livesSlider.value)
        livesLabel.text = "\(Int(livesSlider.value))"
    }
    
    @IBAction func bricksPerRowSliderChanged(sender: AnyObject) {
        bricksPerRowSlider.value = round(bricksPerRowSlider.value)
        bricksPerRowLabel.text = "\(Int(bricksPerRowSlider.value))"
    }
    
    @IBAction func rowsSliderChanged(sender: AnyObject) {
        rowsSlider.value = round(rowsSlider.value)
        rowsLabel.text = "\(Int(rowsSlider.value))"
    }

    @IBAction func save(sender: UIButton) {
        setValueForSetting("lives", value: Int(livesSlider.value))
        setValueForSetting("rows", value: Int(rowsSlider.value))
        setValueForSetting("bricksPerRow", value: Int(bricksPerRowSlider.value))
        setValueForSetting("ballColor", value: ballColorControl.selectedSegmentIndex)
    }
    
    @IBAction func ballColor(sender: UISegmentedControl) {
    }

    @IBOutlet weak var livesSlider: UISlider!
    
    @IBOutlet weak var livesLabel: UILabel!

    @IBOutlet weak var bricksPerRowSlider: UISlider!
    
    @IBOutlet weak var bricksPerRowLabel: UILabel!
    
    @IBOutlet weak var rowsSlider: UISlider!
    
    @IBOutlet weak var rowsLabel: UILabel!

    @IBOutlet weak var ballColorControl: UISegmentedControl!
    
}
