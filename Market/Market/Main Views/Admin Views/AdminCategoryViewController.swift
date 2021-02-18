//
//  AdminCategoryViewController.swift
//  Market
//
//  Created by KurbanAli on 18/02/21.
//

import UIKit
import NVActivityIndicatorView

class AdminCategoryViewController: UIViewController {

    //    MARK:- Vars
    
    var allCategories: [Category] = []
    var activityIndicator: NVActivityIndicatorView?
    
    //    MARK:-IBOutlets

    @IBOutlet weak var tabelView: UITableView!

    //    MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator = NVActivityIndicatorView(frame: CGRect(x: self.view.frame.width / 2 - 30, y: self.view.frame.height / 2 - 30 , width: 60, height: 60), type: .circleStrokeSpin , color: #colorLiteral(red: 0.9100239873, green: 0.4986173511, blue: 0.4462146759, alpha: 1), padding: nil)
        
        tabelView.tableFooterView = UIView()
        registerCell()
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        downloadCategories()
        
    }

//    MARK:- Register cell
    
    func registerCell(){
        let cell = UINib(nibName: "AdminCategoryTableViewCell", bundle: nil)
        tabelView.register(cell, forCellReuseIdentifier: "AdminCategoryTableViewCell")
        tabelView.rowHeight = 80
    }
    
    
//    MARK:- Halpers
    
    func downloadCategories(){
        self.showLoadingIndicator()
        downloadCategoriesfromFirebase { (allItems) in
            self.allCategories = allItems
            self.tabelView.reloadData()
            self.hideLoadingIndicator()
        }
    }
    
    func downloadCategoriesfromFirebase(complition: @escaping(_ allCategory: [Category]) -> Void){
        FirebaseReference(.Category).getDocuments { (snapshot, error) in
            if error == nil {
                var allItems: [Category] = []
                for category in snapshot!.documents{
                    allItems.append(Category.init(_dictionary: category.data() as NSDictionary))
                }
                complition(allItems)
            } else{
                print("Error in download categories",error!.localizedDescription)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "categoryToItems"{
            let vc = segue.destination as! AdminItemsViewController
            
            vc.category = sender as! Category
        }
    }

    //    MARK:- Activity indicator
    
    private func showLoadingIndicator(){
        if activityIndicator != nil {
            self.view.addSubview(activityIndicator!)
            activityIndicator?.startAnimating()
        }
    }
    
    private func hideLoadingIndicator(){
        if activityIndicator != nil {
            activityIndicator!.removeFromSuperview()
            activityIndicator!.stopAnimating()
        }
    }
}


// MARK:- Extension for the table view

extension AdminCategoryViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(allCategories.count)
        return allCategories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AdminCategoryTableViewCell", for: indexPath) as! AdminCategoryTableViewCell
        cell.imageView?.image = allCategories[indexPath.row].image
        cell.categoryNameLabel.text = allCategories[indexPath.row].name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "categoryToItems", sender: allCategories[indexPath.row])
    }

}
