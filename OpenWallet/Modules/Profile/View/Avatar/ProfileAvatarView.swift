//
//  ProfileAvatarView.swift
//  OpenWallet
//
//  Created by WEIHAO ZHANG on 7/7/22.
//

import SwiftUI

struct ProfileAvatarView: View {
    @Environment(\.dismiss) private var dismiss

    @State var selectedAvatar: String
    
    @State var avatarStartIndex: Int = 0
    @State var avatarEndIndex: Int = 30

    @State private var updateProfileImageErrorMessage: String = AppState.defaultErrorMesssage
    
    @State private var isUpdating: Bool = false
    @State private var showAlert: Bool = false
    @State private var navigateToErrorPage: Bool = false
    
    @State private var numberOfAvatarPerRow: Int = 3

    private let customerService: CustomerService = CustomerService()
    
    // Return current selected avatar on Editor close
    var onSelectionChange: ((_ avatar: String) -> Void)?
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                TopBarView(title: "Select avatar", backAction: backAction)
                    .padding(.horizontal, UIScreen.screenWidth * 0.044)
                
                VStack {
                    VStack {
                        Spacer()
                        Image(selectedAvatar)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 83)
                    }
                    .frame(width: UIScreen.screenWidth * 0.256, height: UIScreen.screenWidth * 0.256)
                    .background(Color("#f3f3f3"))
                    .clipShape(Circle())
                    .padding(.top, UIScreen.screenHeight * 0.032)
                    .padding(.bottom, UIScreen.screenHeight * 0.069)

                    ScrollView {
                        VStack(alignment: .leading, spacing: 2) {
                            ForEach(getAvatarChunks(), id: \.self) { chunkedAvatars in
                                AvartaRowStacker(avatars: chunkedAvatars, isSelected: isAvatarSelected, updateSelection: updateAvatarSelection)
                                    .frame(width: geometry.size.width, height: 125)
                                
                            }
                        }
                    }
                }
                .overlay(alignment: .top) {
                    ToastNotification(showToast: $showAlert, message: $updateProfileImageErrorMessage)
                        .padding(.horizontal, UIScreen.screenWidth * 0.044)
                }
            }
            .overlay {
                updatingIndicator()
            }
            .viewAppearLogger(self)
            
            NavigationLink(
                destination: ErrorView {
                    VStack(spacing: 7) {
                        ActionButton(text: "Try again") {
                            navigateToErrorPage = false
                        }

                        ActionButton(text: "Go back to home", isPrimaryButton: false) {
                            AppState.shared.selectedTab = .home
                            NavigationStateForProfile.shared.backToProfile = true
                        }
                    }
                }.modifier(HideNavigationBar()),
                isActive: $navigateToErrorPage
            ) {
                EmptyView()
            }
            .accessibilityHidden(true)
        }
    }
}

extension ProfileAvatarView {
    func updatingIndicator() -> some View {
        Group {
            if isUpdating {
                ZStack {
                    Color(.black).opacity(0.25).ignoresSafeArea()
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                        .scaleEffect(1.5)
                }
            }
        }
    }
    
    func isAvatarSelected(_ avatar: String) -> Bool {
        return avatar == selectedAvatar
    }
    
    func updateAvatarSelection(_ avatar: String) {
        guard !avatar.isEmpty else { return }
        selectedAvatar = avatar
        
        guard onSelectionChange != nil else { return }
        onSelectionChange!(selectedAvatar)
    }
    
    func backAction() {
        guard User.shared.isLoggin else {
            dismiss()
            return
        }
        
        let hasUnsavedEdit = selectedAvatar != User.shared.profileImage
        
        if hasUnsavedEdit {
            updateProfileImage()
        } else {
            dismiss()
        }
    }

    func updateProfileImage() {
        guard !isUpdating else { return }
        
        Task { @MainActor in
            do {
                isUpdating = true

                let isUpdateSuccessfully = try await customerService.updateAvatar(selectedAvatar, User.shared.token)

                isUpdating = false

                if isUpdateSuccessfully {
                    User.shared.profileImage = selectedAvatar
                    dismiss()
                } else {
                    selectedAvatar = User.shared.profileImage
                    prepareErrorToast()
                }
            } catch let apiErrorResponse as ApiErrorResponse {
                isUpdating = false
                selectedAvatar = User.shared.profileImage
                prepareErrorToast(apiErrorResponse.message)
            } catch {
                isUpdating = false
                selectedAvatar = User.shared.profileImage
                navigateToErrorPage = true
            }
        }
    }
    
    func getAvatarNames() -> [String] {
        let range = avatarStartIndex...avatarEndIndex
        return Array(range).map { index in
            "avatar_\(index)"
        }
    }
    
    func getAvatarChunks() -> [[String]] {
        return getAvatarNames().chunk(numberOfAvatarPerRow)
    }
    
    func prepareErrorToast(_ errorMesssage: String? = nil) {
        showAlert = true
        updateProfileImageErrorMessage = errorMesssage ?? AppState.defaultErrorMesssage
    }
    
}

struct AvartaRowStacker: View {
    @State var avatars: [String]
    
    var isSelected: ((_ avatar: String) -> Bool)
    var updateSelection: ((_ avatar: String) -> Void)
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: geometry.size.width * 0.005) {
                ForEach(avatars, id: \.self) { avatar in
                    AvatarSelector(avatar: avatar, isSelected: isSelected, updateSelection: updateSelection)
                        .frame(width: geometry.size.width * 0.33)
                }
            }
        }
    }
}

struct AvatarSelector: View {
    @State var avatar: String
    var isSelected: ((_ avatar: String) -> Bool)
    var updateSelection: ((_ avatar: String) -> Void)
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                Image(avatar)
                    .resizable()
                    .scaledToFit()
                    .frame(height: geometry.size.height * 0.88)
            }
            .frame(width: geometry.size.width, height: 125)
            .background(Color("#f3f3f3"))
            .overlay(Color("#333333").opacity(isSelected(avatar) ? 0.6 : 0))
            .overlay(isSelected(avatar) ? SelectedMarker() : nil, alignment: .bottom)
            .onTapGesture {
                updateSelection(avatar)
            }
        }
    }
}

struct SelectedMarker: View {
    var body: some View {
        Text("Selected")
            .font(Font.custom("SFProText-Regular", size: FontSize.caption))
            .frame(minWidth: 100, idealWidth: 123, maxWidth: .infinity, minHeight: 20, idealHeight: 20, maxHeight: 20)
            .foregroundColor(.white)
            .background(Color("#333333").opacity(0.8))
    }
}

struct ProfileAvatarView_Previews: PreviewProvider {
    @State static var avatar: String = "avatar_0"
    
    static var previews: some View {
        ProfileAvatarView(selectedAvatar: avatar)
    }
}
