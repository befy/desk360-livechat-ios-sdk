//
//  ChatAgentView.swift
//  LiveChat
//
//  Created by Ali Ammar Hilal on 16.06.2021.
//

import UIKit

final class ChatAgentView: UIView, Layoutable {
	
	lazy var agentAvatarView: UIImageView = {
		let imageView = UIImageView()
		imageView.setSize(.init(width: 40, height: 40))
		imageView.setDebuggingBackground()
		imageView.layer.cornerRadius = 20
		imageView.clipsToBounds = true
		return imageView
	}()
	
	lazy var typingInfolabel: UILabel = {
		let label = UILabel()
		label.textColor = config?.general.headerTitleColor.uiColor
		label.font = FontFamily.Gotham.book.font(size: 11)
		// label.text = "Typing..."
		return label
	}()
	
	lazy var agentNameLabel: UILabel = {
		let label = UILabel()
		label.textColor = config?.general.headerTitleColor.uiColor
		label.font = FontFamily.Gotham.medium.font(size: 20)
		label.text = "Ali Hilal"
		return label
	}()
	
	lazy var backButton: ActionButton = {
		let button = ActionButton(type: .system)
		button.setImage(Images.back, for: .normal)
		button.setSize(.init(width: 24, height: 24))
		return button
	}()
	
	lazy var optionsButton: UIButton = {
		let button = UIButton(type: .system)
		button.setImage(Images.options, for: .normal)
		button.setSize(.init(width: 24, height: 24))
		return button
	}()
	
	lazy var agentStack: UIView = .hStack(
		alignment: .leading,
		distribution: .fill,
		spacing: 10, [
			agentAvatarView,
			.vStack([agentNameLabel, typingInfolabel])
		])
	
	lazy var overallStack: UIView = .hStack(
		alignment: .center,
		distribution: .fill,
		spacing: 15,
		margins: nil,
		[
			backButton,
			agentStack,
			.spacer(),
			optionsButton // ,
			//			downloadButton
		]
	)
	
	lazy var agentStatusIndicator: UIView = {
		let view = UIView()
		view.setSize(.init(width: 12, height: 12))
		view.layer.cornerRadius = 6
		view.clipsToBounds = true
		view.backgroundColor = UIColor(hex: "#31c432")
		return view
	}()
	
	override var intrinsicContentSize: CGSize {
		.init(width: UIView.noIntrinsicMetric, height: 64)
	}
	
	func setupViews() {
		backgroundColor = config?.general.backgroundHeaderColor.uiColor
		addSubview(overallStack)
		// addSubview(agentStatusContainer)
        agentStack.addSubview(agentStatusIndicator)
	}
	
	func setupLayout() {
		overallStack.anchor(
			top: safeAreaLayoutGuide.topAnchor,
			leading: leadingAnchor,
			bottom: nil,
			trailing: trailingAnchor,
			padding: .init(top: 8, left: 20, bottom: 20, right: 20)
		)
		
		agentStatusIndicator.anchor(top: nil, leading: nil, bottom: agentAvatarView.bottomAnchor, trailing: agentAvatarView.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 2, right: 0))
	}
	
	func configure(with agent: Agent?) {
		if let agent = agent {
			agentStatusIndicator.isHidden = false
			typingInfolabel.isHidden = false
			agentNameLabel.text = agent.name
            typingInfolabel.text = Strings.online
            
			guard let avatarUrl = URL(string: agent.avatar) else {
                agentAvatarView.image = Images.avatarPlacegolder
				return
			}
			agentAvatarView.kf.setImage(with: avatarUrl)
		} else {
            typingInfolabel.text = Strings.offline
			agentStatusIndicator.isHidden = true
			agentNameLabel.text = config?.general.brandName ?? Storage.settings.object?.applicationName
			guard let avatarUrl = URL(string: config?.general.brandLogo ?? "") else {
                agentAvatarView.image = Images.avatarPlacegolder
                return
            }
			agentAvatarView.kf.setImage(with: avatarUrl)
		}
        
	}
}

extension Agent.Status {
	var statusColor: UIColor {
		switch self {
		case .active, .online: return .green
		default: return .lightGray
		}
	}
}
