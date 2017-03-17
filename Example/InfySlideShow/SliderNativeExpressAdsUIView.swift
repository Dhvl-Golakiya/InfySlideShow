//
//  SliderNativeExpressAdsUIView.swift
//  BollyNxt
//
//  Created by Dhvl Golakiya on 15/03/17.
//  Copyright © 2017 infyom. All rights reserved.
//

import UIKit
import GoogleMobileAds

class SliderNativeExpressAdsUIView: UIView ,BigNativeExpressAd{
    
    @IBOutlet weak var nativeExpressAdsView: GADNativeExpressAdView!
    var ViewFrame : CGRect!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Protocol methods
    
    static func create(frame : CGRect) -> SliderNativeExpressAdsUIView  {
        let adsView =  Bundle.main.loadNibNamed("SliderNativeExpressAdsUIView", owner: self, options: nil)?[0] as! SliderNativeExpressAdsUIView
        adsView.ViewFrame = frame
        adsView.didInit()
        return adsView
    }
    
    func didInit() {
        self.frame = self.ViewFrame
        
        nativeExpressAdsView.adUnitID = AdsConstants.CATEGORY_LIST_NATIVE
        let req = GADRequest()
        req.testDevices = Constants.testDevices
        nativeExpressAdsView.load(req)
    }
    
    func getUIView() -> UIView {
        return self
    }
}

protocol BigNativeExpressAd {
    static func create(frame : CGRect) -> SliderNativeExpressAdsUIView
    func getUIView() -> UIView
    func didInit()
}
