//
//  WebViewController.swift
//  HW39WKWebView
//
//  Created by Сергей on 15.04.2020.
//  Copyright © 2020 Sergei. All rights reserved.
//

/*
 Даже не знаю какое дать вам задание по этому уроку. Это не настолько критический элемент, он не так часто встречается в приложениях, а если действительно нужен, то там как правило и javascript и все такое. Так что даже не знаю что вам дать :)

 Задание следующее:

 1. Сделайте один контроллер с таблицей, в ней две секции: pdf и url
 2. Присоедините к проекту парочку pdf файлов, их имена должны быть в таблице
 3. Добавьте парочку web сайтов во вторую секцию
 4. Когда я нажимаю на ячейку, то через пуш навигейшн должен отобразиться либо пдф либо web
 5. Надеюсь понятно что для загрузки того либо другого мы используем один и тот же контроллев с UIWebView и иницианизируем его нужным NSURL
 6. На веб вью должна быть крутилка, а в навигейшине кнопки назад и вперед

 такое вот задание :)
 */

import UIKit
import WebKit


class WebViewController: UIViewController {

    //MARK: - Properties
    
   lazy var webView: WKWebView = {
        let configuration = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: configuration)
        return webView
    }()
    
   private lazy var toolbar: UIToolbar = {
        let bounds = UIScreen.main.bounds
        let toolbar = UIToolbar(frame: CGRect(x: bounds.minX, y: bounds.maxY - 40,
                                              width: bounds.width, height: 40))
    toolbar.backgroundColor = .orange
        return toolbar
    }()
    
    private lazy var refreshButton: UIBarButtonItem = {
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh,
                                         target: self, action: #selector(refresh(sender:)))
        return refresh
    }()
    
    private lazy var forwardButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .fastForward,
                                     target: self, action: #selector(goForward(sender:)))
        return button
    }()
    
    private lazy var backButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .rewind,
                                     target: self, action: #selector(goBack(sender:)))
        return button
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let bounds = UIScreen.main.bounds
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .blue
        return activityIndicator
    }()
    
    //MARK: Life Circle
    
    override func loadView() {
        super.loadView()
        
        webView.navigationDelegate = self
        view = webView
        toolbarSetup()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(activityIndicator)
        
    }
    
    //MARK: - Actions
    
    @objc private func goForward(sender: UIBarButtonItem) {
            webView.goForward()
    }
    
    @objc private func goBack(sender: UIBarButtonItem) {
            webView.goBack()
    }
    
    @objc private func refresh(sender: UIBarButtonItem) {
        webView.stopLoading()
        webView.reload()
    }

    
    
    
    // MARK: - Help Functions
    
    private func webViewbCanGoOrNot() {
        backButton.isEnabled = webView.canGoBack
        forwardButton.isEnabled = webView.canGoForward
    }
    
    private func toolbarSetup() {
        
        let fixedSpace = UIBarButtonItem(barButtonSystemItem: .fixedSpace,
                                         target: nil, action: nil)
        fixedSpace.width = 20
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                            target: nil, action: nil)
        webViewbCanGoOrNot()
        toolbar.items = [backButton, fixedSpace, forwardButton, flexibleSpace, refreshButton]
        view.addSubview(toolbar)
        
    }

}

//MARK: - Extensions



//MARK: - WKNavigationDelegate

extension WebViewController: WKNavigationDelegate{
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        webViewbCanGoOrNot()
        activityIndicator.startAnimating()
    
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        webViewbCanGoOrNot()
        activityIndicator.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webViewbCanGoOrNot()
        
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        webView.stopLoading()
        print(error.localizedDescription)
    }
    
}

extension WebViewController: WebTableViewControllerDelegate {
    
    func send(requestType: TypeRequest, pathsStrings: [String], indexPath: IndexPath) {
        
        guard !pathsStrings.isEmpty else { return }
        
        switch requestType {
            case .web:
                
                let webStr = pathsStrings[indexPath.row]
                
                guard let webUrl = URL(string: webStr) else { return }
            
                let urlRequest = URLRequest(url: webUrl)
                
                webView.load(urlRequest)
            
            case .file:
                
                let nameFolder = "FilesPDF/"
                let filePathStr = nameFolder + pathsStrings[indexPath.row]
                
                guard let fullFilePath = Bundle.main.path(forResource: filePathStr,
                                                          ofType: "pdf") else { return }
                
                let fileUrl = URL(fileURLWithPath: fullFilePath)
                let urlRequest = URLRequest(url: fileUrl)
                webView.load(urlRequest)
            
        }
    }
    
}
