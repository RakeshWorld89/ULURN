//
//  LectureVideoPlayerViewController.swift
//  ULURN
//
//  Created by Rakesh Chakraborty on 25/05/24.
//

import UIKit
import AVKit

class LectureVideoPlayerViewController: AVPlayerViewController, AVPlayerViewControllerDelegate {

    var lectureURL: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // guard let path = Bundle.main.path(forResource: "SampleVideo", ofType:"mp4") else { return }
        self.player = AVPlayer(url: URL(string: lectureURL!)!)
        self.player?.play() // Optionally autoplay the video when it starts
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
}
