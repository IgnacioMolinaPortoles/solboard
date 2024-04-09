//
//  ImportWalletViewController.swift
//  Solboard
//
//  Created by Ignacio Molina Portoles on 26/03/2024.
//

import UIKit
import Combine

class ImportWalletViewController: UIViewController {
    
    @IBOutlet weak var addressTextView: UITextView!
    
    private let coordinator: (Coordinator & HomeBuilding)
    private let viewModel: ImportWalletViewModel
    
    private let input: PassthroughSubject<ImportWalletViewModel.Input, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: ImportWalletViewModel, coordinator: (Coordinator & HomeBuilding)) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addressTextView.text = ""//"AUXVBHMKvW6arSPPNbjSuz8y3f6HA2p8YCcKLr8HBGdh"
        bind()
    }
    
    private func bind() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        
        output
            .receive(on: DispatchQueue.main)
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
    
    private func showInvalidAddressAlert() {
        let alertController = UIAlertController(title: "Invalid address", message: "Please try again", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default))
        present(alertController, animated: true)
    }

    @IBAction func onContinueButtonTapDo(_ sender: Any) {
        input.send(.verifyAddress(address: addressTextView.text))
    }
}
