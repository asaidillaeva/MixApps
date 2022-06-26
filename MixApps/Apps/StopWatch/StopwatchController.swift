//
//  StopWatchViewController.swift
//  MixApps
//
//  Created by Aliia Saidillaeva  on 25/6/22.
//


import UIKit
import AVFoundation

class StopwatchController: UIViewController {
    
    private var timerLabel: UILabel = {
        var label = UILabel()
        label.text = "00:00:00"
        label.font = .systemFont(ofSize: 70)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var image: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "stopwatch")
        image.tintColor = .black
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var stopButton: Button = {
        var btn = Button()
        btn.tintColor = .black
        btn.setBackgroundImage(UIImage(systemName: "stop.circle.fill"), for: .normal)
        btn.addTarget(self, action: #selector(stop), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.contentMode = .scaleAspectFill
        return btn
    }()

    private lazy var pauseButton: Button = {
        var btn = Button()
        btn.tintColor = .black
        btn.setBackgroundImage(UIImage(systemName: "pause.circle.fill"), for: .normal)
        btn.addTarget(self, action: #selector(pause), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.contentMode = .scaleAspectFill
        return btn
    }()
    
    private lazy var playButton: Button = {
        var btn = Button()
        btn.tintColor = .black
        btn.setBackgroundImage(UIImage(systemName: "play.circle.fill"), for: .normal)
        btn.addTarget(self, action: #selector(play), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.contentMode = .scaleAspectFill
        return btn
    }()

    private let picker: UIPickerView = {
       var picker = UIPickerView()
        picker.contentMode = .scaleToFill
        picker.contentMode = .center
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()

    private lazy var segmentedControl: UISegmentedControl = {
       let control = UISegmentedControl()
        control.insertSegment(withTitle: "Timer", at: 0, animated: true)
        control.insertSegment(withTitle: "StopWatch", at: 1, animated: true)
        control.addTarget(self, action: #selector(segmentClick), for: .valueChanged)
        control.translatesAutoresizingMaskIntoConstraints = false
        control.tintColor = .black
        control.contentMode = .center
        return control
    }()
    
    private var isGoingOn = false {
        didSet {
            [playButton, stopButton, pauseButton].forEach { $0?.bool = isGoingOn}
        }
    }
    private var isTimer = true
    private var timer: Timer = Timer()
    private var count: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        picker.delegate = self
        reset()
    }
    
    private func setup(){
        setupSubviews()
        setupConstraints()
    }
    
    private func setupSubviews() {
        view.backgroundColor = .systemYellow
        segmentedControl.selectedSegmentIndex = 0
        picker.isHidden = true
        view.addSubview(image)
        view.addSubview(segmentedControl)
        view.addSubview(timerLabel)
        view.addSubview(picker)
        view.addSubview(stopButton)
        view.addSubview(pauseButton)
        view.addSubview(playButton)
        
    }
    
    private func setupConstraints() {
        let constraints = [
            image.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -150),
            image.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            image.heightAnchor.constraint(equalToConstant: 80),
            image.widthAnchor.constraint(equalToConstant: 80),
            
            segmentedControl.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 10),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            
            timerLabel.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 15),
            timerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            timerLabel.heightAnchor.constraint(equalToConstant: 60),
            
            picker.topAnchor.constraint(equalTo: timerLabel.bottomAnchor, constant: 10),
            picker.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            picker.heightAnchor.constraint(equalToConstant: 90),
            
            stopButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -100),
            stopButton.topAnchor.constraint(equalTo: picker.bottomAnchor, constant: 10),
            stopButton.heightAnchor.constraint(equalToConstant: 80),
            stopButton.widthAnchor.constraint(equalToConstant: 80),
            
            pauseButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pauseButton.topAnchor.constraint(equalTo: picker.bottomAnchor, constant: 10),
            pauseButton.heightAnchor.constraint(equalToConstant: 80),
            pauseButton.widthAnchor.constraint(equalToConstant: 80),
            
            playButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 100),
            playButton.topAnchor.constraint(equalTo: picker.bottomAnchor, constant: 10),
            playButton.heightAnchor.constraint(equalToConstant: 80),
            playButton.widthAnchor.constraint(equalToConstant: 80),

        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    @objc func segmentClick() {
        isTimer = segmentedControl.selectedSegmentIndex == 0
        picker.isHidden = segmentedControl.selectedSegmentIndex == 0
        reset()
    }
    
    @objc func stop() {
        reset()
    }
    
    @objc func pause() {
        if !isGoingOn {
            return
        }
        timer.invalidate()
        toggle()
    }
    
    @objc func play() {
        if isGoingOn {
            return
        }
        toggle()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        if !isTimer {
            picker.isHidden = true
        }
    }
    
    @objc func updateTimer() -> Void{
        if count == 0 && !isTimer {
            UIDevice.vibrate()
            reset()
            return
        }
        count = isTimer ? count + 1 : count - 1
        timerLabel.text = secondsToString(seconds: count)
    }
    
    func reset(){
        isGoingOn = false
        timerLabel.text = "00:00:00"
        timer.invalidate()
        count = 0
        
        let strs = ["play.circle", "pause.circle"]
        [playButton, pauseButton].enumerated().forEach { index, button in
            button.bool = isGoingOn
            button ++ (strs[index], strs[index] + ".fill")
        }
        
        if !isTimer {
            picker.isHidden = false
            picker.selectRow(0, inComponent:0, animated: true)
            picker.selectRow(0, inComponent:1, animated: true)
            picker.selectRow(0, inComponent:2, animated: true)
        }
    }
    
   
    func secondsToString(seconds: Int) -> (String){
        var timeStr = ""
        timeStr.append( String(format: "%02d", (seconds/3600)) + ":")
        timeStr.append( String(format: "%02d", (seconds%3600)/60) + ":")
        timeStr.append( String(format: "%02d", (seconds%3600)%60) )
        
        return timeStr
    }
    
    private func toggle(){
        isGoingOn.toggle()
        playButton.bool = isGoingOn
        pauseButton.bool = !isGoingOn
        playButton ++ ("play.circle", "play.circle.fill")
        pauseButton ++ ("pause.circle", "pause.circle.fill")
    }
    
}

class Button: UIButton {
    var bool = false
}

infix operator ++
extension Button {
    static func ++ (lhs: Button, rhs: (String, String)) {
        lhs.setBackgroundImage(.init(systemName: lhs.bool ? rhs.0 : rhs.1), for: .normal)
    }
}


extension StopwatchController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return 24
        case 1, 2:
            return 60
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return pickerView.frame.size.width/3
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return "\(row)"
        case 1:
            return "\(row)"
        case 2:
            return "\(row)"
        default:
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            count = row*3600
        case 1:
            count = row*60
        case 2:
            count = row
        default:
            break;
        }
    }
}
extension UIDevice {
    static func vibrate() {
        AudioServicesPlaySystemSound(1506)
    }
}
