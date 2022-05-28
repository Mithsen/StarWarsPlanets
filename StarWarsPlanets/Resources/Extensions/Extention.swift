//
//  Extention2.swift
//  SyscoAssignment
//
//  Created by Mithsen on 2022-05-28.
//

import UIKit.UIImage
import UIKit.UIImageView

extension UIImageView {
  func imageFromServerURL(urlString: String) {
    guard let url = URL(string: urlString) else { return }
    URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
      guard error == nil else {
        return
      }
      guard let data = data else { return }
      DispatchQueue.main.async {
        self?.image = UIImage(data: data)
      }
    }.resume()
  }
}

var SpinnerView : UIView?
extension UIView {
    func showSpinner() {
        let spinnerView = UIView.init(frame: self.bounds)
        spinnerView.backgroundColor = .clear
        let ai = UIActivityIndicatorView.init(style: .medium)
        ai.startAnimating()
        ai.center = spinnerView.center
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            self.addSubview(spinnerView)
        }
        SpinnerView = spinnerView
    }
    
    func removeSpinner() {
        DispatchQueue.main.async {
            SpinnerView?.removeFromSuperview()
            SpinnerView = nil
        }
    }
}

