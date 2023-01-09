//
//  HomeViewController.swift
//  Balanced Diet App
//
//  Created by Rumesh Bandara on 1/7/23.
//

import UIKit

class HomeViewController: UIViewController{
    
    
    let sectionTitles: [String] = ["Fats", "Meat", "Milk", "vegetables", "Fruits", "Bakery"]
    
    private let homeFeedTable: UITableView = {
            let table =  UITableView(frame: .zero, style: .grouped)
        table.register(desingTableViewCell.self, forCellReuseIdentifier: desingTableViewCell.identifier)
            return table
        }()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
              // title = "Home"
            //   navigationController?.navigationBar.prefersLargeTitles = true
           //    navigationController?.navigationItem.largeTitleDisplayMode = .always
               
               view.addSubview(homeFeedTable)
        homeFeedTable.delegate = self
        homeFeedTable.dataSource = self
        
        
        configureNavbar()
        
        /*ntrition top bar image set gap hadanne **/
       let  headerView = NutritionHeaderUiView(frame: CGRect(x:0,y:0,width: view.bounds.width, height: 250))
           homeFeedTable.tableHeaderView = headerView
        
      
    }
    
    /**set top bar  logo*/
    private func  configureNavbar() {
        var image = UIImage(named: "Logo")
        image = image?.withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: nil)
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: #selector(loginporson) )
        ]
        
       
        
        navigationController?.navigationBar.tintColor = .blue
    }
  
    @objc func loginporson()
    {
        let LoginController = LoginViewController()
        present(LoginController, animated: true, completion: nil)
        
        
    }
    

    /* list gann widiha*/
       override func viewDidLayoutSubviews() {
           super.viewDidLayoutSubviews()
        homeFeedTable.frame = view.bounds
       }

}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    /*section kweduwe**/
    func numberOfSections(in tableView: UITableView) -> Int {
        return  sectionTitles.count  //20     /* uda thiyena title adala vidihata hedenne*/
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0 //dala ganna
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: desingTableViewCell.identifier, for: indexPath) as? desingTableViewCell else {
            return UITableViewCell()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    /*section wala title tika style set krnwa**/
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    /*section wala title tika style set krnwa**/
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else {return}
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x + 20, y: header.bounds.origin.y , width: 100, height: header.bounds.height)
        header.textLabel?.textColor = .lightGray
        header.textLabel?.text =  header.textLabel?.text?.uppercased()  //.capitalizeFirstLetter()
    }
    
    
    /*header bar udata yanawa **/
    func scrollViewDidScroll(_ scrollView: UIScrollView)  {
        let defaultOffset = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaultOffset
        navigationController?.navigationBar.transform = .init(translationX: 0 ,y: min(0, -offset))
    }
    
    
}
