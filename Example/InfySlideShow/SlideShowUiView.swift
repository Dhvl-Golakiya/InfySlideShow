//
//  SlideShowUiView.swift
//  BollyNxt
//
//  Created by Dhvl Golakiya on 11/03/17.
//  Copyright © 2017 infyom. All rights reserved.
//

import UIKit

class SlideShowUiView: UIView ,SlideShowUiViewType {
    
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var playImage: UIImageView!
    @IBOutlet weak var clickButton: UIButton!
    @IBOutlet weak var clickButtonView: UIView!
    
    @IBOutlet weak var backView: UIView!
    
    var ViewFrame : CGRect!
    var url = ""
    var title = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    static func create(frame: CGRect, url: String, title: String) -> SlideShowUiView {
        let slideShowView =  Bundle.main.loadNibNamed("SlideShowUiView", owner: self, options: nil)?[0] as! SlideShowUiView
        slideShowView.ViewFrame = frame
        slideShowView.url = url
        slideShowView.title = title
        slideShowView.didInit()
        return slideShowView
    }
    
    func didInit() {
        self.frame = self.ViewFrame
        backView.frame = self.ViewFrame
        
        print(url)
        movieImageView.kf.setImage(with: URL(string: url.convertslash()), placeholder: nil, options: nil, progressBlock: nil, completionHandler: nil)
        
        movieImageView.frame = self.ViewFrame
    }
    func getUIView() -> UIView {
        return self
    }
}

protocol SlideShowUiViewType {
    static func create(frame : CGRect, url : String ,title : String) -> SlideShowUiView
    func getUIView() -> UIView
    func didInit()
}
