//
//  MemeEditorViewController.swift
//  MeMe1.0
//
//  Created by slchen on 2018/10/5.
//  Copyright © 2018 slchen. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var memeView: UIView!
    @IBOutlet weak var pickImageView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!

    let defaultTopText = "TOP"
    let defaultBottomText = "BOTTOM"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        topTextField.delegate = self
        bottomTextField.delegate = self

        defaultUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)

        let textAttributes: [NSAttributedString.Key : Any] =
            [ NSAttributedString.Key.strokeColor : UIColor.black,
              NSAttributedString.Key.foregroundColor : UIColor.white,
              NSAttributedString.Key.font : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
              NSAttributedString.Key.strokeWidth : -4]

        topTextField.defaultTextAttributes = textAttributes
        bottomTextField.defaultTextAttributes = textAttributes

        addKeyboardObserver()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        removeKeyboardObserver()
    }

    func pickOrTakeImage(sourceType: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController();
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        present(imagePicker, animated: true, completion: nil)
    }

    @IBAction func pickAnImage(_ sender: Any) {
        pickOrTakeImage(sourceType: .photoLibrary)
    }

    @IBAction func takeAnPicture(_ sender: Any) {
        pickOrTakeImage(sourceType: .camera)
    }

    @IBAction func shareMeme(_ sender: Any) {
        let memeImage = generateMemeImage()
        let activity = UIActivityViewController(activityItems: [memeImage], applicationActivities: nil)
        activity.completionWithItemsHandler = {
            (activity, completed, returnedItems, activityError) in
            if completed {
                // For later usage
                let memeModel = MemeModel(topText: self.topTextField.text!, bottomText: self.bottomTextField.text!, originalImage: self.pickImageView.image!, memedImage: memeImage)
            }
        }

        present(activity, animated: true, completion: nil)
    }

    @IBAction func cancelMeme(_ sender: Any) {
        defaultUI()
    }

    func generateMemeImage() -> UIImage {
        UIGraphicsBeginImageContext(memeView.bounds.size)
        memeView.drawHierarchy(in: memeView.bounds, afterScreenUpdates: true)
        let memeImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return memeImage
    }

    func defaultUI() {
        pickImageView.image = nil
        topTextField.text = defaultTopText
        topTextField.isEnabled = false
        bottomTextField.text = defaultBottomText
        bottomTextField.isEnabled = false
        shareButton.isEnabled = false
    }

    // MARK UIImagePickerControllerDelegate

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: nil)
        if let image = info[.originalImage] as? UIImage {
            pickImageView.image = image
            topTextField.isEnabled = true
            bottomTextField.isEnabled = true
            updateShareButton()
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    // MARK UITextFieldDelegate

    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.isEqual(topTextField) {
            if topTextField.text == defaultTopText {
                topTextField.text = ""
            }
        } else if textField.isEqual(bottomTextField) {
            if bottomTextField.text == defaultBottomText {
                bottomTextField.text = ""
            }
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if topTextField.text?.count == 0 {
            topTextField.text = defaultTopText
        }

        if bottomTextField.text?.count == 0 {
            bottomTextField.text = defaultBottomText
        }

        updateShareButton()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    // MARK Keyboard

    func addKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func removeKeyboardObserver() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardWillShow(_ notification: NSNotification) {
        let keyboardHeight = getKeyboardHeight(notification);
        if let textField = getFirstResponder() {
            let textFieldRect = textField.convert(textField.bounds, to: view)
            let viewRect = view.bounds
            let textFieldBottom = textFieldRect.origin.y + textFieldRect.size.height
            let keyboardTop = viewRect.size.height - keyboardHeight
            if textFieldBottom > keyboardTop {
                let offset = keyboardTop - textFieldBottom - 10
                view.frame.origin.y = offset
            }
        }
    }

    @objc func keyboardWillHide(_ notification: NSNotification) {
        view.frame.origin.y = 0
    }

    func getFirstResponder() -> UITextField? {
        if topTextField.isFirstResponder {
            return topTextField
        } else if bottomTextField.isFirstResponder {
            return bottomTextField
        }

        return nil
    }

    func getKeyboardHeight(_ notification: NSNotification) -> CGFloat {
        if let userInfo = notification.userInfo {
            if let value = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                return value.cgRectValue.height
            }
        }

        return 0
    }

    func updateShareButton() {
        if let _ = pickImageView.image {
            if topTextField.text?.count != 0 && bottomTextField.text?.count != 0 {
                shareButton.isEnabled = true
            } else {
                shareButton.isEnabled = false
            }
        } else {
            shareButton.isEnabled = false
        }
    }
    
}

