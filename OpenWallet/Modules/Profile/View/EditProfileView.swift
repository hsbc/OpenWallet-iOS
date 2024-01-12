//
//  UserNameSettingView.swift
//  OpenWallet
//
//  Created by WEIHAO ZHANG on 5/26/22.
//

import SwiftUI

struct EditProfileView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State var userProfileImage: String
    
    @State private var newUsername: String = User.shared.name
    @State private var showAvatarEditor: Bool = false
    @State private var showUsernameAcceptanceCriteriaInfo: Bool = false
    
    @State private var updateUsernameErrorMessage: String = ""
    @State private var updateProfileImageErrorMessage: String = ""

    @FocusState private var isUsernameInputBoxFocused: Bool
    
    private let authService: AuthService = AuthService()

    var body: some View {
        GeometryReader { _ in
            VStack {
                TopBarView(title: "Edit My Profile", backAction: {dismiss()})
                
                ZStack(alignment: .bottomTrailing) {
                    if userProfileImage.isEmpty {
                        Text("AB")
                            .frame(width: 96, height: 96)
                            .foregroundColor(Color("#000000"))
                            .background(Color("#d4d4d4").opacity(0.5))
                            .clipShape(Circle())

                    } else {
                        VStack {
                            Spacer()
                            Image(userProfileImage)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 83)
                        }
                        .frame(width: 96, height: 96)
                        .background(Color("#f3f3f3"))
                        .clipShape(Circle())
                    }
                    
                    Group {
                        NavigationLink(
                            destination: ProfileAvatarView(selectedAvatar: userProfileImage, onSelectionChange: handleAvatarSelectionChange).navigationBarHidden(true),
                            isActive: $showAvatarEditor
                        ) {
                            EmptyView()
                        }
                        
                        Button {
                            showAvatarEditor.toggle()
                        } label: {
                            ZStack {
                                Image(systemName: "circle.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 32)
                                    .foregroundColor(.black)
                                    .opacity(0.5)
                                
                                Rectangle()
                                    .fill(.clear)
                                    .border(.white.opacity(0.5), width: 1)
                                    .frame(width: 18, height: 18)
                                    .overlay(
                                        Image("Edit")
                                            .renderingMode(.template)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 15)
                                            .foregroundColor(.white),
                                        alignment: .topTrailing
                                    )
                            }
                            .offset(x: -5, y: 5)
                        }
                    }
                }
                .padding(.top, 26)
                .padding(.bottom, 68)
                
                VStack(alignment: .leading) {
                    Text("Username")
                        .font(Font.custom("SFProText-Regular", size: FontSize.callout))
                    InputTextField(inputText: $newUsername, isFocused: _isUsernameInputBoxFocused, onFocusChange: { isOnFocus in
                        guard !isOnFocus else { return }
                        showUsernameAcceptanceCriteriaInfo = !newUsername.isAcceptableUsername
                    })
                    .overlay(
                        Button(action: {
                            newUsername = ""
                        }) {
                            Image(systemName: "xmark.circle")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20)
                                .foregroundColor(Color("#000000"))
                        }.padding(.trailing, 16),
                        alignment: .trailing
                    )
                    
                    if showUsernameAcceptanceCriteriaInfo {
                        HStack {
                            Image("Information on light")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 16, height: 16)
                            
                            Text("The username should be 6–30 characters long and can be any combination of lower and/or upper case letters, numbers, or underscore(_).")
                                .font(Font.custom("SFProText-Regular", size: FontSize.info))

                            Spacer()
                        }
                    }
                }
                
                if !updateUsernameErrorMessage.isEmpty {
                    Text(updateUsernameErrorMessage)
                        .font(.caption2)
                        .foregroundColor(.red)
                        .padding([.top, .bottom], 5)
                }
                
                if !updateProfileImageErrorMessage.isEmpty {
                    Text(updateProfileImageErrorMessage)
                        .font(.caption2)
                        .foregroundColor(.red)
                        .padding([.top, .bottom], 5)
                }
                
                Spacer()
                
                ActionButton(text: "Update changes") {
                    updateChanges()
                }
                .padding(.bottom, 16)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            isUsernameInputBoxFocused = false
        }
        .padding([.leading, .trailing], 16)
    }
}

extension EditProfileView {
    var hasUpdate: Bool {
        return isUserNameChanged || isProfileImageChanged
    }

    func updateChanges() {
        isUsernameInputBoxFocused = false
        clearErrorMessages()
        
        guard newUsername.isAcceptableUsername && hasUpdate else { return }

        Task {
            await updateUsername()
            await updateProfileImage()
            
            await MainActor.run {
                if updateUsernameErrorMessage.isEmpty && updateProfileImageErrorMessage.isEmpty {
                    dismiss()
                }
            }
        }
    }
    
    var isUserNameChanged: Bool {
        let isChanged = !newUsername.isEmpty && newUsername != User.shared.name
        return isChanged
    }
    
    var isProfileImageChanged: Bool {
        let isChanged = userProfileImage != User.shared.profileImage
        return isChanged
    }
    
    func handleAvatarSelectionChange(_ selectedImage: String) {
        guard !selectedImage.isEmpty else { return }
        userProfileImage = selectedImage
    }
    
    func updateUsername() async {
        guard isUserNameChanged else { return }
        
        do {
            let updateUsernameSuccess = try await authService.tryChangingUsername(newUsername, User.shared.token)
            
            await MainActor.run {
                if updateUsernameSuccess {
                    User.shared.name = newUsername
                } else {
                    updateUsernameErrorMessage = "Failed to update username."
                }
            }
        } catch {
            updateUsernameErrorMessage = "Failed to update username."
        }
    }
    
    func updateProfileImage() async {
        do {
            let updateProfileImageSuccess = try await authService.tryChangingAvatar(userProfileImage, User.shared.token)
            
            await MainActor.run {
                if updateProfileImageSuccess {
                    User.shared.profileImage = userProfileImage
                } else {
                    updateProfileImageErrorMessage = "Failed to update profile image."
                }
            }
        } catch {
            updateProfileImageErrorMessage = "Failed to update profile image."
        }
    }
    
    func clearErrorMessages() {
        updateUsernameErrorMessage = ""
        updateProfileImageErrorMessage = ""
    }
}

struct EditProfileView_Previews: PreviewProvider {
    @State static var profileImage: String = "avatar_0"
    
    static var previews: some View {
        EditProfileView(userProfileImage: profileImage)
    }
}
