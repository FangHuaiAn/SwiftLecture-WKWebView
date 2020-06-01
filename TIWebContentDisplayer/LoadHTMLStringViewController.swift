//
//  LoadHTMLStringViewController.swift
//  TIWebContentDisplayer
//
//  Created by 房懷安 on 2020/5/31.
//  Copyright © 2020 房懷安. All rights reserved.
//

import UIKit
import WebKit

class LoadHTMLStringViewController: UIViewController {

    @IBOutlet weak var myWebView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let htmlPath = Bundle.main.path(forResource: "index", ofType: "html")
        let folderPath = Bundle.main.bundlePath
        let baseUrl = URL(fileURLWithPath: folderPath, isDirectory: true)
        do {
            let htmlString = try NSString(contentsOfFile: htmlPath!, encoding: String.Encoding.utf8.rawValue)
             myWebView.loadHTMLString(htmlString as String, baseURL: baseUrl)
        } catch {
            // catch error
        }
    }
}
