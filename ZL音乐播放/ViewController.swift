//
//  ViewController.swift
//  ZL音乐播放
//
//  Created by dcj on 16/4/27.
//  Copyright © 2016年 YQ. All rights reserved.
//

import UIKit
import MediaPlayer

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,AVAudioPlayerDelegate,pauseOrPlayProtocol{
    
    var showCurrentSong:ShowCurrentSongInfo?//底部的view
    
    var currentIndexPath:NSIndexPath?
    
    
    private let headCellId = "HomeTopTableViewCell"

    var isFirstCell:Bool = false//看是否需要手动deSelect
    
    @IBOutlet weak var tableView: UITableView!
    lazy var songArray = [Sone]();//存放歌曲的数组
    
    lazy var link:CADisplayLink = {
        //实时监听歌曲的播放进度
        let link = CADisplayLink.init(target: self, selector: #selector(ViewController.update));        
        
        return link;
        
    }()
    
    lazy var songTool:SongTool = {
    
        let songTool = SongTool()
        return songTool;
        
    }()
    var currentPlayingAudioPlayer = AVAudioPlayer();//播放器
    
    override func viewDidLoad() {
        super.viewDidLoad()
                        
        initSomeData();//初始化歌曲数据
        
        createTableView()//创建tableView
        
    }

    func initSomeData(){
        if let bundlePath = NSBundle.mainBundle().pathForResource("MusicInfo", ofType: "plist") {
            let resultDictionary = NSDictionary(contentsOfFile: bundlePath)
            
            let infoArray = NSArray().arrayByAddingObjectsFromArray((resultDictionary?.objectForKey("musicInfo"))! as! [AnyObject]);
            
            
            for i in 1...infoArray.count {
                let infoDic = NSDictionary(dictionary:infoArray[i-1] as! [NSObject : AnyObject])
                
                let fileStr = NSBundle.mainBundle().pathForResource(infoDic.objectForKey("name") as? String , ofType: "mp3");
                
                let song = Sone();
                song.name = infoDic.objectForKey("name") as? String;
                song.fileName = fileStr;
                song.sinegerIcon = infoDic.objectForKey("pic") as? String;
                song.playing = false;
                song.sinegerName = infoDic.objectForKey("singerName") as? String;
                self.songArray.append(song);
            }
            
        }
        
    }
    
    func createTableView() {
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        
        self.tableView.registerClass(HomeTableViewCell.self, forCellReuseIdentifier: headCellId)//注册cell
        
        self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0); 
        
        let footView = UIView.init(frame: CGRectMake(0, 0, self.view.frame.size.width, 50))
        footView.backgroundColor = UIColor.whiteColor()
        self.tableView.tableFooterView = footView;
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: AVAudioPlayer代理方法
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        let selectedPath = self.tableView.indexPathForSelectedRow;
        var nextRow = (selectedPath?.row)!+1;
        if nextRow == self.songArray.count {
            nextRow = 0;
            isFirstCell = true
            self.tableView.contentOffset = CGPointMake(0, -20);
        }
        
        //停止转圈
        let song = self.songArray[selectedPath!.row];
        let cell = tableView.cellForRowAtIndexPath(selectedPath!) as! HomeTableViewCell;
        song.playing = false;
        cell.createCellWithData(song);

        
        //播放下一首
        let nextPath = NSIndexPath(forRow:nextRow ,inSection: (selectedPath?.section)!);
        
         
        self.tableView.selectRowAtIndexPath(nextPath, animated: true, scrollPosition: UITableViewScrollPosition.Top)
      
        self.tableView(self.tableView, didSelectRowAtIndexPath: nextPath);
    }

    //  音乐播放器被打断 (如开始 打、接电话)
    func audioPlayerBeginInterruption(player: AVAudioPlayer) {
        //
    }
    //  音乐播放器打断终止 (如结束 打、接电话)
    func audioPlayerEndInterruption(player: AVAudioPlayer) {
        player.play();
    }
    func update() -> Void {

        showCurrentSong?.progress?.progress = Float(self.currentPlayingAudioPlayer.currentTime)/Float(self.currentPlayingAudioPlayer.duration)
    }
    
    //MARK: 点击播放活着暂停代理

    func pauseMusic() {
        
        //暂停
        songTool.pauseMusic((showCurrentSong?.song.fileName)!)
        
        let cellRect = self.tableView.rectForRowAtIndexPath(currentIndexPath!)
        if ((cellRect.origin.y - self.tableView.contentOffset.y > self.tableView.bounds.size.height) || (cellRect.origin.y + 80.0 < self.tableView.contentOffset.y)){
            
            //self.tableView.reloadData()
        }else{
        
            let music = self.songArray[currentIndexPath!.row];
            music.playing = false
            let cell:HomeTableViewCell! = tableView.cellForRowAtIndexPath(currentIndexPath!) as? HomeTableViewCell;
            cell.createCellWithData(music);
        }
    }
    
    func playMusic() {
        //播放
        songTool.playMusic((showCurrentSong?.song.fileName)!)

        let cellRect = self.tableView.rectForRowAtIndexPath(currentIndexPath!)
        if ((cellRect.origin.y - self.tableView.contentOffset.y > self.tableView.bounds.size.height) || (cellRect.origin.y + 80.0 < self.tableView.contentOffset.y)){
            
            //self.tableView.reloadData()
        }else{
            let music = self.songArray[currentIndexPath!.row];
            music.playing = true
            let cell:HomeTableViewCell! = tableView.cellForRowAtIndexPath(currentIndexPath!) as? HomeTableViewCell;
            cell.createCellWithData(music);
        
        }

        
    }
    
    //MARK: tableView代理方法
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.songArray.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:HomeTableViewCell! = tableView.dequeueReusableCellWithIdentifier(headCellId, forIndexPath: indexPath) as? HomeTableViewCell

        if cell == nil {
            cell = HomeTableViewCell(style: UITableViewCellStyle.Default,reuseIdentifier: headCellId)
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        let song = self.songArray[indexPath.row];
        
        cell.createCellWithData(song);
        return cell;
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        currentIndexPath = indexPath
        let music = self.songArray[indexPath.row];
        if music.playing {
            return;
        }
        music.playing = true;
        
        //显示底部的视图
        if (showCurrentSong == nil) {
            showCurrentSong = ShowCurrentSongInfo.init(frame: CGRectMake(0, UIScreen.mainScreen().bounds.size.height-70, UIScreen.mainScreen().bounds.size.width, 70))
            showCurrentSong?.delegate = self
            self.view.addSubview(showCurrentSong!)
        }
        showCurrentSong?.song = music
        
        
        // 传递数据源模型 给工具类播放音乐
        //        let fileStr = NSBundle.mainBundle().pathForResource("", ofType: "mp3");
        let audioPlayer = songTool.playMusic(music.fileName!) ;
        audioPlayer.delegate = self;
        self.currentPlayingAudioPlayer = audioPlayer;
        
        //锁屏显示 
        showInfoLockedScreen(music);
        
        self.link.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSDefaultRunLoopMode)
    
        let cellRect = self.tableView.rectForRowAtIndexPath(indexPath)
        if ((cellRect.origin.y - self.tableView.contentOffset.y > self.tableView.bounds.size.height) || (cellRect.origin.y + 80.0 < self.tableView.contentOffset.y)){
            //判断是否在屏幕之内
            if indexPath.row == 0{
                //isFirstCell = true
            }
        }else{
                //isFirstCell = true
            let cell:HomeTableViewCell! = tableView.cellForRowAtIndexPath(indexPath) as? HomeTableViewCell;
            cell.createCellWithData(music);
        }
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80;
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        self.link.removeFromRunLoop(NSRunLoop.mainRunLoop(), forMode: NSDefaultRunLoopMode)

        let music = self.songArray[indexPath.row];
        music.playing = false;
        songTool.stopMusic(music.fileName!) 
        
        
        let cellRect = self.tableView.rectForRowAtIndexPath(indexPath)
        if ((cellRect.origin.y - self.tableView.contentOffset.y > self.tableView.bounds.size.height) || (cellRect.origin.y + 80.0 < self.tableView.contentOffset.y)){
            if isFirstCell {
                let cell:HomeTableViewCell! = tableView.cellForRowAtIndexPath(NSIndexPath(forRow:0 ,inSection: 0)) as? HomeTableViewCell;
                cell.createCellWithData(music);
                isFirstCell = false
            }
        }else{
            if isFirstCell {
                let cell:HomeTableViewCell! = tableView.cellForRowAtIndexPath(NSIndexPath(forRow:0 ,inSection: 0)) as? HomeTableViewCell;
                cell.createCellWithData(music);
                isFirstCell = false
            }else{
                let cell:HomeTableViewCell! = tableView.cellForRowAtIndexPath(indexPath) as? HomeTableViewCell;
                cell.createCellWithData(music);

            }
        }

    }

    
    //MARK: 锁屏显歌词
    // 在锁屏界面显示歌曲信息(实时换图片MPMediaItemArtwork可以达到实时换歌词的目的)
    
    func showInfoLockedScreen(song:Sone) {
        // 健壮性写法:如果存在这个类,才能在锁屏时,显示歌词
        if (NSClassFromString("MPNowPlayingInfoCenter") != nil) {
            var info = Dictionary<String,AnyObject>();
            info[MPMediaItemPropertyTitle] = song.name;
            info[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(image: UIImage(named: song.sinegerIcon!)!);
            MPNowPlayingInfoCenter.defaultCenter().nowPlayingInfo = info;
        }
    }
}

