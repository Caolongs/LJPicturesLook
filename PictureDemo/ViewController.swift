//
//  ViewController.swift
//  PictureDemo
//
//  Created by Caolongjian on 16/1/6.
//  Copyright © 2016年 Caolongjian. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    @IBAction func click(sender: AnyObject) {
        let picVC  = PicturesViewController()
        picVC.urlArray = ["https://ss0.bdstatic.com/5aV1bjqh_Q23odCf/static/superman/img/logo/bd_logo1_31bdc765.png","http://img5.duitang.com/uploads/item/201508/24/20150824152054_3xzje.thumb.224_0.jpeg","http://v1.qzone.cc/avatar/201401/30/21/40/52ea5662b3ebb161.jpg%21200x200.jpg"]
        
        
        
        self.presentViewController(UINavigationController(rootViewController: picVC), animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

