//
//  SOTabBar.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 13.01.2021.
//  Copyright © 2021 Bonup. All rights reserved.
//

import UIKit
import SwiftTheme

// use this protocol to detect when a tab bar item is pressed
@available(iOS 10.0, *)
protocol SOTabBarDelegate: AnyObject {
     func tabBar(_ tabBar: SOTabBar, didSelectTabAt index: Int)
}

@available(iOS 10.0, *)
public class SOTabBar: UIView {

   internal var viewControllers = [UIViewController]() {
        didSet {
            drawTabs()
            guard !viewControllers.isEmpty else { return }
            drawConstraint()
            layoutIfNeeded()
            didSelectTab(index: 0)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.animateTitle(index: 0)
            }
        }
    }

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [])
        stackView.axis = .horizontal
        stackView.spacing = 0
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.clipsToBounds = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let innerCircleView: UIView = {
        let view = UIView()
        view.theme_backgroundColor = SOTabBarSetting.tabBarBackground
        return view
    }()

    private let outerCircleView: UIView = {
        let view = UIView()
        view.backgroundColor = SOTabBarSetting.tabBarTintColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let tabSelectedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .white
        return imageView
    }()

    weak var delegate: SOTabBarDelegate?

    private var selectedIndex: Int = 0
    private var previousSelectedIndex = 0

    override init(frame: CGRect) {
        super.init(frame: frame)
        dropShadow()

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(langChanged),
                                               name: LocaleManager.shared.notificationName,
                                               object: nil)
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        dropShadow()
    }

    private func dropShadow() {
        theme_backgroundColor = SOTabBarSetting.tabBarBackground
        layer.shadowColor = SOTabBarSetting.tabBarShadowColor
        layer.shadowOpacity = 0.6
        layer.shadowOffset = CGSize(width: 0, height: -2)
        layer.shadowRadius = 3
    }

    @objc private func langChanged() {

        for index in self.viewControllers.indices {

            if let item = self.stackView.arrangedSubviews[index] as? SOTabBarItem {

                item.title = self.viewControllers[index].tabBarItem.title ?? ""
            }
        }
    }

    private func drawTabs() {

        for vc in viewControllers {
            let barView = SOTabBarItem(tabBarItem: vc.tabBarItem)
            barView.heightAnchor.constraint(equalToConstant: SOTabBarSetting.tabBarHeight).isActive = true
            barView.translatesAutoresizingMaskIntoConstraints = false
            barView.isUserInteractionEnabled = false
            self.stackView.addArrangedSubview(barView)
        }
    }

    private func drawConstraint() {
        addSubview(stackView)
        addSubview(innerCircleView)

        innerCircleView.addSubview(outerCircleView)
        outerCircleView.addSubview(tabSelectedImageView)

        innerCircleView.frame.size = SOTabBarSetting.tabBarCircleSize
        innerCircleView.layer.cornerRadius = SOTabBarSetting.tabBarCircleSize.width / 2

        outerCircleView.layer.cornerRadius = (innerCircleView.frame.size.height - 10) / 2

        stackView.frame = self.bounds.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))

        let constraints = [
            outerCircleView.centerYAnchor.constraint(equalTo: self.innerCircleView.centerYAnchor),
            outerCircleView.centerXAnchor.constraint(equalTo: self.innerCircleView.centerXAnchor),
            outerCircleView.heightAnchor.constraint(equalToConstant: innerCircleView.frame.size.height - 10),
            outerCircleView.widthAnchor.constraint(equalToConstant: innerCircleView.frame.size.width - 10),
            tabSelectedImageView.centerYAnchor.constraint(equalTo: outerCircleView.centerYAnchor),
            tabSelectedImageView.centerXAnchor.constraint(equalTo: outerCircleView.centerXAnchor),
            tabSelectedImageView.heightAnchor.constraint(equalToConstant: SOTabBarSetting.tabBarSizeSelectedImage),
            tabSelectedImageView.widthAnchor.constraint(equalToConstant: SOTabBarSetting.tabBarSizeSelectedImage),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }

    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let touchArea = touches.first?.location(in: self).x else {
            return
        }
        let index = Int(floor(touchArea / tabWidth))
        didSelectTab(index: index)
    }

    private func didSelectTab(index: Int) {
        if index + 1 == selectedIndex {return}
        animateTitle(index: index)

        previousSelectedIndex = selectedIndex
        selectedIndex  = index + 1

        delegate?.tabBar(self, didSelectTabAt: index)
        animateCircle(with: circlePath)
        animateImage()

        guard let image = self.viewControllers[index].tabBarItem.selectedImage else {
            fatalError("You should insert selected image to all View Controllers")
        }
        self.tabSelectedImageView.image = image
    }

    private func animateTitle(index: Int) {
        self.stackView.arrangedSubviews.enumerated().forEach {
            guard let tabView = $1 as? SOTabBarItem else { return }
            ($0 == index ? tabView.animateTabSelected : tabView.animateTabDeSelect)()
        }
    }

    private func animateImage() {
        tabSelectedImageView.alpha = 0
        UIView.animate(withDuration: SOTabBarSetting.tabBarAnimationDurationTime) { [weak self] in
            self?.tabSelectedImageView.alpha = 1
        }
    }

    private func animateCircle(with path: CGPath) {
        let caframeAnimation = CAKeyframeAnimation(keyPath: #keyPath(CALayer.position))
        caframeAnimation.path = path
        caframeAnimation.duration = SOTabBarSetting.tabBarAnimationDurationTime
        caframeAnimation.fillMode = .both
        caframeAnimation.isRemovedOnCompletion = false
        innerCircleView.layer.add(caframeAnimation, forKey: "circleLayerAnimationKey")
    }
}

@available(iOS 10.0, *)
private extension SOTabBar {

    var tabWidth: CGFloat {
        return UIScreen.main.bounds.width / CGFloat(viewControllers.count)
    }

    var circlePath: CGPath {
        let startPoint_X = CGFloat(previousSelectedIndex) * CGFloat(tabWidth) - (tabWidth * 0.5)
        let endPoint_X = CGFloat(selectedIndex ) * CGFloat(tabWidth) - (tabWidth * 0.5)
        let y = SOTabBarSetting.tabBarHeight * 0.1
        let path = UIBezierPath()
        path.move(to: CGPoint(x: startPoint_X, y: y))
        path.addLine(to: CGPoint(x: endPoint_X, y: y))
        return path.cgPath
    }

}

@available(iOS 10.0, *)
public protocol SOTabBarControllerDelegate: NSObjectProtocol {
    func tabBarController(_ tabBarController: SOTabBarController, didSelect viewController: UIViewController)
}

@available(iOS 10.0, *)
open class SOTabBarController: UIViewController, SOTabBarDelegate {

    weak open var delegate: SOTabBarControllerDelegate?

    public var selectedIndex: Int = 0
    public var previousSelectedIndex = 0

    public var viewControllers = [UIViewController]() {
        didSet {
            tabBar.viewControllers = viewControllers
        }
    }

    private lazy var tabBar: SOTabBar = {
        let tabBar = SOTabBar()
        tabBar.delegate = self
        tabBar.translatesAutoresizingMaskIntoConstraints = false
        return tabBar
    }()

    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        return view
    }()

    override open func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(containerView)
        self.view.addSubview(tabBar)
        self.view.bringSubviewToFront(tabBar)
        self.drawConstraint()
    }

    private func drawConstraint() {
        let safeAreaView = UIView()
        safeAreaView.translatesAutoresizingMaskIntoConstraints = false
        safeAreaView.theme_backgroundColor = SOTabBarSetting.tabBarBackground
        self.view.addSubview(safeAreaView)
        self.view.bringSubviewToFront(safeAreaView)
        let constraints = [containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                           containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                           containerView.topAnchor.constraint(equalTo: view.topAnchor),
                           tabBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                           tabBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                           tabBar.heightAnchor.constraint(equalToConstant: SOTabBarSetting.tabBarHeight),
                           safeAreaView.topAnchor.constraint(equalTo: tabBar.bottomAnchor),
                           safeAreaView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                           safeAreaView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                           safeAreaView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                           containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                                                 constant: -(SOTabBarSetting.tabBarHeight)),
                           tabBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)]
        NSLayoutConstraint.activate(constraints)
    }

    func tabBar(_ tabBar: SOTabBar, didSelectTabAt index: Int) {

        let previousVC = viewControllers[index]
        previousVC.willMove(toParent: nil)
        previousVC.view.removeFromSuperview()
        previousVC.removeFromParent()
        previousSelectedIndex = selectedIndex

        let vc = viewControllers[index]
        delegate?.tabBarController(self, didSelect: vc)
        addChild(vc)
        selectedIndex = index + 1
        vc.view.frame = containerView.bounds
        containerView.addSubview(vc.view)
        vc.didMove(toParent: self)

    }

}

@available(iOS 10.0, *)
class SOTabBarItem: UIView {

    let image: UIImage
    var title: String {

        didSet {

            self.titleLabel.text = self.title
        }
    }

    private lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = self.title.localized
        lbl.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.semibold)
        lbl.textColor = UIColor.darkGray
        lbl.textAlignment = .center
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    private lazy var tabImageView: UIImageView = {
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.theme_tintColor = Colors.tabBarIconColor
        return imageView
    }()

    init(tabBarItem item: UITabBarItem) {
        guard let selecteImage = item.image else {
            fatalError("You should set image to all view controllers")
        }
        self.image = selecteImage
        self.title = item.title ?? ""
        super.init(frame: .zero)
        drawConstraints()
    }

    private func drawConstraints() {
        self.addSubview(titleLabel)
        self.addSubview(tabImageView)
        NSLayoutConstraint.activate([
            tabImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            tabImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            tabImageView.heightAnchor.constraint(equalToConstant: SOTabBarSetting.tabBarSizeImage),
            tabImageView.widthAnchor.constraint(equalToConstant: SOTabBarSetting.tabBarSizeImage),
            titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: SOTabBarSetting.tabBarHeight),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 26)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

   internal func animateTabSelected() {
        tabImageView.alpha = 1
        titleLabel.alpha = 0
        UIView.animate(withDuration: SOTabBarSetting.tabBarAnimationDurationTime) { [weak self] in
            self?.titleLabel.alpha = 1
            self?.titleLabel.frame.origin.y = SOTabBarSetting.tabBarHeight / 1.8
            self?.tabImageView.frame.origin.y = -5
            self?.tabImageView.alpha = 0
        }
    }

    internal func animateTabDeSelect() {
        tabImageView.alpha = 1
        UIView.animate(withDuration: SOTabBarSetting.tabBarAnimationDurationTime) { [weak self] in
            self?.titleLabel.frame.origin.y = SOTabBarSetting.tabBarHeight
            self?.tabImageView.frame.origin.y = (SOTabBarSetting.tabBarHeight / 2) - CGFloat(SOTabBarSetting.tabBarSizeImage / 2)
            self?.tabImageView.alpha = 1
        }
    }
}

public struct SOTabBarSetting {

    public static var tabBarHeight: CGFloat = 66
    public static var tabBarTintColor: UIColor = UIColor(red: 250/255, green: 51/255, blue: 24/255, alpha: 1)
    public static var tabBarBackground: ThemeColorPicker = Colors.tabBarBackgroudColor
    public static var tabBarCircleSize = CGSize(width: 65, height: 65)
    public static var tabBarSizeImage: CGFloat = 25
    public static var tabBarShadowColor = UIColor.lightGray.cgColor
    public static var tabBarSizeSelectedImage: CGFloat = 20
    public static var tabBarAnimationDurationTime: Double = 0.4

}
