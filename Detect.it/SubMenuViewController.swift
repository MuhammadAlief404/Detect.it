//
//  SubMenuViewController.swift
//  Detect.it
//
//  Created by Muhammad Alief on 21/05/19.
//  Copyright © 2019 Muhammad Alief. All rights reserved.
//

import UIKit

class SubMenuViewController: UIViewController {
    
    var mainMenu:MainMenu!
    
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var lblMenu: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        imgLogo.image = UIImage(named: mainMenu.gambarMenu)
        lblMenu.text = mainMenu.namaMenu
    }

}
