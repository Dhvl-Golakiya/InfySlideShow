//
//  scrollViewUIView.swift
//  BollyNxt
//
//  Created by Dhvl Golakiya on 14/03/17.
//  Copyright © 2017 infyom. All rights reserved.
//

import UIKit

class scrollViewUIView: UIView ,UIScrollViewDelegate,scrollViewUIViewType {
    
    @IBOutlet weak var viewStackView: UIStackView!
    @IBOutlet weak var customScrollView: UIScrollView!
    @IBOutlet weak var pageControll: UIPageControl!
    
    @IBOutlet weak var titlelabel: UILabel!
    @IBOutlet weak var contantsView: UIView!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var shadowView: UIView!
    
    var selectVideoCallback : ((Int) -> Void)?
    var selectShareCallback : ((Int) -> Void)?
    
    var ViewFrame : CGRect!
    var mainUiViewArray = [UIView]()
    var customViewArray = [UIView]()
    var scrollViewPage = 0
    var currentPage: Int = 0
    var moveTimer : Timer?
    var slideshowInterval = 3.0
    var videoArray = [Video]()
    
    var isShowPlayButton = true
    var adsIsShow = false
    
    var rootViewController : UIViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        customScrollView.contentInset.top = 0
        contantsView.layer.cornerRadius = 5
        contantsView.applyShadow(offset: CGSize(width: 0, height: 4) , opacity: 0.3, radius: 7.0)
        contantsView.layer.shadowColor = UIColor.black.cgColor
        
        shadowView.applyShadow(offset: CGSize(width: 0, height: 2) , opacity: 0.4, radius: 10.0)
        shadowView.layer.shadowColor = UIColor.black.cgColor
    }
    
    static func create(frame: CGRect, trailerAndFeaturedArray: [Video], isShowPlayButton : Bool , adsIsShow : Bool ,rootViewController : UIViewController)  -> scrollViewUIView {
        let scrollUiView =  Bundle.main.loadNibNamed("scrollViewUIView", owner: self, options: nil)?[0] as! scrollViewUIView
        scrollUiView.ViewFrame = frame
        scrollUiView.videoArray = trailerAndFeaturedArray
        scrollUiView.adsIsShow = adsIsShow
        scrollUiView.isShowPlayButton = !isShowPlayButton
        scrollUiView.rootViewController = rootViewController
        scrollUiView.didInit()
        return scrollUiView
    }
    
    internal func didInit() {
        self.frame = self.ViewFrame
        setDataArray()
        pageControll.currentPage = currentPage
    }
    
    internal func getUIView() -> UIView {
        return self
    }
    
    func setDataArray(){
        if adsIsShow{
            let adsView = SliderNativeExpressAdsUIView.create(frame: self.ViewFrame)
            adsView.nativeExpressAdsView.rootViewController = rootViewController
            
            mainUiViewArray.append(adsView)
        }
        
        for video in videoArray{
            let url = "https://img.youtube.com/vi/\(video.url.getYoutubeID())/sddefault.jpg"
            let sliderView = SlideShowUiView.create(frame: self.ViewFrame ,url: url, title: video.title)
            sliderView.playImage.isHidden = isShowPlayButton
            sliderView.clickButton.addTarget(self, action: #selector(self.onButtonClick), for: .touchUpInside)
            mainUiViewArray.append(sliderView)
        }
        pageControll.numberOfPages = mainUiViewArray.count
        setArray()
        setUIView()
    }
    
    func onButtonClick(_ sender : UIButton){
        if adsIsShow{
            selectVideoCallback!(currentPage - 1)
        }else{
            selectVideoCallback!(currentPage)
        }
    }
    
    @IBAction func onShareClick(_ sender: UIButton) {
        if adsIsShow{
            selectShareCallback!(currentPage - 1)
        }else{
            selectShareCallback!(currentPage)
        }
    }
    
    func setUIView(){
        var page = 0
        if adsIsShow{
            page = currentPage - 1
        }else{
            page = currentPage
        }
        let video = videoArray[page]
        self.titlelabel.text = video.title
    }
    
    func setArray(){
        var scViews = [UIView]()
        
        if mainUiViewArray.count > 1{
            
            if let last = videoArray.last {
                let url = "https://img.youtube.com/vi/\(last.url.getYoutubeID())/sddefault.jpg"
                let sliderView = SlideShowUiView.create(frame: self.ViewFrame,url: url , title: last.title)
                sliderView.playImage.isHidden = isShowPlayButton
                sliderView.clickButton.addTarget(self, action: #selector(self.onButtonClick), for: .touchUpInside)
                scViews.append(sliderView)
            }
            
            scViews += mainUiViewArray
            
            if adsIsShow{
                let adsView = SliderNativeExpressAdsUIView.create(frame: self.ViewFrame)
                adsView.nativeExpressAdsView.rootViewController = rootViewController
                scViews.append(adsView)
                
            }else if let first = videoArray.first {
                var url = "https://img.youtube.com/vi/\(first.url.getYoutubeID())/sddefault.jpg"
                let sliderView = SlideShowUiView.create(frame: self.ViewFrame,url: url, title: first.title)
                sliderView.playImage.isHidden = isShowPlayButton
                sliderView.clickButton.addTarget(self, action: #selector(self.onButtonClick), for: .touchUpInside)
                scViews.append(sliderView)
            }
            self.customViewArray = scViews
            
            reloadScrollView()
            setTimerIfNeeded()
        }else{
            self.customViewArray = mainUiViewArray
        }
    }
    
    func reloadScrollView() {
        
        var count = -1
        for uiView in customViewArray {
            count += 1
            viewStackView.addArrangedSubview(uiView)
        }
        
        customScrollView.contentSize = CGSize(width: (customScrollView.getWidth) * CGFloat(count) , height: customScrollView.frame.height)
        
        count += 1
        if customViewArray.count > 1{
            scrollViewPage = 1
            customScrollView.scrollRectToVisible(CGRect(x: customScrollView.getWidth, y: 0, width: customScrollView.frame.size.width, height: customScrollView.frame.size.height), animated: false)
        } else {
            scrollViewPage = 0
        }
    }
    
    func setTimerIfNeeded() {
        if slideshowInterval > 0 && customViewArray.count > 1 && moveTimer == nil {
            moveTimer = Timer.scheduledTimer(timeInterval:slideshowInterval, target: self, selector: #selector(self.setScrollView), userInfo: nil, repeats: true)
        }
    }
    
    func setScrollView(){
        
        let page = Int(customScrollView.contentOffset.x / customScrollView.frame.size.width)
        var nextPage = page + 1
        
        if  page == customViewArray.count - 1 {
            nextPage = 0
        }
        self.customScrollView.scrollRectToVisible(CGRect(x: customScrollView.frame.size.width * CGFloat(nextPage), y: 0, width: customScrollView.frame.size.width, height: customScrollView.frame.size.height), animated: true)
        
        self.setCurrentPageForScrollViewPage(nextPage)
    }
    
    func setCurrentPageForScrollViewPage(_ page: Int) {
        scrollViewPage = page
        if page == 0 {
            // first page contains the last image
            currentPage = Int(mainUiViewArray.count) - 1
        } else if page == customViewArray.count - 1 {
            // last page contains the first image
            currentPage = 0
        } else {
            currentPage = page - 1
        }
        //        print("page = \(page) , currentPage = \(currentPage)")
        pageControll.currentPage = currentPage
        setUIView()
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if moveTimer?.isValid != nil {
            moveTimer?.invalidate()
            moveTimer = nil
        }
        setTimerIfNeeded()
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        setCurrentPageForScrollViewPage(page);
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if mainUiViewArray.count > 1{
            let regularContentOffset = scrollView.frame.size.width * CGFloat(mainUiViewArray.count)
            
            if (scrollView.contentOffset.x >= (scrollView.frame.size.width * CGFloat(mainUiViewArray.count + 1))) {
                scrollView.contentOffset = CGPoint(x: scrollView.contentOffset.x - regularContentOffset, y: 0)
            } else if (scrollView.contentOffset.x <= 0) {
                scrollView.contentOffset = CGPoint(x: scrollView.contentOffset.x + regularContentOffset, y: 0)
            }
        }
    }
}

protocol scrollViewUIViewType {
    static func create(frame : CGRect, trailerAndFeaturedArray : [Video] , isShowPlayButton : Bool, adsIsShow : Bool , rootViewController : UIViewController) -> scrollViewUIView
    func getUIView() -> UIView
    func didInit()
}
