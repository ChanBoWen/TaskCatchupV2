//
//  NotificationViewController.swift
//  TaskCatchupNotification
//
//  Created by Bo Wen Chan on 4/10/2026.
//

import UIKit
import UserNotifications
import UserNotificationsUI
import SwiftUI

class NotificationViewController: UIViewController, UNNotificationContentExtension {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create the SwiftUI View
        let swiftUIView = NotificationView()
        
        // Wrap it in a Hosting Controller
        let hostingController = UIHostingController(rootView: swiftUIView)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        hostingController.view.backgroundColor = .clear
        
        // Add it to the Notification window
        self.addChild(hostingController)
        self.view.addSubview(hostingController.view)
        
        // Auto Layout constraints
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: self.view.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
        
        hostingController.didMove(toParent: self)
    }
    
    func didReceive(_ notification: UNNotification) { }
}
