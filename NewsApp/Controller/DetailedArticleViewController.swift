//
//  DetailedArticleViewController.swift
//  NewsApp
//
//  Created by Naveen Natrajan on 14/05/22.
//

import UIKit
import WebKit
class DetailedArticleViewController: UIViewController {
    @IBOutlet weak var articleWebView: WKWebView!
    var articleUrl : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        if let articleUrlString = articleUrl {
            guard let url = URL(string: articleUrlString) else {
                print("Error loading url")
                return  }
            articleWebView.load(URLRequest(url: url))
        }
    }

}
