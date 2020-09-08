//
//  TranslationViewController.swift
//  LeBaluchon
//
//  Created by Laurent Debeaujon on 17/08/2020.
//  Copyright © 2020 Laurent Debeaujon. All rights reserved.
//

import UIKit

class TranslationViewController: UIViewController, VCUtilities {
    @IBOutlet weak var sourceText: UITextView!
    @IBOutlet weak var targetText: UITextView!
    @IBOutlet weak var sourceFlag: UIImageView!
    @IBOutlet weak var targetFlag: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    var sourceLanguage: String
    var targetLanguage: String
    var switchText: Bool

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
            text: sourceText.text,
            source: sourceLanguage,
            target: targetLanguage,
            callback: { (errorCode, translation) in

                if errorCode == .none, let translation = translation {
                    self.update(translate: translation)
                } else {
                    self.toggleActivityIndicator(shown: false)
                    self.manageErrors(errorCode: errorCode)
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

    private func toggleActivityIndicator(shown: Bool) {
        activityIndicator.isHidden = !shown
    }
}
