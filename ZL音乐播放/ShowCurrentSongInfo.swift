//
//  ShowCurrentSongInfo.swift
//  ZL音乐播放
//
//  Created by dcj on 16/5/5.
//  Copyright © 2016年 YQ. All rights reserved.
//

import UIKit

protocol pauseOrPlayProtocol {
    func playMusic()
    func pauseMusic()
}

class ShowCurrentSongInfo: UIView {

    var progress:UIProgressView?
    var userImageView : UIImageView?
    var nameLabel : UILabel?
    var singerNameLabel : UILabel?
    var pauseOrPlayButton : UIButton?
    
    var delegate: pauseOrPlayProtocol?
    
    var song:Sone = Sone(){
    
        didSet{
            self.userImageView?.image = UIImage(named: song.sinegerIcon!);
            self.nameLabel?.text = song.name;
            self.singerNameLabel?.text = song.sinegerName;
            self.pauseOrPlayButton?.setTitle("暂停", forState: UIControlState.Normal)
        }
    
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.frame = frame
        self.backgroundColor = UIColor.whiteColor()
        self.userInteractionEnabled = true
        self.progress = UIProgressView.init(progressViewStyle: UIProgressViewStyle.Default)
        progress!.frame=CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, 2);
        
        progress?.trackTintColor = UIColor.blackColor()
        progress?.progressTintColor = UIColor.redColor()
        progress?.setProgress(0.0, animated: true)
        self.addSubview(progress!)

        //图片
        self.userImageView = UIImageView(frame:CGRectMake(0, 2, 68, 68));
        self.userImageView?.contentMode = UIViewContentMode.ScaleAspectFill; 
        self.userImageView?.layer.masksToBounds = true;
        self.userImageView?.backgroundColor = UIColor.greenColor();
        self.addSubview(self.userImageView!);
        
        //歌名字 
        self.nameLabel = UILabel(frame:CGRectMake(CGRectGetMaxX((self.userImageView?.frame)!)+5, 12, 150, 20));
        self.singerNameLabel?.font = UIFont.systemFontOfSize(15.0);
        self.nameLabel?.textColor = UIColor.redColor();
        self.addSubview(self.nameLabel!);
        
        
        //歌手名字 
        self.singerNameLabel = UILabel(frame:CGRectMake(CGRectGetMaxX((self.userImageView?.frame)!)+5, CGRectGetMaxY(self.nameLabel!.frame)+5, 150, 20));
        self.singerNameLabel?.font = UIFont.systemFontOfSize(13.0);
        self.singerNameLabel?.textColor = UIColor.redColor();
        self.addSubview(self.singerNameLabel!);
        
        //暂停或播放
        self.pauseOrPlayButton = UIButton.init(type: UIButtonType.Custom)
        self.pauseOrPlayButton?.frame = CGRectMake(UIScreen.mainScreen().bounds.size.width/2+20, 0, 40, 70)
        self.pauseOrPlayButton?.setTitle("播放", forState: UIControlState.Normal)
        self.pauseOrPlayButton?.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        self.pauseOrPlayButton?.addTarget(self, action: #selector(pauseOrPlayButtonClick), forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(self.pauseOrPlayButton!)
    }
    
    func pauseOrPlayButtonClick(button:UIButton) -> Void {
        
        button.selected = !button.selected

        if button.selected {
            self.pauseOrPlayButton?.setTitle("播放", forState: UIControlState.Normal)
            delegate?.pauseMusic()

        }else{
            self.pauseOrPlayButton?.setTitle("暂停", forState: UIControlState.Normal)
            delegate?.playMusic()
        }

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
