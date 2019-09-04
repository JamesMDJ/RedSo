//
//  ViewController.swift
//  RedSo
//
//  Created by 馬丹君 on 2019/9/3.
//  Copyright © 2019 MaJ. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var typeSegmentedControl: UISegmentedControl!
    let api = APIManager(baseURL: "us-central1-redso-challenge.cloudfunctions.net")
    private(set) var redSoViewModel:RedSoViewModel?
    var currentResults:CurrentResults?{
        didSet{
            guard let currentResults = currentResults else{return}
            redSoViewModel = RedSoViewModel(currentResults: currentResults)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initLayout()
        initData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @objc func handleRefresh(){
        updateData(index:typeSegmentedControl.selectedSegmentIndex)
        tableView.refreshControl?.endRefreshing()
        
    }
    
    func initLayout(){
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        typeSegmentedControl.setTitleTextAttributes([.font: UIFont.boldSystemFont(ofSize: 18) ], for: .normal)
    }
    
    func initData(){
        updateData(index: 0)
    }

    @IBAction func typeValueChange(_ sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex
        updateData(index: index)
    }
    
 
    
    @IBAction func swipeChangeType(_ sender: UISwipeGestureRecognizer) {
        if sender.direction == .right{
            if typeSegmentedControl.selectedSegmentIndex > 0{
                typeSegmentedControl.selectedSegmentIndex -= 1
                updateData(index: typeSegmentedControl.selectedSegmentIndex)
            }
        }else if sender.direction == .left{
            if typeSegmentedControl.selectedSegmentIndex < 2{
                typeSegmentedControl.selectedSegmentIndex += 1
                updateData(index: typeSegmentedControl.selectedSegmentIndex)
            }
        }
    }
    
 
    
    func updateData(index:Int){
        switch index{
        case 0:
            api.getAllData(type: "rangers") { (data) in
                self.currentResults = CurrentResults(results: data)
            }
        case 1:
            api.getAllData(type: "elastic") { (data) in
                self.currentResults = CurrentResults(results: data)
            }
        case 2:
            api.getAllData(type: "dynamo") { (data) in
                self.currentResults = CurrentResults(results: data)
            }
        default:
            api.getAllData(type: "rangers") { (data) in
                self.currentResults = CurrentResults(results: data)
            }
        }
    }
    
    
}

extension ViewController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return currentResults?.results.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
        switch self.currentResults?.results[indexPath.row].type {
            case "banner":
                cell.descriptionSatckView.isHidden = true
                cell.avatarView.isHidden = true
                cell.bannerImageView.isHidden = false
                do{
                    if self.currentResults?.results[indexPath.row].url != nil{
                        let urlImg = URL(string: (self.currentResults?.results[indexPath.row].url)!)
                        let data = try Data(contentsOf: urlImg!)
                        let bannerImage = UIImage(data: data)
                        cell.bannerImageView.image = bannerImage
                    }
                }catch{
                    print(error)
            }
            case "employee":
                cell.avatarView.isHidden = false
                cell.descriptionSatckView.isHidden = false
                cell.bannerImageView.isHidden = true
                cell.nameLabel.text = self.currentResults?.results[indexPath.row].name
                cell.positionLabel.text = self.currentResults?.results[indexPath.row].position
                cell.avatarImageView.layer.cornerRadius = cell.avatarImageView.bounds.width/2
                var expertise:String = ""
                if self.currentResults!.results[indexPath.row].expertise != nil{
                    for i in 0..<self.currentResults!.results[indexPath.row].expertise!.count
                    {
                        expertise.append(contentsOf: "\(self.currentResults!.results[indexPath.row].expertise![i]) ")
                        if i == self.currentResults!.results[indexPath.row].expertise!.count - 1{
                            expertise.append(contentsOf: ".")
                        }else{
                            expertise.append(contentsOf: ",")
                        }
                    }
                    cell.expertiseLabel.text = expertise
                }
                do{
                    if self.currentResults?.results[indexPath.row].avatar != nil{
                        let urlImg = URL(string: (self.currentResults?.results[indexPath.row].avatar)!)
                        let data = try Data(contentsOf: urlImg!)
                        let image = UIImage(data: data)
                        cell.avatarImageView.image = image
                    }
                }catch{
                    print(error)
                }
            
        default:
            cell.avatarView.isHidden = false
            cell.descriptionSatckView.isHidden = false
            cell.bannerImageView.isHidden = true
        }

        return cell
    }
    
}

