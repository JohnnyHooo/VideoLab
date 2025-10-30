//
//  HUD.swift
//  VideoLab_Example
//
//  Created by Assistant on 2025/10/29.
//  Copyright © 2025 Chocolate. All rights reserved.
//

import UIKit

// MARK: - HUD Content Type
enum HUDContentType {
    case label(String)
}

// MARK: - HUD Class
class HUD {
    
    // MARK: - Singleton
    static let shared = HUD()
    private init() {}
    
    // MARK: - Properties
    private var hudView: UIView?
    private var backgroundView: UIView?
    private var hideTimer: Timer?
    
    // MARK: - Public Methods
    static func show(_ content: HUDContentType, onView view: UIView? = nil) {
        shared.showHUD(content, onView: view)
    }
    
    static func hide(animated: Bool = true, completion: ((Bool) -> Void)? = nil) {
        shared.hideHUD(animated: animated, completion: completion)
    }
    
    static func hide(afterDelay delay: TimeInterval, completion: ((Bool) -> Void)? = nil) {
        shared.hideTimer?.invalidate()
        shared.hideTimer = Timer.scheduledTimer(withTimeInterval: delay, repeats: false) { _ in
            shared.hideHUD(animated: true, completion: completion)
        }
    }
    
    // MARK: - Private Methods
    private func showHUD(_ content: HUDContentType, onView view: UIView?) {
        DispatchQueue.main.async {
            self.hideHUD(animated: false)
            
            let targetView = view ?? self.topViewController()?.view ?? UIApplication.shared.windows.first
            guard let containerView = targetView else { return }
            
            // 创建背景视图
            let background = UIView()
            background.backgroundColor = UIColor.black.withAlphaComponent(0.3)
            background.frame = containerView.bounds
            background.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            containerView.addSubview(background)
            self.backgroundView = background
            
            // 创建HUD容器
            let hudContainer = self.createHUDContainer(for: content)
            background.addSubview(hudContainer)
            self.hudView = hudContainer
            
            // 居中约束
            hudContainer.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                hudContainer.centerXAnchor.constraint(equalTo: background.centerXAnchor),
                hudContainer.centerYAnchor.constraint(equalTo: background.centerYAnchor)
            ])
            
            // 动画显示
            hudContainer.alpha = 0
            hudContainer.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseOut) {
                hudContainer.alpha = 1
                hudContainer.transform = .identity
            }
        }
    }
    
    private func hideHUD(animated: Bool, completion: ((Bool) -> Void)? = nil) {
        DispatchQueue.main.async {
            self.hideTimer?.invalidate()
            self.hideTimer = nil
            
            guard let background = self.backgroundView else {
                completion?(true)
                return
            }
            
            if animated {
                UIView.animate(withDuration: 0.25, animations: {
                    background.alpha = 0
                    self.hudView?.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                }) { finished in
                    background.removeFromSuperview()
                    self.backgroundView = nil
                    self.hudView = nil
                    completion?(finished)
                }
            } else {
                background.removeFromSuperview()
                self.backgroundView = nil
                self.hudView = nil
                completion?(true)
            }
        }
    }
    
    private func createHUDContainer(for content: HUDContentType) -> UIView {
        let container = UIView()
        container.backgroundColor = UIColor.systemBackground
        container.layer.cornerRadius = 12
        container.layer.shadowColor = UIColor.black.cgColor
        container.layer.shadowOffset = CGSize(width: 0, height: 2)
        container.layer.shadowRadius = 8
        container.layer.shadowOpacity = 0.1
        
        switch content {
        case .label(let text):
            let label = UILabel()
            label.text = text
            label.textColor = UIColor.label
            label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
            label.textAlignment = .center
            label.numberOfLines = 0
            
            container.addSubview(label)
            label.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                label.topAnchor.constraint(equalTo: container.topAnchor, constant: 20),
                label.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -20),
                label.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 24),
                label.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -24),
                container.widthAnchor.constraint(greaterThanOrEqualToConstant: 120),
                container.widthAnchor.constraint(lessThanOrEqualToConstant: 280)
            ])
        }
        
        return container
    }
    
    private func topViewController() -> UIViewController? {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            return nil
        }
        
        var topController = window.rootViewController
        while let presentedController = topController?.presentedViewController {
            topController = presentedController
        }
        return topController
    }
}
