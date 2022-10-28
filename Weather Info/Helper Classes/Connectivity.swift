//
//  Connectivity.swift
//
//  Created by apple on 15/03/21.
//

import Foundation
import Reachability
import NVActivityIndicatorView

public class Connectivity  {
    public static let shared = Connectivity()
    public init(){}
    public func startLoad(){
        
        DispatchQueue.main.async {
            let activityData = ActivityData.init(size: CGSize(width: 60.0, height: 60.0), type: .ballRotateChase, color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),  backgroundColor: .black.withAlphaComponent(0.4))
            NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
        }
    }
    
    public func endLoad(){
        DispatchQueue.main.async {
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
        }
    }
    
    //MARK:- CHECKING INTERNET CONNECTIVITY
    class public var isConnectedToInternet:Bool {
        var internet = false
        let reachability = try! Reachability()
        if reachability.connection != .unavailable {
            internet = true
        }
        else{
            internet = false
        }
        return internet
    }
}
