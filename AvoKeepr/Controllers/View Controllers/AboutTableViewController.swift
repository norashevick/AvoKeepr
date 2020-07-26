//
//  AboutTableViewController.swift
//  SettingsPrototype
//
//  Created by David on 3/30/20.
//  Copyright © 2020 David. All rights reserved.
//

import UIKit
import MessageUI
import StoreKit

class AboutTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath {
        case [1,0]: presentPreRateAndReviewAlert()
        tableView.deselectRow(at: indexPath, animated: true)
            
        case [1,1]: composeFeedbackEmail()
        tableView.deselectRow(at: indexPath, animated: true)
            
        case [1,2]: composeShareMessage()
        tableView.deselectRow(at: indexPath, animated: true)
            
        default:
            let _ = Date()
        }
    }
    
    func presentPreRateAndReviewAlert() {
        let preRateAndReviewAlert = UIAlertController(title: "Thank you!", message: Copy.PreRateAndReviewAlert.body, preferredStyle: .alert)
        preRateAndReviewAlert.addAction(UIAlertAction(title: "No thanks", style: .default, handler: nil))
        preRateAndReviewAlert.addAction(UIAlertAction(title: "I'll help", style: .cancel, handler: { (_) in
            self.rateApp()
        }))
        
        self.present(preRateAndReviewAlert, animated: true, completion: nil)
    }
    
    func rateApp() {
        if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()
        } else if let url = URL(string: "https://apps.apple.com/app/id/1515186481") {
            UIApplication.shared.openURL(url)
        }
    }
}

extension AboutTableViewController: MFMailComposeViewControllerDelegate {
    
    func composeFeedbackEmail() {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            showSendMailErrorAlert()
        }
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setToRecipients(["avokeepr@gmail.com"])
        mailComposerVC.setSubject("Avo Keepr app feedback")
        mailComposerVC.setMessageBody("", isHTML: false)
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertController(title: "Could Not Send Email", message: "Your device could not send e-mail. Please check e-mail configuration and internet connection and try again.", preferredStyle: .alert)
        sendMailErrorAlert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
        self.present(sendMailErrorAlert, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}

extension AboutTableViewController: MFMessageComposeViewControllerDelegate {
    
    func composeShareMessage() {
        let messageVC = MFMessageComposeViewController()
        if MFMessageComposeViewController.canSendText() {
            
            messageVC.body = "Check out this app that helps you track Avocados you buy so they don't go bad!\nhttps://apps.apple.com/app/id/1515186481";
            messageVC.messageComposeDelegate = self
            
            self.present(messageVC, animated: true, completion: nil)
            
        } else {
            showSendMessageErrorAlert()
        }
    }
    
    func showSendMessageErrorAlert() {
        let sendMailErrorAlert = UIAlertController(title: "Could Not Send Message", message: "Your device could not send a message. Please check your messages configuration or phone provider connection and try again.", preferredStyle: .alert)
        sendMailErrorAlert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
        self.present(sendMailErrorAlert, animated: true, completion: nil)
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        switch (result) {
        case .cancelled:
            dismiss(animated: true, completion: nil)
        case .failed:
            dismiss(animated: true, completion: nil)
        case .sent:
            dismiss(animated: true, completion: nil)
        default:
            break
        }
    }
}
