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
        
        // 取得網頁位置
        let htmlPath = Bundle.main.path(forResource: "index", ofType: "html")
        
        // 取得資源的 relative 目錄
        let folderPath = Bundle.main.bundlePath
        let baseUrl = URL(fileURLWithPath: folderPath, isDirectory: true)
        
        // 讀取 HTML 字串後，以 WKWebView 載入。
        do {
            let htmlString = try NSString(contentsOfFile: htmlPath!, encoding: String.Encoding.utf8.rawValue)
             myWebView.loadHTMLString(htmlString as String, baseURL: baseUrl)
        } catch {
            print(error.localizedDescription)
        }
    }
}
