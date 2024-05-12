//
//  ImportWalletViewController.swift
//  Solboard
//
//  Created by Ignacio Molina Portoles on 26/03/2024.
//

import UIKit
import Combine

class ImportWalletViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var addressTextView: UITextView!
    @IBOutlet weak var continueButtonBottomConstraint: NSLayoutConstraint!
    
    private let coordinator: (Coordinator & HomeBuilding)
    private let viewModel: ImportWalletViewModel
    private let alertManager: AlertManagerProtocol
    
    private let input: PassthroughSubject<ImportWalletViewModel.Input, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: ImportWalletViewModel,
         coordinator: (Coordinator & HomeBuilding),
         alertManager: AlertManagerProtocol) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        self.alertManager = alertManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        addressTextView.text = ""//"AUXVBHMKvW6arSPPNbjSuz8y3f6HA2p8YCcKLr8HBGdh"
        bind()
        addObservers()
        addressTextView.delegate = self
    }
    
    private func bind() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        
        output
            .sink { [weak self] output in
            switch output {
            case .isValidAddress(let isValid):
                if isValid {
                    self?.coordinator.buildHome()
                } else {
                    self?.showInvalidAddressAlert()
                }
            }
        }
        .store(in: &cancellables)
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)),
                                               name: UIResponder.keyboardWillShowNotification, 
                                               object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }

    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.continueButtonBottomConstraint.constant = 34 + keyboardSize.height
        }
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        self.continueButtonBottomConstraint.constant = 34
    }
    
    private func showInvalidAddressAlert() {
        alertManager.showAlert("Invalid address", "Please try again", actions: nil, viewController: self)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }

    @IBAction func onContinueButtonTapDo(_ sender: Any) {
        input.send(.verifyAddress(address: addressTextView.text.removeWhitespace()))
    }
}
