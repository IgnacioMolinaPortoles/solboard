//
//  SettingsView.swift
//  Solboard
//
//  Created by Ignacio Molina Portoles on 21/05/2024.
//


import SwiftUI

class SettingsViewModel: ObservableObject {
    private let validatorService: ValidatorServiceProtocol
    private let dataManager: UserCoreDataManager?
    private let alertManager: AlertManagerProtocol
    private let coordinator: LogoutRouting
    
    @Published var userAddress: String = "Sol111111"

    init(dataManager: any UserPersistenceProtocol,
         validatorService: ValidatorServiceProtocol,
         alertManager: AlertManagerProtocol,
         coordinator: LogoutRouting) {
        self.validatorService = validatorService
        self.dataManager = dataManager as? UserCoreDataManager
        self.alertManager = alertManager
        self.userAddress = self.dataManager?.getUser()?.address ?? "Error getting address"
        self.coordinator = coordinator
    }
    
    func isValidAddress(_ address: String, completion: @escaping (Bool) -> Void) {
        validatorService.isValidAddress(address) { [weak self] isValid in
            if isValid {
                guard let user = self?.dataManager?.getUser() else {                    
                    self?.showErrorAlert()
                    completion(false)
                    return
                }
                
                if self?.dataManager?.update(item: user, newAddress: address) ?? false {
                    self?.userAddress = address
                    self?.showSuccessAlert()
                    completion(true)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NotificationID"), object: nil)
                } else {
                    self?.userAddress = self?.dataManager?.getUser()?.address ?? ""
                    self?.showErrorAlert()
                    completion(false)
                }
                
                return
            } else {
                self?.userAddress = self?.dataManager?.getUser()?.address ?? ""
                self?.showErrorAlert()
                completion(false)
            }
        }
    }
    
    private func logout() {
        guard let user = dataManager?.getUser() else {
            return
        }
        let isDeleted = dataManager?.delete(item: user)
        
        if isDeleted ?? false {
            coordinator.logout()
        } else {
            showErrorAlert()
        }
    }
    
    func showConfirmLogoutAlert() {
        alertManager.showAlert("Logout", "Are you sure you want to log out?", actions: [
            UIAlertAction(title: "Yes", style: .default, handler: { [weak self] action in
                self?.logout()
            }),
            UIAlertAction(title: "No", style: .cancel)
        ], viewController: nil)
    }
    
    private func showSuccessAlert() {
        alertManager.showAlert("Done", "Your address has been updated", actions: nil, viewController: nil)
    }
    
    private func showErrorAlert() {
        alertManager.showAlert("Sorry", "We could not update your address", actions: nil, viewController: nil)
    }
}

struct SettingsView: View {
    @StateObject var vm: SettingsViewModel
    @State private var editMode: EditMode = .inactive
    
    var body: some View {
        NavigationView {
            Form {
                EditableView(initialValue: $vm.userAddress, fieldName: "Address", editMode: $editMode, onTextChangedDo: { newAddress in
                    vm.isValidAddress(newAddress) { Bool in
                        print(newAddress)
                    }
                })
                .listRowBackground(Color.backgroundDarkGray2D)
                .listRowSeparatorTint(Color.backgroundDarkGray5D)
                
                HStack {
                    Text("App version")
                    Spacer()
                    Text("1.0.0")
                }
                .listRowBackground(Color.backgroundDarkGray2D)
                
                Section {
                    Text("Log out")
                        .foregroundStyle(.blue)
                        .listRowBackground(Color.backgroundDarkGray2D)
                        .listRowSeparatorTint(Color.listSeparatorDarkGray)
                }
                .onTapGesture {
                    vm.showConfirmLogoutAlert()
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color.backgroundDarkGray1C)
            .foregroundStyle(.white)
            .toolbar {
                EditButton()
            }
            .environment(\.editMode, $editMode)
            .padding(.top, -20)
            Spacer()
        }
        .padding(.top, 20)
        .background(Color.backgroundDarkGray1C)
    }
}

//#Preview {
//    let vm = SettingsViewModel(userAddress: "ASD213",
//                               dataManager: UserCoreDataManager(context: UIApplication.conten),
//                               validatorService: <#T##any ValidatorServiceProtocol#>,
//                               alertManager: <#T##any AlertManagerProtocol#>)
//    
//    return SettingsView(vm: vm)
//}

struct EditableView: View {
    @Binding var editMode: EditMode
    @Binding var value: String
    
    let fieldName: String
    let onTextChangedDo: ((String) -> Void)?
    
    init(initialValue: Binding<String>, fieldName: String, editMode: Binding<EditMode>, onTextChangedDo: ((String) -> Void)?) {
        self.fieldName = fieldName
        self._editMode = editMode
        self.onTextChangedDo = onTextChangedDo
        self._value = initialValue
    }
    
    var body: some View {
        HStack {
            Text(fieldName)
            Spacer()
            
            if editMode.isEditing {
                TextField("Name", text: $value, axis: .vertical)
                    .multilineTextAlignment(.trailing)
                    .lineLimit(5...10)
                    .foregroundStyle(.blue)
//                    .frame(height: 80)
                
            } else {
                Text(value.shortSignature)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
        .animation(nil, value: editMode)
        .onChange(of: editMode) {
            if editMode == .inactive {
                onTextChangedDo?(value)
            }
        }
    }
}
