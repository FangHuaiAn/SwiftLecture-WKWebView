//
//  ViewController.swift
//  TIWebContentDisplayer
//
//  Created by 房懷安 on 2020/5/30.
//  Copyright © 2020 房懷安. All rights reserved.
//

import UIKit
import WebKit
import SafariServices

class ViewController: UIViewController {

    //
    
    let fetures : [String] = ["WebView Load URL", "WebView Load HTML", "WebView Interaction", "SFSafariViewController"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        
    }
}

extension ViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetures.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let name = self.fetures[ indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: FeatureViewCell.identifier ) as! FeatureViewCell
        
        cell.updateContent(title: name)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0:
            self.performSegue(withIdentifier: "moveToURL", sender: self)
            break
        case 1:
            self.performSegue(withIdentifier: "moveToHTML", sender: self)
            break
        case 2:
            self.performSegue(withIdentifier: "moveToInteraction", sender: self)
            break
        case 3:
                
            let safari = SFSafariViewController( url: URL(string: "https://google.com")!)
            safari.delegate = self
            self.present(safari, animated: true, completion: nil)
            
            break
        default:
            
            break
        }
        
    }
    
}

extension ViewController : SFSafariViewControllerDelegate {
    
    func safariViewController(_ controller: SFSafariViewController, initialLoadDidRedirectTo URL: URL) {
        print("initialLoadDidRedirectTo:\( URL.absoluteString )")
    }
    
    func safariViewController(_ controller: SFSafariViewController, didCompleteInitialLoad didLoadSuccessfully: Bool) {
        print("didCompleteInitialLoad")
    }
}

