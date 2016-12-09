//
//  ViewController.swift
//  Authentication
//
//  Created by Akira Hayashi on 2016/12/09.
//
//  -----------------------------------------------------------------
//
//  Copyright (c) 2016 Akira Hayashi
//  This software is released under the Apache 2.0 License,
//  see LICENSE.txt for license information
//
//  -----------------------------------------------------------------
//

import Cocoa
import LocalAuthentication

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func authorize(_ sender: Any) {
        let context = LAContext()
        let reason = "管理者権限が必要なアクション"
        var error: NSError?

        // Touch IDかパスワードを使った認証が可能かどうかを調べる
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            // Touch IDを使って認証を行う
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason, reply: { (success, evaluateError) in
                // 認証後に実行される処理
                DispatchQueue.main.async {
                    if success {
                        // 認証できた
                        self.show(message: "認証成功")
                    } else {
                        if evaluateError != nil {
                            self.show(error: evaluateError! as NSError)
                        } else {
                            self.show(message: "予期しないエラーにより、認証失敗")
                        }
                    }
                }
            })
        } else {
            if error != nil {
                self.show(error: error!)
            } else {
                self.show(message: "予期しないエラーにより、確認失敗")
            }
        }
    }

    private func show(message: String) {
        let alert = NSAlert()
        alert.alertStyle = .informational
        alert.messageText = message
        alert.runModal()
    }

    private func show(error: NSError) {
        let alert = NSAlert(error: error)
        alert.runModal()
    }
}

