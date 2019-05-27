//
//  ViewController.swift
//  BitCoinChallenge
//
//  Created by Chad Murdock on 5/24/19.
//  Copyright © 2019 KarmaDeli Works. All rights reserved.
//

import UIKit
import CoreLocation
import RealmSwift

class ViewController: UITableViewController {
  
    //MARK: - Properties
    let viewModel = WeatherDataViewModel()
    let locationManager = CLLocationManager()
    var notificationToken: NotificationToken?
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        getWeather()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vc = segue.destination as? DetailViewController else { return }
        if let viewModal = sender as? DetailViewModel{
            vc.viewModel = viewModal
        }
    }

    func setup(){
        viewModel.setTitleView(navItem: navigationItem)
        self.tableView.register(UINib(nibName: "WeatherCell", bundle: nil), forCellReuseIdentifier: "weatherCell")
        tableView.tableFooterView = UIView()

        notificationToken = RealmCRUDService.shared.realm?.observe({ [weak self] (notification, realm) in
            self?.tableView.reloadData()
        })
    }
    
    func getWeather(){
        viewModel.getData(with: NetworkingClient.shared.params(city: "tokyo"))
        viewModel.getData(with: NetworkingClient.shared.params(city: "london"))
        viewModel.getLatLon { [weak self] (lat, lon) in
            self?.viewModel.getData(with: NetworkingClient.shared.params(lat: lat, lon: lon))
            self?.viewModel.dispatchGroup.notify(queue: .main) { [weak self] in
                self?.tableView.reloadData()
            }
        }
        viewModel.getSavedCities()
        viewModel.dispatchGroup.notify(queue: .main) { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    //MARK: - Actions
    @IBAction func addCountryAction(_ sender: Any) {
        LocalStoreRetrieve.shared.saveCity(vc: self, vm: viewModel)
    }
}

extension ViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCell", for: indexPath) as? WeatherCell else { return UITableViewCell() }
        cell.name.text = viewModel.dataSource[indexPath.row].cityName
        cell.temp.text = viewModel.dataSource[indexPath.row].temp
        cell.icon.image = viewModel.dataSource[indexPath.row].icon
        
        return cell
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataSource.count
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
        let detailViewModel = DetailViewModel()
        performSegue(withIdentifier: "fromMainToDetail", sender: detailViewModel.setup(model: viewModel.dataSource[indexPath.row]))
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else {return}
        
        let userCity = UserSavedCities()
        userCity.name = viewModel.dataSource[indexPath.row].cityName
        
        viewModel.dataSource.remove(at: indexPath.row)
        RealmCRUDService.shared.delete(realmObject: userCity)
        
    }
    
}

