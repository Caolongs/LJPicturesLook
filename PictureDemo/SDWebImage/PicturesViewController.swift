//
//  PicturesViewController.swift
//  sharpei
//
//  Created by Caolongjian on 16/1/4.
//  Copyright © 2016年 vlbuilding. All rights reserved.
//

import UIKit

class PicturesViewController: UIViewController,UIScrollViewDelegate {

    
    var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.backgroundColor = UIColor.blackColor()
        view.pagingEnabled = true
        return view
    }()
    var pageNumLabel: UILabel = {
        let view = UILabel()
        view.backgroundColor = UIColor.grayColor()
        view.textAlignment = NSTextAlignment.Center
        view.alpha=0.8
        return view
    }()
    var downloadBtn: UIButton = {
        let view = UIButton()
        view.backgroundColor = UIColor.redColor()
        view.alpha = 0.8
        return view
    }()
    
    var urlArray:[String] = []
    var pageNum = 0
    var array:[UIScrollView] = []
    var index = 0
//    var imgScale: CGFloat = 1.0
    
    override func viewDidAppear(animated: Bool) {
        self.navigationController?.navigationBar.barTintColor = UIColor.grayColor()

    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
       
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.translucent = false
        self.view.addSubview(self.scrollView)
        self.view.addSubview(self.pageNumLabel)
        self.view.addSubview(self.downloadBtn)
        self.pageNumLabel.text = String(pageNum+1)+"/"+String(self.urlArray.count)
        self.scrollView.delegate = self
        
        self.scrollView.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(self.view).inset(EdgeInsetsMake(0, left: 0, bottom: 0, right: 0))
        }
        self.pageNumLabel.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(self.view)
            make.bottom.equalTo(-80)
            make.size.equalTo(CGSize(width: 60, height: 30))
        }
        self.downloadBtn.snp_makeConstraints { (make) -> Void in
            make.right.equalTo(self.view).offset(-30)
            make.bottom.equalTo(self.view.snp_bottom).offset(-80)
            make.size.equalTo(CGSize(width: 40, height: 40))
        }
        
        for url:String in self.urlArray{
            let subScrollView = UIScrollView(frame: CGRectZero)
            self.scrollView.addSubview(subScrollView)
            subScrollView.delegate = self
            subScrollView.minimumZoomScale = 1
            subScrollView.maximumZoomScale = 5
            subScrollView.showsHorizontalScrollIndicator = false
            subScrollView.showsVerticalScrollIndicator = false
            subScrollView.contentSize = CGSizeMake(self.view.frame.size.width,self.view.frame.size.height)
            
            array.append(subScrollView)
            
            let imageView = UIImageView(frame: CGRectZero)
            imageView.contentMode = .ScaleAspectFit
            imageView.userInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer(target: self, action: "tapGesture:")
            tapGesture.numberOfTapsRequired = 2
            imageView.addGestureRecognizer(tapGesture)
            subScrollView.addSubview(imageView)
            imageView.snp_makeConstraints(closure: { (make) -> Void in
                
                make.width.equalTo(subScrollView.snp_width)
                make.height.equalTo(subScrollView.snp_height)
                make.centerX.equalTo(subScrollView.snp_centerX)
                make.centerY.equalTo(subScrollView.snp_centerY)
            })
            
            
            let aiv = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
            imageView.addSubview(aiv)
            aiv.snp_makeConstraints(closure: { (make) -> Void in
                make.centerX.equalTo(imageView.snp_centerX)
                make.centerY.equalTo(imageView.snp_centerY)
            })
            
            aiv.startAnimating()
            imageView.sd_setImageWithURL(NSURL(string: url), completed: { (img, err, cacheType, url) -> Void in
                aiv.stopAnimating()
                
            })
            
            //子scrollView约束
            for i in 0..<array.count {
                let smallScrollView: UIScrollView = array[i];
                var lastView:UIScrollView?
                if i == 0{
                    lastView = nil
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

    }
    func tapGesture(tap: UITapGestureRecognizer){
        let scllV = tap.view?.superview as! UIScrollView
        UIView.animateWithDuration(0.6, animations: { () -> Void in
            scllV.zoomScale = scllV.zoomScale < 1.1 ? 2:1
            })
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
        if scrollView == self.scrollView{
            self.pageNum = Int(self.scrollView.contentOffset.x/self.scrollView.frame.size.width)
            self.pageNumLabel.text = String(self.pageNum+1)+"/"+String(self.urlArray.count)
            
            //或
//            let iv = array[pageNum].subviews.first as! UIImageView
//            let aiv = iv.subviews.first as! UIActivityIndicatorView
//            iv.sd_setImageWithURL(NSURL(string: urlArray[pageNum]), completed: { (img, err, cacheType, url) -> Void in
//                aiv.stopAnimating()
//            })
        }
        
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
                let imV = subView.subviews.first as! UIImageView
                let height = 375*CGFloat((imV.image?.size.height)!)/CGFloat((imV.image?.size.width)!)
                let  insetTop = ((subView.bounds.size.height - height))*(scrollView.zoomScale)*0.5

                if subView.bounds.size.height < (height*scrollView.zoomScale){
                    subView.contentInset = UIEdgeInsetsMake(-insetTop, 0, -insetTop, 0)
                    
                }
            }else{//scale -> smaller -> center
                scrollView.layoutIfNeeded()
                var offsetX:CGFloat = 0.0
                var offsetY:CGFloat = 0.0
                let subView = array[pageNum]
                subView.contentInset = UIEdgeInsetsZero
                if (subView.bounds.size.width>subView.contentSize.width){
                    offsetX = (subView.bounds.size.width-subView.contentSize.width)*0.5
                }
                if (subView.bounds.size.height>subView.contentSize.height){
                    offsetY = (subView.bounds.size.height-subView.contentSize.height)*0.5
                }
                
                let imgView = subView.subviews.first
                imgView?.center = CGPoint(x: subView.contentSize.width*0.5+offsetX, y: subView.contentSize.height*0.5+offsetY)
                
            }
        }
    }
    
    //zoomScale 1...screenH  do not scroll(up down)
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView != self.scrollView{
            if scrollView.zoomScale > 1{
                let subView = array[pageNum]
                let imV = subView.subviews.first as! UIImageView
                let height = 375*CGFloat((imV.image?.size.height)!)/CGFloat((imV.image?.size.width)!)
                
                if self.view.bounds.size.height > height * scrollView.zoomScale {
                scrollView.contentOffset.y = (self.view.bounds.size.height*scrollView.zoomScale-self.view.bounds.size.height)*0.5
                }
            }
        }
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
