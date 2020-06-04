//
//  ViewController.swift
//  AnimationTest
//
//  Created by Селиванов Александр on 04.06.2020.
//  Copyright © 2020 Alexander Selivanov. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

    private let button = UIButton()

    private var containerView = UIView(frame: .zero)
    private var progressView = UIView(frame: .zero)

    override func viewDidLoad() {
        super.viewDidLoad()

        self.configure()
        self.reset()
    }

    private func configure() {
        self.configureUI()
        self.configureLayout()
    }

    private func configureUI() {
        self.view.addSubview(self.containerView)
        self.containerView.addSubview(self.progressView)
        self.view.addSubview(self.button)

        self.containerView.backgroundColor = .lightGray
        self.progressView.backgroundColor = .green
        self.button.setTitleColor(.black, for: .normal)
        self.button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }

    private func configureLayout() {
        self.containerView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(8)
            make.centerY.equalToSuperview()
            make.height.equalTo(100)
        }

        self.button.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-16)
            make.centerX.equalToSuperview()
        }

        self.progressView.frame = .zero
    }

    @objc
    private func buttonTapped(_ button: UIButton) {
        switch button.currentTitle {
        case "Start":
            button.setTitle("Pause", for: .normal)
            self.start()
        case "Pause":
            button.setTitle("Resume", for: .normal)
            self.pauseLayer(layer: self.progressView.layer)
        case "Resume":
            button.setTitle("Pause", for: .normal)
            self.resumeLayer(layer: self.progressView.layer)
        default:
            break
        }
    }

    private func start() {
        let frame = CGRect(origin: .zero, size: CGSize(width: 0, height: self.progressView.superview?.bounds.height ?? 0))
        self.progressView.frame = frame

        UIView.animate(withDuration: 3, animations: {
            let frame = self.progressView.superview?.bounds ?? .zero
            self.progressView.frame = frame

            self.progressView.setNeedsLayout()
            self.progressView.layoutIfNeeded()
        }) { _ in
            self.reset()
        }
    }

    private func reset() {
        self.button.setTitle("Start", for: .normal)

        self.progressView.frame = .zero
    }

    private func pauseLayer(layer: CALayer) {
        let pausedTime: CFTimeInterval = layer.convertTime(CACurrentMediaTime(), from: nil)
        layer.speed = 0.0
        layer.timeOffset = pausedTime
    }

    private func resumeLayer(layer: CALayer) {
        let pausedTime: CFTimeInterval = layer.timeOffset
        layer.speed = 1.0
        layer.timeOffset = 0.0
        layer.beginTime = 0.0
        let timeSincePause: CFTimeInterval = layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        layer.beginTime = timeSincePause
    }

}
