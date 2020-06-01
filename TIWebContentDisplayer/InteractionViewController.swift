//
//  InteractionViewController.swift
//  TIWebContentDisplayer
//
//  Created by 房懷安 on 2020/5/31.
//  Copyright © 2020 房懷安. All rights reserved.
//

import UIKit
import WebKit

class InteractionViewController: UIViewController {

    var myWebView : WKWebView!
    @IBOutlet var webViewContainer : UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let html : String = """
            <html>
                <head>
                    <title>WebKit WKWebView</title>
                </head>
                <body>

                    <button type='button' onclick='showAlert()' text='Hi' style='width: 100%; height: 30px ;margin-top:10px'>Just Alert Hi</button><br />

                    <button type='button' onclick='showConfirm()' text='Hi' style='width: 100%; height: 30px ;margin-top:10px'>Yes or No</button><br />

                    <button onclick='showPrompt()' style='width: 100%; height: 30px ;margin-top:10px' >Prompt</button><br />
                    
                    <button type='button' onclick='callNativeApp()' text='Send Message To Native App' style='width: 100%; height: 30px ;margin-top:10px'>Send Message To Native App</button>
                    <p id='demo'></p>
                    <script>
                        function showAlert(){
                            alert('Hi 這只是簡單的 alert 功能!');
                        }

                        function showConfirm(){
                            var userAnswer = confirm('你的選擇是？')

                            if (userAnswer) {
                                alert('使用者按下確認');
                            } else {
                                alert('使用者按下取消');
                            }
                        }

                        function showPrompt() {
                            var lang = prompt('你現在用什麼程式語言', 'Swift or Kotlin');
                            if (lang != null) {
                                document.getElementById('demo').innerHTML = '我也是用' + lang;
                                return lang;
                            }
                        }

                        function getelement(){
                            var screenViewport = document.querySelector('meta[name="viewport"]').content
                            return screenViewport;
                        }
                        
                        function callNativeApp(){
                            webkit.messageHandlers.NOTE_HERE.postMessage('注意 NOTE_HERE 的位置。');
                        }
                    </script>
            </body>
        </html>
        """
        
        
        
        // 與 javascript 互動
        let contentController = WKUserContentController()
        // 調整網頁大小，適應移動裝置。
        // <meta name="viewport" content="width=device-width, initial-scale=1" />
        
        let jScript : String = """
                var meta = document.createElement('meta');
                meta.setAttribute('name', 'viewport');
                meta.setAttribute('content', 'width=device-width, initial-scale=1');
                document.getElementsByTagName('head')[0].appendChild(meta);
        """
        
        let userScript = WKUserScript(
        source: jScript,
        injectionTime: WKUserScriptInjectionTime.atDocumentEnd,
        forMainFrameOnly: true)
        
        contentController.addUserScript(userScript)
        contentController.add(self, name: "NOTE_HERE") // 注意這裡要與 javascript 內的呼叫配合
        
        // 控制偏好，注意還是有許多設定時直接放在 WKWebViewConfiguration 下。
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true

        // 設定
        let configration = WKWebViewConfiguration()
        configration.userContentController = contentController
        configration.preferences = preferences
        
        // 多媒體控制
        //configration.allowsInlineMediaPlayback = true
        //configration.allowsAirPlayForMediaPlayback = true
        //configration.allowsPictureInPictureMediaPlayback = true

        // User Agent
        //configration.applicationNameForUserAgent = ""
        
        //
        self.myWebView = WKWebView(frame: self.webViewContainer.bounds, configuration: configration)
        
        self.myWebView.uiDelegate = self
        self.myWebView.navigationDelegate = self

        
        self.webViewContainer.addSubview(myWebView)
        
        self.myWebView.loadHTMLString(html as String, baseURL: nil)
    }
}

extension InteractionViewController : WKScriptMessageHandler {
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        // 注意：javascript 本質是 dictionary 物件。會取出
        // webkit.messageHandlers.NOTE_HERE.postMessage('注意 NOTE_HERE 的位置。');
        if( message.name == "NOTE_HERE" ){
            
            let msg = message.body as? String ?? ""
            
            let alert = UIAlertController(title: "訊息", message: msg, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: NSLocalizedString("Confirm", comment: "Confirm"), style: .default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
        
    }
}

extension InteractionViewController : WKNavigationDelegate {
        
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        // 全部載入後，執行以下的 javascript
        // 注意，getelement() 是網頁內的 javascript function。取得的內容是 meta 。
        // 而 meta 是以 WKUserScript 在 atDocumentEnd 時載入。
        webView.evaluateJavaScript("getelement();", completionHandler: {
            ( any, error  )
            in
            
            if nil == error{
                
                let returnMessage : String = any as! String
                
                print("回傳訊息:\( returnMessage )")
                
            }else{
                print( error?.localizedDescription ?? "error happened")
            }
            
        })
    }
}

extension InteractionViewController : WKUIDelegate {

    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        
        let alert = UIAlertController(title: "JavaScriptAlertPanel", message: "\( message )", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Confirm", comment: "Confirm"), style: .default, handler:{
            ( act : UIAlertAction  )
            in
            
            print("Confirm pressed")
        }))
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"), style: .default, handler: {
            ( act : UIAlertAction  )
            in
            
            print("Cancel pressed")
        }))
        
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
        
        completionHandler()
        
    }

    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {

        let alert = UIAlertController(title: "自訂 title", message: message, preferredStyle: .alert)

        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Confirm", comment: "Confirm"), style: .default, handler: {
            (act : UIAlertAction)
            in
        
            completionHandler( true )
            
        }))
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"), style:  .default , handler: {
            ( act : UIAlertAction)
            in
            
            completionHandler( false )

        }))
        
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }

    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {

        var txt : UITextField?
        
        let alert = UIAlertController(title: prompt, message: NSLocalizedString("Input Text", comment: "Input Text"), preferredStyle: .alert)
        
        
        alert.addTextField(configurationHandler: {
            ( textTextField : UITextField  )
            in
            
            textTextField.text = defaultText
            txt = textTextField
        })
        
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Confirm", comment: "Confirm"), style: .default, handler: {
            (act : UIAlertAction)
            in
            
            let message =  txt?.text ?? ""
            
            print("\( message )")
            
            if let input = alert.textFields?.first?.text {
                // 注意：completionHandler 負責傳回給網頁端的訊息。所以不一定要透過 UIAlertController 詢問使用者。
                // 也可以自訂訊息。
                //completionHandler( "這會是回傳給網頁端的訊息" )
                completionHandler( input )
            }
            
        }))
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"), style:  .default , handler: {
            ( act : UIAlertAction)
            in
            
            if let input = alert.textFields?.first?.text {
                completionHandler( input )
            }

        }))
        
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
        
    }

}
