//
//  HomeViewController.swift
//  UbiqComp
//
//  Created by Yassin Mziya on 11/26/18.
//  Copyright © 2018 Yassin Mziya. All rights reserved.
//

import UIKit
import AVFoundation



class HomeViewController: UIViewController {
    
    var timer: Timer!
    var range: Range<Int> = 66..<70
    
    var playPauseButton: UIButton!
    var heartRateLabel: UILabel!
    var heartRateUnitsLabel: UILabel!
    
    var audioPlayer = AVAudioPlayer()
    var isPlayingAudio = false {
        didSet {
            if isPlayingAudio {
                playPauseButton.setImage(UIImage(named: "play-icon"), for: .normal)
                range = 66..<70
                pause()
            } else {
                playPauseButton.setImage(UIImage(named: "pause-icon"), for: .normal)
                range = 72..<76
                play()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        HealthKitManager.sharedInstance.authorizeHealthKit { (success, error) in
            print("Was health kit succeful? \(success)")
        }
        
        navigationController?.isNavigationBarHidden = true
        
        setupAudioPlayer()
        playPauseButton = UIButton()
        playPauseButton.setImage(UIImage(named: "play-icon"), for: .normal)
        playPauseButton.imageView?.contentMode = .scaleToFill
        playPauseButton.translatesAutoresizingMaskIntoConstraints = false
        playPauseButton.addTarget(self, action: #selector(playPauseTapped), for: .touchUpInside)
        view.addSubview(playPauseButton)

        heartRateLabel = UILabel()
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(updateHeartRateLabel), userInfo: nil, repeats: true)
        
        timer.fire()

        heartRateLabel.textAlignment = .center
        heartRateLabel.textColor = .white
        heartRateLabel.font = UIFont.systemFont(ofSize: 80, weight: .bold)
        heartRateLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(heartRateLabel)
        
        heartRateUnitsLabel = UILabel()
        heartRateUnitsLabel.textAlignment = .center
        heartRateUnitsLabel.text = "BPM"
        heartRateUnitsLabel.textColor = .white
        heartRateUnitsLabel.font = UIFont.systemFont(ofSize: 22)
        heartRateUnitsLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(heartRateUnitsLabel)
        
        setupConstraints()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        timer.invalidate()
    }
    
    @objc func updateHeartRateLabel() {
        self.heartRateLabel.text = "\(Int.random(in: self.range))"
    }
    
    func setupConstraints() {
//        heartRateLabel.snp.makeConstraints { make in
//            make.centerY.equalToSuperview().offset(-16)
//            make.centerX.equalToSuperview()
//        }
//
//        heartRateUnitsLabel.snp.makeConstraints { make in
//            make.centerX.equalTo(heartRateLabel)
//            make.top.equalTo(heartRateLabel.snp.bottom).offset(4)
//        }
        NSLayoutConstraint.activate([
            playPauseButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            playPauseButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            playPauseButton.heightAnchor.constraint(equalToConstant: 72),
            playPauseButton.widthAnchor.constraint(equalToConstant: 72)
            ])
        
        NSLayoutConstraint.activate([
            heartRateLabel.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: -16),
            heartRateLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
            ])
        
        NSLayoutConstraint.activate([
            heartRateUnitsLabel.centerXAnchor.constraint(equalTo: heartRateLabel.centerXAnchor),
            heartRateUnitsLabel.topAnchor.constraint(equalTo: heartRateLabel.bottomAnchor, constant: 4)
            ])
    }
    
    func setupAudioPlayer() {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "sample", ofType: "m4a")!))
            audioPlayer.prepareToPlay()
        } catch {
            print(error)
        }
    }
    
    func play() {
        audioPlayer.play()
    }
    
    func pause() {
        if audioPlayer.isPlaying {
            audioPlayer.pause()
        }
    }
    
    @objc func playPauseTapped() {
        isPlayingAudio = !isPlayingAudio
    }
}
