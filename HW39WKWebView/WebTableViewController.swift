//
//  WebTableViewController.swift
//  HW39WKWebView
//
//  Created by Сергей on 15.04.2020.
//  Copyright © 2020 Sergei. All rights reserved.
//

import UIKit
import WebKit

protocol WebTableViewControllerDelegate {
    
    func send(requestType: TypeRequest, pathsStrings: [String], indexPath: IndexPath)
    
}

class WebTableViewController: UITableViewController {

    //MARK: Properties
    
    var sections = [Section]()
    var delegate: WebTableViewControllerDelegate?
    
    //Lazy properties
    let webViewController: WebViewController = {
        let webViewController = WebViewController()
        return webViewController
    }()
    
    lazy var sectionWeb: Section = {
        let section = Section(name: "Web")
        section.addresses = ["https://www.google.ru",
                             "https://vk.com/iosdevcourse", "https://yandex.ru"]
        return section
    }()
    
    lazy var sectionPdf: Section  = {
        let section = Section(name: "Pdf")
        section.addresses = ["1", "2"]
        return section
    }()
    
    override func loadView() {
        super.loadView()
        
        navigationItem.title = "Custom Browser"
        
        sections = [sectionWeb, sectionPdf]
        self.delegate = webViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
       
        return sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        guard let addressesInSectionCount = sections[section].addresses?.count else { return 0 }
        
        return addressesInSectionCount
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "cellIdentifier"
        
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        
        cell = cell != nil ? cell! : UITableViewCell(style: .default,
                                                     reuseIdentifier: cellIdentifier)
        
        let section = sections[indexPath.section]
        let address = section.addresses?[indexPath.row]
        cell?.textLabel?.text = address

        return cell ?? UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let sectionName = sections[section].name
        
        return sectionName
    }

    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.section {
            case 0:
                let addresses = sections[indexPath.section].addresses ?? [String]()
                delegate?.send(requestType: .web, pathsStrings: addresses, indexPath: indexPath)
                navigationController?.show(webViewController, sender: nil)
            case 1:
                let addresses = sections[indexPath.section].addresses ?? [String]()
                delegate?.send(requestType: .file, pathsStrings: addresses, indexPath: indexPath)
                navigationController?.show(webViewController, sender: nil)
            default:
                break
        }
    
    }
    
    
}

