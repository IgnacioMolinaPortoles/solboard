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
    
    var coordinator: (Coordinator & HomeBuilding)?
    
    private let viewModel = ImportWalletViewModel()
    private let input: PassthroughSubject<ImportWalletViewModel.Input, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bind()
    }
    
    private func bind() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        
        output.sink { [weak self] output in
            switch output {
            case .isValidAddress(let isValid):
                if isValid {
                    self?.coordinator?.buildHome()
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