//
//  EventInformationWebViewController.swift
//  SingleViewAppSwiftTemplate
//
//  Created by Bharath Chandrashekar on 01/01/19.
//  Copyright © 2019 Treehouse. All rights reserved.
//

import UIKit
import WebKit

class EventInformationWebViewController: UIViewController {
    
    @IBOutlet var closeWebViewButton: UIButton!
    @IBOutlet var closeWebViewImageView: UIImageView!

    var webView: WKWebView!
    var eventInformationURLString: String = ""
    
    
    init(withEventInformationURLString urlString: String) {
        eventInformationURLString = urlString
        super.init(nibName: "EventInformationWebViewController", bundle: Bundle.main)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebView()
        loadContent()
    }
    
    
   func loadContent() {
        
        let eventURL:URL? = URL(string: eventInformationURLString)
        if let eventURL = eventURL {
            let urlRequest: URLRequest = URLRequest(url: eventURL)
            webView.load(urlRequest)
        }
    }
    
    
    @IBAction func closeWebViewButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    deinit {
        closeWebViewButton = nil
        closeWebViewImageView = nil
        webView = nil
    }
}



extension EventInformationWebViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        addActivityIndicatorView()
    }
    
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        removeActivityIndicatorView()
    }
}



extension EventInformationWebViewController {
    
    //WKWebView getting added through code and not through XIB.
    //Reason: https://stackoverflow.com/questions/46221577/xcode-9-gm-wkwebview-nscoding-support-was-broken-in-previous-versions
    
    func setupWebView() {
        
        webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)
        webView.navigationDelegate = self
        webView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        webView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        webView.topAnchor.constraint(equalTo: closeWebViewImageView.bottomAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    
    func addActivityIndicatorView() {
        
        if webView.viewWithTag(10) == nil {
            
            let activityView: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
            activityView.startAnimating()
            activityView.tag = 10
            activityView.translatesAutoresizingMaskIntoConstraints = false
            webView.addSubview(activityView)
            activityView.centerXAnchor.constraint(equalTo: webView.centerXAnchor).isActive = true
            activityView.centerYAnchor.constraint(equalTo: webView.centerYAnchor).isActive = true
        }
    }
    
    
    func removeActivityIndicatorView() {
        webView.viewWithTag(10)?.removeFromSuperview()
    }
    
}
