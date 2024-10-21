//
//  ViewController.swift
//  ColorApp
//
//  Created by Тадевос Курдоглян on 16.10.2024.
//

import UIKit

final class ViewController: UIViewController {

    //MARK: - IB Outlets
    @IBOutlet var colorView: UIView!
    
    @IBOutlet var redLabel: UILabel!
    @IBOutlet var greenLabel: UILabel!
    @IBOutlet var blueLabel: UILabel!
    
    @IBOutlet var redSlider: UISlider!
    @IBOutlet var greenSlider: UISlider!
    @IBOutlet var blueSlider: UISlider!
    
    //MARK: - Private Properties
    private var redComponent: CGFloat {
        CGFloat(redSlider.value)
    }
    private var greenComponent: CGFloat {
        CGFloat(greenSlider.value)
    }
    private var blueComponent: CGFloat {
        CGFloat(blueSlider.value)
    }
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        updateColor()
        updateLabel(redLabel, from: redSlider)
        updateLabel(greenLabel, from: greenSlider)
        updateLabel(blueLabel, from: blueSlider)
    }
    
    //MARK: - IB Actions
    @IBAction func redSliderAction() {
        updateLabel(redLabel, from: redSlider)
        updateColor()
    }
    
    @IBAction func greenSliderAction() {
        updateLabel(greenLabel, from: greenSlider)
        updateColor()
    }
    
    @IBAction func blueSliderAction() {
        updateLabel(blueLabel, from: blueSlider)
        updateColor()
    }
    
    //MARK: - Private Functions
    private func updateColor() {
        colorView.backgroundColor = UIColor(
            cgColor: .init(
                red: redComponent,
                green: greenComponent,
                blue: blueComponent,
                alpha: 1
            )
        )
    }
    
    private func updateLabel(_ label: UILabel, from slider: UISlider) {
        label.text = slider.value.formatted(.number.precision(.fractionLength(2)))
    }
    
    private func setupViews() {
        colorView.layer.cornerRadius = 10
        redSlider.value = 0.05
        greenSlider.value = 0.27
        blueSlider.value = 0.49
    }
}

