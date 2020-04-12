//
//  TaskSelectionView.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 12.04.2020.
//  Copyright © 2020 Bonup. All rights reserved.
//

import Foundation
import Shuffle_iOS

protocol ITaskSelectionView: AnyObject {
    func returnPrevCard()
    func reloadData()
}

final class TaskSelectionView: UIViewController {

    // MARK: - Public properties

    var presenter: ITaskSelectionPresenter!

    // MARK: - Private properties

    private var emptyContainerView: UIView!
    private var emptyImageView: UIImageView!
    private var emptyInfoLabel: UILabel!

    private var likeButton: UIButton!
    private var dislikeButton: UIButton!
    private var returnButton: UIButton!
    private var footerButtonsStackView: UIStackView!
    private var tasksCardStack: SwipeCardStack!

    // MARK: - Life Cycle

    override func loadView() {
        self.view = UIView()

        self.emptyContainerView = UIView()
        self.view.addSubview(self.emptyContainerView)
        self.emptyContainerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(100)
        }

        self.emptyImageView = UIImageView()
        self.emptyContainerView.addSubview(self.emptyImageView)
        self.emptyImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(self.emptyImageView.snp.width)
        }

        self.emptyInfoLabel = UILabel()
        self.emptyContainerView.addSubview(self.emptyInfoLabel)
        self.emptyInfoLabel.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(self.emptyImageView.snp.bottom).offset(20.0)
        }

        self.tasksCardStack = SwipeCardStack()
        self.view.addSubview(self.tasksCardStack)
        self.tasksCardStack.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(20.0)
        }

        self.footerButtonsStackView = UIStackView()
        self.view.addSubview(self.footerButtonsStackView)
        self.footerButtonsStackView.snp.makeConstraints { make in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-20)
            make.height.equalTo(35.0)
            make.width.equalTo(185.0)
            make.centerX.equalToSuperview()
            make.top.equalTo(self.tasksCardStack.snp.bottom).offset(20.0)
        }

        self.likeButton = UIButton(type: .system)
        self.likeButton.tintColor = UIColor.red.withAlphaComponent(0.7)
        self.dislikeButton = UIButton(type: .system)
        self.dislikeButton.tintColor = UIColor.purpleLite.withAlphaComponent(0.7)
        self.returnButton = UIButton(type: .system)
        self.returnButton.tintColor = UIColor.green.withAlphaComponent(0.7)

        [self.likeButton, self.dislikeButton, self.returnButton].forEach {
            guard let button = $0 else { return }

            self.footerButtonsStackView.addArrangedSubview(button)
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.likeButton.configureCircleButton(with: AssetsHelper.shared.image(.likeIcon))
        self.dislikeButton.configureCircleButton(with: AssetsHelper.shared.image(.disslikeIcon))
        self.returnButton.configureCircleButton(with: AssetsHelper.shared.image(.returnIcon))
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.configureNavigationBar()
        self.configureSubviews()
    }

    // MARK: - Configurations

    private func configureNavigationBar() {
        self.navigationItem.title = "tasks_selection_title".localized

        let tasksListNavigationItem = UIBarButtonItem(
            barButtonSystemItem: .bookmarks,
            target: self,
            action: #selector(tasksListTapped)
        )
        tasksListNavigationItem.tintColor = .purpleLite


        let infoButton = UIButton(type: .infoLight)
        infoButton.tintColor = .purpleLite
        infoButton.addTarget(self, action: #selector(infoNavigationItemTapped), for: .touchUpInside)
        let infoNavigationItem = UIBarButtonItem(customView: infoButton)

        self.navigationItem.rightBarButtonItems = [infoNavigationItem, tasksListNavigationItem]
    }

    private func configureSubviews() {
        self.view.backgroundColor = .white

        // card stack setup
        self.tasksCardStack.dataSource = self
        self.tasksCardStack.delegate = self
        self.tasksCardStack.layer.shadowColor = UIColor.black.withAlphaComponent(0.7).cgColor
        self.tasksCardStack.layer.shadowOpacity = 1
        self.tasksCardStack.layer.shadowOffset = .zero
        self.tasksCardStack.layer.shadowRadius = 10

        // footer buttons setup
        self.likeButton.tag = 0
        self.dislikeButton.tag = 1
        self.returnButton.tag = 2

        [self.likeButton, self.dislikeButton, self.returnButton].forEach {
            $0?.addTarget(self, action: #selector(footerButtonTapped(_:)), for: .touchUpInside)
        }

        // footer buttons stackView setup
        self.footerButtonsStackView.axis = .horizontal
        self.footerButtonsStackView.distribution = .fillEqually
        self.footerButtonsStackView.alignment = .fill
        self.footerButtonsStackView.spacing = 40.0

        // empty section setup
        self.emptyImageView.image = AssetsHelper.shared.image(.emptyTasksListIcon)
        self.emptyInfoLabel.text = "empty_tasks_list_info".localized
        self.emptyInfoLabel.textAlignment = .center
        self.emptyInfoLabel.numberOfLines = 0
        self.emptyInfoLabel.font = UIFont.avenirRoman(20.0)
        self.emptyInfoLabel.textColor = UIColor.black.withAlphaComponent(0.3)
    }

    // MARK: - Selectors

    @objc private func footerButtonTapped(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            self.tasksCardStack.swipe(.right, animated: true)
        case 1:
            self.tasksCardStack.swipe(.left, animated: true)
        case 2:
            self.presenter.handleReturnButtonTap()
        default:
            print("unused tag!!!")
        }
    }

    @objc private func tasksListTapped() {
        print("tasks list")
    }

    @objc private func infoNavigationItemTapped() {
        print("info tapped")
    }
}

// MARK: - ITaskSelectionView implementation

extension TaskSelectionView: ITaskSelectionView {
    func returnPrevCard() {
        self.tasksCardStack.undoLastSwipe(animated: true)
    }

    func reloadData() {
        self.tasksCardStack.reloadData()
    }
}

// MARK: - SwipeCardStackDataSource implementation

extension TaskSelectionView: SwipeCardStackDataSource {
    func numberOfCards(in cardStack: SwipeCardStack) -> Int {
        return 10
    }

    func cardStack(_ cardStack: SwipeCardStack, cardForIndexAt index: Int) -> SwipeCard {
        return TaskCardView(title: "title-\(index)", description: "description-\(index)", image: UIImage(named: "test-task-icon"))
    }
}

// MARK: - SwipeCardStackDelegate implementation

extension TaskSelectionView: SwipeCardStackDelegate {
    func cardStack(_ cardStack: SwipeCardStack, didSwipeCardAt index: Int, with direction: SwipeDirection) {
        switch direction {
        case .left:
            self.presenter.handleTaskSelection(at: index, isLike: false)
        case .right:
            self.presenter.handleTaskSelection(at: index, isLike: true)
        default:
            return
        }
    }
}
