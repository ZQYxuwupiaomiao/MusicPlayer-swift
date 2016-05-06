//
//  SongTool.swift
//  ZL音乐播放
//
//  Created by dcj on 16/4/27.
//  Copyright © 2016年 YQ. All rights reserved.
//

import UIKit
import AVFoundation

class SongTool: NSObject {

     var _audioPlayerDict:Dictionary<String,AVAudioPlayer > = [:]
    
    override init() {
        super.init()
        setupForBackgroundPlay()

    }
    func setupForBackgroundPlay(){
        //加入这句话才可以后台连续播放
        UIApplication.sharedApplication().beginReceivingRemoteControlEvents();
        
        try! AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord)
        try! AVAudioSession.sharedInstance().setActive(true)
    }
    
    internal func playMusic(fileName:String) -> AVAudioPlayer {
        
        var audioPlayer = AVAudioPlayer();
        
        //let url = NSBundle.mainBundle().URLForResource(fileName as String, withExtension: nil);
        
        if _audioPlayerDict[fileName] != nil{
            audioPlayer = _audioPlayerDict[fileName]!
        }else{
            try! audioPlayer = AVAudioPlayer.init(contentsOfURL: NSURL.fileURLWithPath(fileName));
            _audioPlayerDict[fileName] = audioPlayer
        }
        audioPlayer.prepareToPlay();

        if !audioPlayer.playing {
            audioPlayer.play();
        }
        
        return audioPlayer;
    }
    
    internal func pauseMusic(fileName:String){
        let audioPlayer = _audioPlayerDict[fileName];
        if audioPlayer!.playing {
            audioPlayer!.pause();
        }
    }
    
    internal func stopMusic(fileName:String){
        
        var audioPlayer = AVAudioPlayer();
        if _audioPlayerDict[fileName] != nil{
            audioPlayer = _audioPlayerDict[fileName]!
        }else{
            try! audioPlayer = AVAudioPlayer.init(contentsOfURL: NSURL.fileURLWithPath(fileName));
        }
        //let url = NSBundle.mainBundle().URLForResource(fileName as String, withExtension: nil);
        if audioPlayer.playing {
            audioPlayer.stop();
           _audioPlayerDict.removeValueForKey(fileName);
        }
    }
    
//    func currentPlayingAudioPlay() -> AVAudioPlayer {
//        function body
//    }
}











