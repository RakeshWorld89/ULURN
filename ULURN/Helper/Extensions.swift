//
//  Extensions.swift
//  ULURN
//
//  Created by Rakesh Chakraborty on 21/05/24.
//

import Foundation
import UIKit
import MBProgressHUD

extension UIView {
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        if #available(iOS 11.0, *) {
            clipsToBounds = true
            layer.cornerRadius = radius
            layer.maskedCorners = CACornerMask(rawValue: corners.rawValue)
        } else {
            let path = UIBezierPath(
                roundedRect: bounds,
                byRoundingCorners: corners,
                cornerRadii: CGSize(width: radius, height: radius)
            )
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            layer.mask = mask
        }
    }
}

extension String {
    func convertToDictionary() -> [String: Any]? {
        if let data = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    func convertToArray() -> [String]? {
        if let dataFromString = self.data(using: String.Encoding.utf8, allowLossyConversion: false) {
            do {
                return try JSONSerialization.jsonObject(with: dataFromString) as? [String]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    func timeAgoDisplay() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = formatter.date(from: self)!
        
        let calendar = Calendar.current
        let minuteAgo = calendar.date(byAdding: .minute, value: -1, to: Date())!
        let hourAgo = calendar.date(byAdding: .hour, value: -1, to: Date())!
        let dayAgo = calendar.date(byAdding: .day, value: -1, to: Date())!
        let weekAgo = calendar.date(byAdding: .day, value: -7, to: Date())!
        
        if minuteAgo < date {
            let diff = Calendar.current.dateComponents([.second], from: date, to: Date()).second ?? 0
            return "\(diff) s"
        } else if hourAgo < date {
            let diff = Calendar.current.dateComponents([.minute], from: date, to: Date()).minute ?? 0
            return "\(diff) m"
        } else if dayAgo < date {
            let diff = Calendar.current.dateComponents([.hour], from: date, to: Date()).hour ?? 0
            return "\(diff) h"
        } else if weekAgo < date {
            let diff = Calendar.current.dateComponents([.day], from: date, to: Date()).day ?? 0
            return "\(diff) d"
        }
        let diff = Calendar.current.dateComponents([.weekOfYear], from: date, to: Date()).weekOfYear ?? 0
        return "\(diff) w"
    }
}

extension Double {
    func secondsToVideoTime() -> String {
        let secondsAsInteger = Int(self)
        let (h,m,s) = (secondsAsInteger / 3600, (secondsAsInteger % 3600) / 60, (secondsAsInteger % 3600) % 60)
        let h_string = h < 10 ? "0\(h)" : "\(h)"
        let m_string =  m < 10 ? "0\(m)" : "\(m)"
        let s_string =  s < 10 ? "0\(s)" : "\(s)"
        
        return "\(h_string):\(m_string):\(s_string)"
    }
}

extension Date {
    /// Date to Unix timestamp.
        var unixTimestamp: Int {
            return Int(self.timeIntervalSince1970 * 1_000) // millisecond precision
        }
}

extension UIViewController {
    func showIndicator(withTitle loaderTitle: String, and loaderDescription: String) -> MBProgressHUD {
        let activityIndicator = MBProgressHUD.showAdded(to: self.view, animated: true)
        activityIndicator.label.text = loaderTitle
        activityIndicator.isUserInteractionEnabled = false
        activityIndicator.detailsLabel.text = loaderDescription
        activityIndicator.contentColor = .red
        activityIndicator.bezelView.color = UIColor(red: 247.0/255.0, green: 245.0/255.0, blue: 174.0/255.0, alpha: 1.0)
        activityIndicator.animationType = .zoomIn
        activityIndicator.show(animated: true)
        return activityIndicator
    }
}
