//
//  LoadURLViewController.swift
//  TIWebContentDisplayer
//
//  Created by 房懷安 on 2020/5/31.
//  Copyright © 2020 房懷安. All rights reserved.
//

import UIKit
import WebKit

class LoadURLViewController: UIViewController {

    @IBOutlet weak var myWebView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.myWebView.navigationDelegate = self
        self.myWebView.load(URLRequest(url: URL(string: "https://developer.apple.com")!))
    }
}

extension LoadURLViewController : WKNavigationDelegate {
    
    // when content starts arriving for the main frame.
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print("didCommit")
    }
    
    // when a main frame navigation completes.
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("didFinish")
    }
}
