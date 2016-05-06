//
//  HomeTableViewCell.swift
//  ZL音乐播放
//
//  Created by dcj on 16/4/27.
//  Copyright © 2016年 YQ. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell {

    var userImageView : UIImageView?
    var nameLabel : UILabel?
    var singerNameLabel : UILabel?
    var isNowLisk : Bool = false
    
    
    lazy var link:CADisplayLink = {
    
        let zlink = CADisplayLink(target: self, selector: #selector(HomeTableViewCell.update));
        return zlink;
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = UIColor.whiteColor();
//        NSNotificationCenter.defaultCenter().removeObserver(self, name: "pauseOrPlayLinkCircle", object: nil)
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(pauseOrPlayLinkCircle), name: "pauseOrPlayLinkCircle", object: nil)
        
        //图片
        self.userImageView = UIImageView(frame:CGRectMake(5, 5, 70, 70));
        self.userImageView?.layer.cornerRadius = 35;
        self.userImageView?.contentMode = UIViewContentMode.ScaleAspectFill; 
        self.userImageView?.layer.masksToBounds = true;
        self.userImageView?.backgroundColor = UIColor.greenColor();
        self.contentView.addSubview(self.userImageView!);
        
        //歌名字 
        self.nameLabel = UILabel(frame:CGRectMake(CGRectGetMaxX((self.userImageView?.frame)!)+5, 17, 150, 20));
        self.nameLabel?.text = "枉凝眉";
        self.nameLabel?.textColor = UIColor.redColor();
        self.contentView.addSubview(self.nameLabel!);
        
        
        //歌手名字 
        self.singerNameLabel = UILabel(frame:CGRectMake(CGRectGetMaxX((self.userImageView?.frame)!)+5, CGRectGetMaxY(self.nameLabel!.frame)+5, 150, 20));
        self.singerNameLabel?.text = "枉凝眉";
        self.singerNameLabel?.font = UIFont.systemFontOfSize(15.0);
        self.singerNameLabel?.textColor = UIColor.redColor();
        self.contentView.addSubview(self.singerNameLabel!);
        
    }
    func createCellWithData(song:Sone) -> Void {
        self.backgroundColor = UIColor.whiteColor();
        self.nameLabel?.textColor = UIColor.redColor();
        self.singerNameLabel?.textColor = UIColor.redColor();

        self.userImageView?.image = UIImage(named: song.sinegerIcon!);
        self.nameLabel?.text = song.name;
        self.singerNameLabel?.text = song.sinegerName;
        
        updateSomeStatus(song)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update() -> Void {
        let angle = self.link.duration * M_PI_4;
        self.userImageView!.transform = CGAffineTransformRotate(self.userImageView!.transform,CGFloat(angle));
    }
    
    func updateSomeStatus(song:Sone) {
        update()
        if song.playing {
            //self.link = CADisplayLink(target: self, selector: #selector(HomeTableViewCell.update));
            self.backgroundColor = UIColor.init(red: 205/255.0,green: 205/255.0,blue: 205/255.0,alpha: 1);
            
            self.nameLabel?.textColor = UIColor.greenColor();
            self.singerNameLabel?.textColor = UIColor.greenColor();
            
            self.link.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSDefaultRunLoopMode)
            isNowLisk = true;
        }else{
            // 如果模型的isPlaying为假,则停止时钟动画,并将CGAffineTransformRotate归零
            //self.link.invalidate();
            if isNowLisk {
                self.link.removeFromRunLoop(NSRunLoop.mainRunLoop(), forMode: NSDefaultRunLoopMode)
                isNowLisk = false;
            }
            self.userImageView!.transform = CGAffineTransformIdentity;
        }
    }
    
    func pauseOrPlayLinkCircle(notify:NSNotification) -> Void {
        let string:NSString = notify.object as! String 
        
        if string.isEqualToString("0") {
            self.link.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSDefaultRunLoopMode)

        }else if string.isEqualToString("1") {
           // self.link.removeFromRunLoop(NSRunLoop.mainRunLoop(), forMode: NSDefaultRunLoopMode)
            self.userImageView!.transform = CGAffineTransformIdentity;

        }
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
