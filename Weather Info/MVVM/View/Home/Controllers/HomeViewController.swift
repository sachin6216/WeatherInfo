//
//  HomeViewController.swift
//  Weather Info
//
//  Created by Sachin on 27/10/22.
//

import UIKit
import Combine

class HomeViewController: UIViewController {

    // MARK: - Properties
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var lblLoc: UILabel!
    @IBOutlet weak var imgWeatherIcon: UIImageView!
    @IBOutlet weak var lblWeatherStatus: UILabel!
    @IBOutlet weak var lblTemp: UILabel!
    @IBOutlet weak var lblWindValue: UILabel!
    @IBOutlet weak var lblPrecpValue: UILabel!
    @IBOutlet weak var lblPressureValue: UILabel!
    // MARK: - Variables
    var viewModel = HomeViewModel()
    private var subscriptions = Set<AnyCancellable>() //Cancellation
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUITheme()
        self.subscribers()
    }
    override func viewWillAppear(_ animated: Bool) {
    }
    // MARK: - IBActions
    @IBAction func btnReload(_ sender: UIButton) {
        self.viewModel.getCurrentLoc()
    }
    // MARK: - Extra functions
    func setUITheme() {
        self.bgView.layer.cornerRadius = 10
        self.bgView.layer.borderColor = #colorLiteral(red: 0.3761256337, green: 0.5008631945, blue: 0.5802932382, alpha: 1)
        self.bgView.layer.borderWidth = 3.5
        let imgView = UIImageView.init(frame: self.view.frame)
        imgView.image = #imageLiteral(resourceName: "mountains")
        self.view.insertSubview(imgView, at: 0)
    }
    // MARK: - APIs
    func subscribers() {
        self.viewModel.getWeatherDetailsPublisher.sink { item in
            print(item)
        }.store(in: &subscriptions)
    }
    
}
// MARK: - Extension UI
