//
//  SearchViewController.swift
//  Market
//
//  Created by KurbanAli on 11/01/21.
//

import UIKit
import NVActivityIndicatorView


class SearchViewController: UIViewController {
    
    //    MARK: - IBOutlet
    
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var searchOptionView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButtonOutlet: UIButton!
    
    //    MARK: - Vars
    
    let searchResults: [Item] = []
    var activityIndicator: NVActivityIndicatorView?
    
    //    MARK: - View lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblView.tableFooterView = UIView()
        searchTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        activityIndicator = NVActivityIndicatorView(frame: CGRect(x: self.view.frame.width / 2 - 30, y: self.view.frame.height / 2 - 30 , width: 60, height: 60), type: .ballPulse , color: #colorLiteral(red: 0.9100239873, green: 0.4986173511, blue: 0.4462146759, alpha: 1), padding: nil)
    }
    //    MARK: - IBActions
    
    @IBAction func showSearchBarButtonPressed(_ sender: Any) {
        dismissKeyboard()
        showSearchField()
        animateSearchOption()
    }
    
    @IBAction func searchButtonPressed(_ sender: Any) {
        
    }
    
    //    MARK: - Halpers
    
    private func emptyTextField() {
        searchTextField.text = ""
    }
    
    private func dismissKeyboard(){
        self.view.endEditing(false)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        print("Typing...")
        searchButtonOutlet.isEnabled = textField.text != ""
        
        if searchButtonOutlet.isEnabled{
            searchButtonOutlet.backgroundColor = #colorLiteral(red: 0.9095627666, green: 0.4979957938, blue: 0.4498652816, alpha: 1)
        } else {
            disableSearchButton()
        }
    }
    
    private func disableSearchButton(){
        searchButtonOutlet.isEnabled = false
        searchButtonOutlet.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
    }
    
    private func showSearchField() {
        disableSearchButton()
        
    }
    
    //    MARK:- Animations
    private func animateSearchOption(){
        UIView.animate(withDuration: 0.5) {
            self.searchOptionView.isHidden = !self.searchOptionView.isHidden
        }
    }
    
    //    MARK:- Activity Indicator
    
    private func showLoadingIndicator(){
        if activityIndicator != nil {
            self.view.addSubview(activityIndicator!)
            activityIndicator!.startAnimating()
        }
    }
    private func hideLoadingIndicator(){
        if activityIndicator != nil {
            activityIndicator?.removeFromSuperview()
            activityIndicator!.stopAnimating()
        }
    }
    
    //    MARK:- Navigation
    
    private func shoeItemView(withItem: Item) {
        let itemVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "itemView") as! ItemViewController
        
        itemVC.item = withItem
        self.navigationController?.pushViewController(itemVC, animated: true)
    }
}

//    MARK: - Extension

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tblView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ItemTableViewCell
        cell.generateCell(searchResults[indexPath.row])
        
        return cell
    }
    
    //    MARK:- Table view delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        shoeItemView(withItem: searchResults[indexPath.row])
    }
}