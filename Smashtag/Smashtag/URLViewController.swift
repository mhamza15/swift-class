//
//  URLViewController.swift
//  Smashtag
//
//  Created by Mohamed Hamza on 7/31/16.
//  Copyright © 2016 Mohamed Hamza. All rights reserved.
//

import UIKit

class URLViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView! {
        didSet {
            webView.delegate = self
            if url != nil {
                webView?.loadRequest(NSURLRequest(URL: url!))
            }
        }
    }
    
    @IBAction func refresh(sender: UIBarButtonItem) {
        webView.reload()
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        backButton.enabled = webView.canGoBack
        forwardButton.enabled = webView.canGoForward
    }
    
    @IBOutlet weak var forwardButton: UIBarButtonItem!
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    @IBAction func back(sender: UIBarButtonItem) {
        webView.goBack()
    }
    
    @IBAction func forward(sender: UIBarButtonItem) {
        webView.goForward()
    }
    var url: NSURL? {
        didSet {
            if url != nil {
                webView?.loadRequest(NSURLRequest(URL: url!))
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
