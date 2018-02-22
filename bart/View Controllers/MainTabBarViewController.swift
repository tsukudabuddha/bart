//
//  MainTabBarViewController.swift
//  bart
//
//  Created by Andrew Tsukuda on 2/14/18.
//  Copyright © 2018 Andrew Tsukuda. All rights reserved.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.selectedIndex = 1 // Load current station view first
    }

}
