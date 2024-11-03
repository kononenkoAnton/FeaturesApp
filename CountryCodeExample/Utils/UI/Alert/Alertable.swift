//
//  Alertable.swift
//  CountryCodeExample
//
//  Created by Anton Kononenko on 11/3/24.
//

enum AlertAction {
    case ok
    case cancel
}

struct AlertData {
    let title: String
    let message: String
    let preferredStyle: UIAlertController.Style
    let okTitle: String
    let cancelTitle: String?

    init(title: String,
         message: String,
         preferredStyle: UIAlertController.Style,
         okTitle: String = "OK",
         cancelTitle: String?) {
        self.title = title
        self.message = message
        self.preferredStyle = preferredStyle
        self.okTitle = okTitle
        self.cancelTitle = cancelTitle
    }
}

import UIKit

protocol AlertableWithAsync {
    func showAlert(alertData: AlertData) async -> AlertAction
}

extension AlertableWithAsync where Self: UIViewController {
    @MainActor func showAlert(alertData: AlertData) async -> AlertAction {
        await withCheckedContinuation { continuation in
            let alertController = UIAlertController(title: alertData.title, message: alertData.message, preferredStyle: alertData.preferredStyle)

            let okAction = UIAlertAction(title: alertData.okTitle, style: .default) { _ in
                continuation.resume(returning: .ok)
            }

            alertController.addAction(okAction)

            if let cancelTitle = alertData.cancelTitle {
                let cancelAction = UIAlertAction(title: cancelTitle, style: .destructive) { _ in
                    continuation.resume(returning: .cancel)
                }

                alertController.addAction(cancelAction)
            }

            // Handle if user push outside of alert
            if alertData.preferredStyle == .alert {
                alertController.addAction(UIAlertAction(title: "Dismiss", style: .cancel) { _ in
                    continuation.resume(returning: .cancel)
                })
            }

            self.present(alertController,
                         animated: true,
                         completion: nil)
        }
    }
}

protocol AlertableWithCompletion {
    func showAlert(title: String, message: String, preferredStyle: UIAlertController.Style, completion: (AlertAction) -> Void)
}
