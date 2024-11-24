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
         preferredStyle: UIAlertController.Style = .alert,
         okTitle: String = String(localized: LocalizationStrings.alert_ok_button.rawValue),
         cancelTitle: String? = nil) {
        self.title = title
        self.message = message
        self.preferredStyle = preferredStyle
        self.okTitle = okTitle
        self.cancelTitle = cancelTitle
    }
}

import UIKit

protocol AlertableWithAsync: AlertableWithCompletion {
    func showAlert(alertData: AlertData) async -> AlertAction
}

extension AlertableWithAsync where Self: UIViewController {
    @MainActor func showAlert(alertData: AlertData) async -> AlertAction {
        await withCheckedContinuation { continuation in
            showAlert(alertData: alertData) { alertAction in
                continuation.resume(returning: alertAction)
            }
        }
    }
}

protocol AlertableWithCompletion {
    func showAlert(alertData: AlertData,
                   completion: @escaping (AlertAction) -> Void)
}

extension AlertableWithCompletion where Self: UIViewController {
    func showAlert(alertData: AlertData,
                   completion: @escaping (AlertAction) -> Void) {
        let alertController = UIAlertController(title: alertData.title,
                                                message: alertData.message,
                                                preferredStyle: alertData.preferredStyle)

        if let cancelTitle = alertData.cancelTitle {
            let cancelAction = UIAlertAction(title: cancelTitle, style: .destructive) { _ in
                completion(.cancel)
            }

            alertController.addAction(cancelAction)
        }

        let okAction = UIAlertAction(title: alertData.okTitle, style: .default) { _ in
            completion(.ok)
        }

        alertController.addAction(okAction)

        present(alertController,
                animated: true,
                completion: nil)
    }
}
