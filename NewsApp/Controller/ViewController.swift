//
//  ViewController.swift
//  NewsApp
//
//  Created by Naveen Natrajan on 14/05/22.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var newsTableView: UITableView!
    var techCrunchNewsData : NewsAPIJSON?
    override func viewDidLoad() {
        super.viewDidLoad()
        newsTableView.delegate = self
        newsTableView.dataSource = self
        newsTableView.register(UINib(nibName: reuseNibIdentifier.newsTableViewCell, bundle: nil), forCellReuseIdentifier: reuseCellIdentifier.newsTableViewCell)
        makePostCallNewsData()
    }
    func makePostCallNewsData() {
     
        let decoder = JSONDecoder()
        if let url = URL(string: "\(ConstantsUsedInProject.baseUrl)\(ConstantsUsedInProject.newsApiKey)")
        {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
                guard error == nil && data != nil else {
                    print("error=\(String(describing: error))")
                    return
                }
                do {
                    let jsonResponse = try? decoder.decode(NewsAPIJSON.self, from: data!)
                    let code_str = jsonResponse!.status
                    
                    DispatchQueue.main.async { [self] in
                        
                        if code_str == "ok" {
                            techCrunchNewsData = jsonResponse
                            print(jsonResponse as Any)
                            techCrunchNewsData = jsonResponse
                            newsTableView.reloadData()
                        }else   {
                            print(jsonResponse as Any)
                        }
                    }
                }
            }
            task.resume()
        }
    }

}


extension ViewController: UITableViewDelegate , UITableViewDataSource
{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = newsTableView.dequeueReusableCell(withIdentifier: reuseCellIdentifier.newsTableViewCell) as! NewsTableViewCell
        if let articleData = techCrunchNewsData?.articles?[indexPath.row]
        {
            cell.authorLabel.text = articleData.author ?? ""
            cell.titleLabel.text = articleData.title ?? ""
            cell.descriptionLabel.text = articleData.articleDescription ?? ""
            if let imageUrl = articleData.urlToImage
            {
            let urlStr = imageUrl
                let url = URL(string: urlStr)
                DispatchQueue.global().async {
                    let data = try? Data(contentsOf: url!)
                    DispatchQueue.main.async {
                        cell.articleImageVIew.image = UIImage(data: data!)
                        cell.articleImageVIew.contentMode = .scaleAspectFit
                    }
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return techCrunchNewsData?.articles?.count ?? 0
    }
  

}



