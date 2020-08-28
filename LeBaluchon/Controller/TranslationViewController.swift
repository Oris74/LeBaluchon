//
//  TranslationViewController.swift
//  LeBaluchon
//
//  Created by Laurent Debeaujon on 17/08/2020.
//  Copyright © 2020 Laurent Debeaujon. All rights reserved.
//

import UIKit

class TranslationViewController: UIViewController {
    @IBOutlet weak var sourceText: UITextView!
    @IBOutlet weak var targetText: UITextView!
    @IBOutlet weak var sourceFlag: UIImageView!
    @IBOutlet weak var targetFlag: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var sourceLanguage: String
    var targetLanguage: String
    var switchText: Bool
    
    //weak var delegate: ManageServices?
    
    @IBAction func translationButtonTapped(_ sender: Any) {
        dismissKeyboard()
        translation()
    }
    
    @IBAction func switchLanguageButtonTapped(_ sender: Any) {
        switchLanguage()
    }
    
    required init?(coder: NSCoder) {
        self.sourceLanguage = "fr"
        self.targetLanguage = "en"
        switchText = false
        
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        toggleActivityIndicator(shown: false)
        self.sourceText.delegate = self
        super.viewDidLoad()
    }
    
    func translation() {
        toggleActivityIndicator(shown: true)
        
        TranslationService.shared.getTranslation(
            text: sourceText.text, source: sourceLanguage, target: targetLanguage, callback: { (success, translation) in
                if success, let translation = translation {
                    self.update(translate: translation)
                    
                } else {
                    self.toggleActivityIndicator(shown: false)
                    self.presentAlert(message: "récupération des données impossible")
                }
        })
    }
    
    func switchLanguage() {
        switchText = !switchText
        
        let clipboardText = sourceText.text
        sourceText.text = targetText.text
        targetText.text = clipboardText
        
        switch switchText {
        case true:
            sourceFlag.image = UIImage(named: "UKFlag.png")
            targetFlag.image = UIImage(named: "FrenchFlag.png")
            sourceLanguage = "en"
            targetLanguage = "fr"
        case false:
            sourceFlag.image = UIImage(named: "FrenchFlag.png")
            targetFlag.image = UIImage(named: "UKFlag.png")
            sourceLanguage = "fr"
            targetLanguage = "en"
        }
    }
    
    private func update(translate: Translate) {
        targetText.text = translate.data.translations[0].translatedText
        self.toggleActivityIndicator(shown: false)
    }
    
    internal func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func toggleActivityIndicator(shown: Bool) {
        activityIndicator.isHidden = !shown
    }
    
    func presentAlert(message: String) {
        let alert = UIAlertController(title: "Erreur", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
