//
//  ColorViewController.swift
//  ColorApp
//
//  Created by Тадевос Курдоглян on 18.12.2024.
//

import UIKit

protocol SettingsViewControllerDelegate: AnyObject {
    func updateColor(_ color: UIColor)
}

final class ColorViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let settingsVC = segue.destination as? SettingsViewController
        settingsVC?.delegate = self
        settingsVC?.color = view.backgroundColor
    }
}


extension ColorViewController: SettingsViewControllerDelegate {
    func updateColor(_ color: UIColor) {
        view.backgroundColor = color
    }
}
