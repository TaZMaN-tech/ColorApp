//
//  ViewController.swift
//  ColorApp
//
//  Created by Тадевос Курдоглян on 16.10.2024.
//

import UIKit

final class SettingsViewController: UIViewController {
    
    //MARK: - IB Outlets
    @IBOutlet var colorView: UIView!
    
    @IBOutlet var redLabel: UILabel!
    @IBOutlet var greenLabel: UILabel!
    @IBOutlet var blueLabel: UILabel!
    
    @IBOutlet var redSlider: UISlider!
    @IBOutlet var greenSlider: UISlider!
    @IBOutlet var blueSlider: UISlider!
    
    @IBOutlet var redTextField: UITextField!
    @IBOutlet var greenTextField: UITextField!
    @IBOutlet var blueTextField: UITextField!
    
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

    //MARK: - Weak properties
    weak var delegate: SettingsViewControllerDelegate?
    
    //MARK: - Public Properties
    var color: UIColor!
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        redTextField.delegate = self
        greenTextField.delegate = self
        blueTextField.delegate = self
        
        redTextField.addDoneToolbar()
        greenTextField.addDoneToolbar()
        blueTextField.addDoneToolbar()
        
        colorView.backgroundColor = color
        colorView.layer.cornerRadius = 10
        setupSliders()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    //MARK: - IB Actions
    @IBAction func sliderAction(_ sender: UISlider) {
        updateColor()
        
        switch sender {
        case redSlider:
            updateLabelAndTextField(redLabel, redTextField, from: redSlider)
        case greenSlider:
            updateLabelAndTextField(greenLabel, greenTextField, from: greenSlider)
        default:
            updateLabelAndTextField(blueLabel, blueTextField, from: blueSlider)
        }
    }
    
    @IBAction func doneButtonAction() {
        delegate?.updateColor(colorView.backgroundColor ?? .white)
        dismiss(animated: true)
    }
    
    //MARK: - Private Functions
    private func updateColor() {
        colorView.backgroundColor = UIColor(
            red: redComponent,
            green: greenComponent,
            blue: blueComponent,
            alpha: 1
        )
    }
    
    private func updateLabelAndTextField(
        _ label: UILabel,
        _ textField: UITextField,
        from slider: UISlider
    ) {
        label.text = String(
            format: "%.2f",
            slider.value
        )
        textField.text = label.text
    }
    
    private func setupSliders() {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        guard let color = colorView.backgroundColor else { return }
        if color.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            redSlider.value = Float(red)
            greenSlider.value = Float(green)
            blueSlider.value = Float(blue)
            
            updateLabelAndTextField(redLabel, redTextField, from: redSlider)
            updateLabelAndTextField(greenLabel, greenTextField, from: greenSlider)
            updateLabelAndTextField(blueLabel, blueTextField, from: blueSlider)
        } else {
            print("Не удалось извлечь компоненты из UIColor")
        }
    }
    
    private func updateSlider(for textField: UITextField, with value: Float) {
        switch textField {
        case redTextField:
            redLabel.text = String(format: "%.2f", value)
            redSlider.setValue(value, animated: true)
        case greenTextField:
            greenLabel.text = String(format: "%.2f", value)
            greenSlider.setValue(value, animated: true)
        default:
            blueLabel.text = String(format: "%.2f", value)
            blueSlider.setValue(value, animated: true)
        }
    }
    
    private func showInvalidFormatAlert(for textField: UITextField) {
            let alert = UIAlertController(
                title: "Неверный формат",
                message: "Пожалуйста, введите число от 0.0 до 1.0.",
                preferredStyle: .alert
            )
            let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                textField.becomeFirstResponder()
            }
            alert.addAction(okAction)
            present(alert, animated: true)
        }
}

//MARK: UITextFieldDelegate
extension SettingsViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text, text.floatValue >= 0 && text.floatValue <= 1 else {
            showInvalidFormatAlert(for: textField)
            textField.text = "0.0"
            updateSlider(for: textField, with: 0.0)
            return
        }
        updateSlider(for: textField, with: text.floatValue)
    }
}

//MARK: UITextFieldExtension
extension UITextField {
    func addDoneToolbar() {
        let toolbar = UIToolbar()
        toolbar
            .sizeToFit()
        
        let doneButton = UIBarButtonItem(
            title: "Done",
            style: .done,
            target: self,
            action: #selector(
                resignFirstResponder
            )
        )
        let flexibleSpace = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil
        )
        toolbar
            .setItems(
                [
                    flexibleSpace,
                    doneButton
                ],
                animated: false
            )

        self.inputAccessoryView = toolbar
    }
}

//MARK: StringExtension
extension String {
    static let numberFormatter = NumberFormatter()
    var floatValue: Float {
        String.numberFormatter.decimalSeparator = "."
        if let result =  String.numberFormatter.number(from: self) {
            return result.floatValue
        } else {
            String.numberFormatter.decimalSeparator = ","
            if let result = String.numberFormatter.number(from: self) {
                return result.floatValue
            }
        }
        return 0
    }
}

