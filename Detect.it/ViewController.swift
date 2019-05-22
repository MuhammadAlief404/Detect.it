//
//  ViewController.swift
//  Detect.it
//
//  Created by Muhammad Alief on 21/05/19.
//  Copyright © 2019 Muhammad Alief. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var mainMenu = [MainMenu]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let dest = segue.destination as! SubMenuViewController
        
        mainMenu.append(MainMenu(namaMenu: "Text Detection", gambarMenu: "text_logo"))
        mainMenu.append(MainMenu(namaMenu: "Face Detection", gambarMenu: "face_logo"))
        mainMenu.append(MainMenu(namaMenu: "Landmark Detection", gambarMenu: "landmark_logo"))
        mainMenu.append(MainMenu(namaMenu: "Logo Detection", gambarMenu: "logodetect_logo"))
        
        if segue.identifier == "menu1" {
            dest.mainMenu = mainMenu[0]
        }
        if segue.identifier == "menu2" {
            dest.mainMenu = mainMenu[1]
        }
        if segue.identifier == "menu3" {
            dest.mainMenu = mainMenu[2]
        }
        if segue.identifier == "menu4" {
            dest.mainMenu = mainMenu[3]
        }
    }


}

