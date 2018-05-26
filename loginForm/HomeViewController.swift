//
//  HomeViewController.swift
//  loginForm
//
//  Created by soc-lap-18 on 5/26/18.
//  Copyright © 2018 soc-lap-18. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var user = UserInfo(data: ["":""])
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = user.name
        let url = URL(string:user.picture)
        if let data = try? Data(contentsOf: url!)
        {
            let image: UIImage = UIImage(data: data)!
            userImage.image = image
        }
        userImage.layer.cornerRadius = userImage.bounds.height/2
        // Do any additional setup after loading the view.
    }

    @IBAction func logoutButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
