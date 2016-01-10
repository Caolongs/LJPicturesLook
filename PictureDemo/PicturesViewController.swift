//
//  PicturesViewController.swift
//  sharpei
//
//  Created by Caolongjian on 16/1/4.
//  Copyright © 2016年 vlbuilding. All rights reserved.
//

import UIKit

class PicturesViewController: UIViewController,UIScrollViewDelegate {

    //@IBOutlet weak var scrollView: UIScrollView!
    //@IBOutlet weak var pageNumLabel: UILabel!
    //@IBOutlet weak var downloadBtn: UIButton!
    
    var scrollView: UIScrollView = {
        let view = UIScrollView()
        return view
    }()
    var pageNumLabel: UILabel = {
        let view = UILabel()
        return view
    }()
    var downloadBtn: UIButton = {
        let view = UIButton()
        view.backgroundColor = UIColor.redColor()
        return view
    }()
    
    
    var urlArray:[String] = []
    var pageNum = 0
    var array:[UIScrollView] = []
    var index = 0
    var imgScale: CGFloat = 1.0
    
//    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
//        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
//    }
//    convenience  init() {
//        var nibNameOrNil = String?("PicturesViewController")
//        //考虑到xib文件可能不存在或被删，故加入判断
//        if NSBundle.mainBundle().pathForResource(nibNameOrNil, ofType: "xib") == nil
//        {
//            nibNameOrNil = nil
//        }
//        self.init(nibName: nibNameOrNil, bundle: nil)
//    }
    override init(){
        super.init()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    override func viewDidAppear(animated: Bool) {
        self.navigationController?.navigationBar.barTintColor = UIColor.blackColor()
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        //设置status bar的文字为白色
        //UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: false)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scrollView.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(self.view).inset(EdgeInsetsMake(0, left: 0, bottom: 0, right: 0))
        }
        self.pageNumLabel.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(self.view)
            make.bottom.equalTo(100)
            make.size.equalTo(CGSize(width: 60, height: 30))
        }
        self.downloadBtn.snp_makeConstraints { (make) -> Void in
            make.right.equalTo(self.view).offset(-30)
            make.bottom.equalTo(self.view.snp_bottom).offset(-140)
            make.size.equalTo(CGSize(width: 40, height: 40))
        }
        
        
        
        self.navigationController?.navigationBar.translucent = false
        self.downloadBtn.alpha = 0.8
        self.pageNumLabel.alpha=0.8
        self.pageNumLabel.text = String(pageNum+1)+"/"+String(self.urlArray.count)
        
        self.scrollView.delegate = self
        self.scrollView.backgroundColor = UIColor.blackColor()
        self.scrollView.pagingEnabled = true
        
        
        for url:String in self.urlArray{
            let subScrollView = UIScrollView(frame: CGRectZero)
            self.scrollView.addSubview(subScrollView)
            subScrollView.delegate = self
            subScrollView.minimumZoomScale = 1
            subScrollView.maximumZoomScale = 3
            subScrollView.showsHorizontalScrollIndicator = false
            subScrollView.showsVerticalScrollIndicator = false
            //subScrollView.contentSize = self.view.bounds.size
            
            let imageView = UIImageView(frame: CGRectZero)
            let aiv = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
            imageView.addSubview(aiv)
            aiv.snp_makeConstraints(closure: { (make) -> Void in
                make.centerX.equalTo(imageView.snp_centerX)
                make.centerY.equalTo(imageView.snp_centerY)
            })
            aiv.startAnimating()
            imageView.backgroundColor = UIColor.yellowColor()
            imageView.userInteractionEnabled = true
            subScrollView.contentSize = CGSizeMake(self.view.frame.size.width,self.view.frame.size.height)
            //subScrollView.backgroundColor = UIColor.yellowColor()
            imageView.contentMode = .ScaleAspectFit
            let tapGesture = UITapGestureRecognizer(target: self, action: "tapGesture:")
            tapGesture.numberOfTapsRequired = 2
            imageView.addGestureRecognizer(tapGesture)
            subScrollView.addSubview(imageView)
            array.append(subScrollView)
            imageView.sd_setImageWithURL(NSURL(string: url), completed: { (img, err, cacheType, url) -> Void in
                aiv.stopAnimating()
                
                //根据图片大小，约束   ？
//                let height = 375*CGFloat(img.size.height)/CGFloat(img.size.width)
//                let sview = self.array[self.index++]
//                sview.subviews[0].snp_makeConstraints(closure: { (make) -> Void in
//                    make.centerX.equalTo(subScrollView.snp_centerX)
//                    make.centerY.equalTo(subScrollView.snp_centerY)
//                    make.width.equalTo(375)
//                    make.height.equalTo(height)
//                })
                
            })
            
            imageView.snp_makeConstraints(closure: { (make) -> Void in
                make.centerX.equalTo(subScrollView.snp_centerX)
                make.centerY.equalTo(subScrollView.snp_centerY)
                make.width.equalTo(subScrollView.snp_width)
                make.height.equalTo(subScrollView.snp_height)
            })
            
            
            for i in 0..<array.count {
                let smallScrollView: UIScrollView = array[i];
                var lastView:UIScrollView?
                if i == 0{
                    //let lastView = nil
                }else{
                    lastView = array[i-1]
                }
                
                if let lv = lastView{
                    smallScrollView.snp_makeConstraints(closure: { (make) -> Void in
                        make.top.equalTo(lv.snp_top)
                        make.left.equalTo(lv.snp_right)
                        make.width.equalTo(self.scrollView.snp_width)
                        make.height.equalTo(self.scrollView.snp_height)
                    })
                }else{
                    smallScrollView.snp_makeConstraints(closure: { (make) -> Void in
                        make.top.equalTo(self.scrollView.snp_top)
                        make.left.equalTo(self.scrollView.snp_left)
                        make.width.equalTo(self.scrollView.snp_width)
                        make.height.equalTo(self.scrollView.snp_height)
                    })
                }
            }
        }
        self.view.bringSubviewToFront(self.pageNumLabel)
        self.view.bringSubviewToFront(self.downloadBtn)

        // Do any additional setup after loading the view.
    }
    func tapGesture(tap: UITapGestureRecognizer){
        let scllV = tap.view?.superview as! UIScrollView
        if scllV.zoomScale < 1.1{
//            tap.view?.center = CGPoint(x: scllV.center.x, y: scllV.center.y)
//            //scllV.contentInset = UIEdgeInsetsMake(-100, 0, 100, 0)
//            UIView.animateWithDuration(1, animations: { () -> Void in
//                scllV.zoomScale = scllV.bounds.size.height/(tap.view?.bounds.size.height)!
//                tap.view?.center = CGPoint(x: scllV.center.x, y: scllV.center.y-100)
//            })
        }else{
            UIView.animateWithDuration(0.6, animations: { () -> Void in
                scllV.zoomScale = 1
            })
        }
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.translucent = true
        //设置status bar的文字为白色
        //UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.Default, animated: false)
        self.navigationController?.navigationBar.barTintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.tintColor = UIColor.grayColor()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.scrollView.contentSize = CGSize(width: (self.view.frame.size.width)*CGFloat(self.urlArray.count), height: self.view.frame.size.height)
        self.scrollView.contentOffset = CGPoint(x: self.view.frame.size.width*CGFloat(self.pageNum), y: 0)
        
        
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return .All
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        self.pageNum = Int(self.scrollView.contentOffset.x/self.scrollView.frame.size.width)
        
        self.pageNumLabel.text = String(self.pageNum+1)+"/"+String(self.urlArray.count)
    }
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        if scrollView != self.scrollView{
            return scrollView.subviews[0]
            
        }
        return nil
    }
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
        if scrollView != self.scrollView{
            
            if scrollView.zoomScale > 1 {
                scrollView.layoutIfNeeded()
                let subView = array[pageNum]
                //self.imgScale = scrollView.zoomScalev
//                var insetTop = (subView.bounds.size.height-subView.contentSize.height)*0.5*0.5
//                if insetTop < 0{
//                  let  insetTop = (subView.bounds.size.height - (subView.subviews.first?.bounds.size.height)!)*0.5*0.5

//                }
        
                
                
                let imV = subView.subviews.first as! UIImageView
                let  insetTop = (subView.bounds.size.height - (imV.image?.size.height)!)*(scrollView.zoomScale)*0.5
                
                
                print(imV.image?.size.height)
                print((imV.image?.size.height)!*scrollView.zoomScale)
                
                if subView.bounds.size.height - ((imV.image?.size.height)!*scrollView.zoomScale)>0{
                    print(imV.image?.size.height)
                    
                    //subView.contentSize = CGSize(width: 500, height: 1)
//                    UIScrollView
                    subView.directionalLockEnabled = true
                    //imV.center = subView.center
                }else{
                    
                
                
                
            
                subView.contentInset = UIEdgeInsetsMake(-insetTop, 0, -insetTop, 0)
                }
                
                return
            }
            
            scrollView.layoutIfNeeded()
            //print("zooming")
            var offsetX:CGFloat = 0.0
            var offsetY:CGFloat = 0.0
            let subView = array[pageNum]
            subView.contentInset = UIEdgeInsetsZero
            if (subView.bounds.size.width>subView.contentSize.width){
                offsetX = (subView.bounds.size.width-subView.contentSize.width)*0.5
            }else{
                offsetX = 0.0
            }
            if (subView.bounds.size.height>subView.contentSize.height){
                offsetY = (subView.bounds.size.height-subView.contentSize.height)*0.5
            }else{
                offsetY = 0.0
            }
            
            let imgView = subView.subviews.first
            imgView?.center = CGPoint(x: subView.contentSize.width*0.5+offsetX, y: subView.contentSize.height*0.5+offsetY)
            
            self.imgScale = scrollView.zoomScale
        }
    }
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        scrollView.contentOffset.y = (self.view.bounds.size.height*scrollView.zoomScale-self.view.bounds.size.height)*0.5
        
    }
    
    //点击按钮保存图片到相册
    @IBAction func downloadPicBtnClick(sender: AnyObject) {

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
