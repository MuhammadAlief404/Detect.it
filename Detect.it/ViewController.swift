//
//  ViewController.swift
//  Detect.it
//
//  Created by Muhammad Alief on 21/05/19.
//  Copyright © 2019 Muhammad Alief. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mainMenu.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        cell.namaMenu.text = mainMenu[indexPath.item].namaMenu
        cell.Logo.image = UIImage(named: mainMenu[indexPath.item].gambarMenu)
        
        cell.layer.cornerRadius = 10
        cell.layer.shadowColor = UIColor.lightGray.cgColor
        cell.layer.shadowOpacity = 0.5
        cell.layer.shadowOffset = CGSize(width: 3, height: 3)
        cell.layer.shadowRadius = 2
        cell.clipsToBounds = false
        cell.layer.masksToBounds = false
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "DetectionViewController") as! DetectionViewController
        vc.mainMenu = mainMenu[indexPath.item]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    var mainMenu = [MainMenu]()

    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        var layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsetsMake(0, 5, 0, 5)
        layout.minimumInteritemSpacing = 5
        layout.itemSize = CGSize(width: (self.collectionView.frame.size.width - 20)/2, height: self.collectionView.frame.size.height/3)
        
    }

    override func viewWillAppear(_ animated: Bool) {
        mainMenu.append(MainMenu(namaMenu: "Text Detection", gambarMenu: "text_logo"))
        mainMenu.append(MainMenu(namaMenu: "Face Detection", gambarMenu: "face_logo"))
        mainMenu.append(MainMenu(namaMenu: "Landmark Detection", gambarMenu: "landmark_logo"))
        mainMenu.append(MainMenu(namaMenu: "Logo Detection", gambarMenu: "logodetect_logo"))
        mainMenu.append(MainMenu(namaMenu: "Text Detection", gambarMenu: "text_logo"))
        mainMenu.append(MainMenu(namaMenu: "Face Detection", gambarMenu: "face_logo"))
        mainMenu.append(MainMenu(namaMenu: "Landmark Detection", gambarMenu: "landmark_logo"))
        mainMenu.append(MainMenu(namaMenu: "Logo Detection", gambarMenu: "logodetect_logo"))
    }


}

