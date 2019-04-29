//
//  ConfirmSharingViewController.swift
//  pass-share
//
//  Created by CY on 2019/4/21.
//  Copyright © 2019 Pass Share. All rights reserved.
//

import UIKit

class ConfirmSharingViewController: UIViewController {
    var credentialID: String?
    var newAccess: Access?
    var selectedLogin: Credential?
    @IBOutlet weak var shareBtn: UIButton!
    
    override func viewDidLoad() {
        self.title = "Confirm Sharing Details"
        selectedLogin = RealmAPI.shared.readCredentialById(queryWith: credentialID!)
        self.sitename.text = selectedLogin?.sitename
        self.receiverEmail.text = newAccess?.grantToEmail
        switch newAccess?.duration {
            case 0:
                self.duration.text = "One-time Only"
            case 1:
                self.duration.text = "30 Days"
            case 2:
                self.duration.text = "No Expiration"
            case 3:
                // TODO: custom date TBD
                self.duration.text = "Custom Date"
            default:
                self.duration.text = "Custom Date"
        }
    }
    
    @IBOutlet weak var sitename: UILabel!
    @IBOutlet weak var receiverEmail: UILabel!
    @IBOutlet weak var duration: UILabel!
    @IBOutlet weak var currentPassword: UILabel!
    @IBOutlet weak var secretPhrase: UILabel!
    
    @IBAction func revealPassword(_ sender: Any) {
        if self.currentPassword.text?.contains("•") ?? false {
            self.currentPassword.text = selectedLogin?.password
            
        } else {
            self.currentPassword.text = "• • • • • • • • • • • • • • • •"
        }
    }
    
    @IBAction func revealSecretPhrase(_ sender: Any) {
        if self.secretPhrase.text?.contains("•")  ?? false {
            self.secretPhrase.text = self.newAccess?.secretPhrase
        } else {
            self.secretPhrase.text = "• • • • • • • • • •"
        }
    }
    
    @IBAction func confirmSharing(_ sender: Any) {
        RealmAPI.shared.appendAccessToCredential(for: selectedLogin!, with: newAccess!)
        RealmAPI.shared.write(data: newAccess!)
        print("Saved: Realm")
        let credentialRecord = selectedLogin!.createCKRecord()
        CloudKitAPI.shared.sync(credentialRecord)
        let accessRecord = newAccess!.createCKRecord()
        CloudKitAPI.shared.sync(accessRecord)
        print("Saved: Cloudkit")
//        self.navigationController?.popToRootViewController(animated: true)
//        self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
        dismiss(animated: true, completion: nil)
    }
}