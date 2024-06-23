//
//  LectureVideoPlayerViewController.swift
//  ULURN
//
//  Created by Rakesh Chakraborty on 25/05/24.
//

import UIKit
import AVKit

class LectureVideoPlayerViewController: AVPlayerViewController, AVPlayerViewControllerDelegate, UIViewControllerTransitioningDelegate {

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var lectureURL: String?
    var currentLectureId: Int?
    var remainingDuration: Double = 0.0
    var totalDuration: Double = 0.0
    var totalRemainingDurationOfLecture: Int = 0
    var durationTimer: Timer?
    var unixTimeStamp: Int = 0
    var chapterDetailsVCDelegate: ChapterDetailsViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // guard let path = Bundle.main.path(forResource: "SampleVideo", ofType:"mp4") else { return }
        self.appDelegate.orientation = .landscape
        UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue, forKey: "orientation")
        self.transitioningDelegate = self
        
        self.player = AVPlayer(url: URL(string: lectureURL!)!)
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlayingLecture), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.player?.currentItem)
        self.player?.play() // Optionally autoplay the video when it starts
        unixTimeStamp = Date().unixTimestamp
        
        durationTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            self?.remainingDuration -= 1.0
            print(self?.remainingDuration)
            if self?.remainingDuration == 0 {
                self?.durationTimer?.invalidate()
                if self?.player?.timeControlStatus == .playing {
                    self?.player?.pause()
                    self?.calculateRemainingLectureDuration()
                    self?.resetOrientation()
                    self?.dismiss(animated: true)
                }
            }
        }
    }
    
    override var shouldAutorotate: Bool {
        return false
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeRight
    }

    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .landscapeRight
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @objc func playerDidFinishPlayingLecture(note: NSNotification) {
        resetOrientation()
        calculateRemainingLectureDuration()
        self.dismiss(animated: true)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        // The dismissal was before the movie ended
        resetOrientation()
        print("AVPlayerController dismissed")
        calculateRemainingLectureDuration()
        
        return nil
    }
    
    func resetOrientation() {
        self.appDelegate.orientation = .portrait
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
    }
    
    func calculateRemainingLectureDuration() {
        totalRemainingDurationOfLecture = (Int(totalDuration) - Int((self.player?.currentTime().seconds)!))
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        durationTimer?.invalidate()
        var currentlyPlayedLectureDetails: [String: Any] = [:]
        currentlyPlayedLectureDetails["remainingDuration"] = self.remainingDuration
        currentlyPlayedLectureDetails["lectureRemainingDuration"] = self.totalRemainingDurationOfLecture
        currentlyPlayedLectureDetails["lecturePlayTime"] = self.unixTimeStamp
        self.chapterDetailsVCDelegate?.isLecturePlayed = true
        self.chapterDetailsVCDelegate?.workWithLastLectureHistoryDetails(lectureHistory: currentlyPlayedLectureDetails)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.player?.currentItem)
    }
}
