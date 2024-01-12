//
//  GoldGiftRedemptionDeliveryInfoView.swift
//  OpenWallet
//
//  Created by 陈炳辉 on 2022/9/6.
//

import SwiftUI

struct GoldGiftRedemptionDeliveryInfoView: View {
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var viewModel: GoldGiftViewModel
    
    @State var showWarning: Bool = false
    @State var isActive: Bool = false

    var body: some View {
        ZStack {
            VStack {
                NavigationLink(
                    destination: GoldGiftConfirmRedemptionView(viewModel: viewModel).modifier(HideNavigationBar()),
                    isActive: $isActive
                ) {
                    EmptyView()
                }
                
                TopBarView(title: "Redeem NFT", hideBackButton: true)
                    .padding(.horizontal, UIScreen.screenWidth*0.029)
                    .padding(.top, UIScreen.screenHeight*0.0136)
                    .frame(width: UIScreen.screenWidth)
                    .overlay(alignment: .trailing) {
                        Text("Cancel")
                            .font(Font.custom("SFProText-Regular", size: FontSize.body))
                            .padding(.top, UIScreen.screenHeight*0.0136)
                            .padding(.trailing)
                            .onTapGesture {
                                showWarning = true
                            }
                            .accessibilityHint("Click to go to cancel redeem and back to NFT detail page.")
                    }
                
                ScrollView {
                    VStack(spacing: 0) {
                        StatusBar().padding(.top, UIScreen.screenWidth*0.0299)
                        
                        ContactInfo().padding(.top, 24)
                        
                        ShippingAddress().padding(.top, 40).padding(.bottom, 67)
                        
                        ActionButton(text: "Next", isDisabled: isDisable(), action: {
                            isActive = true
                        })
                    }
                    .padding(.horizontal, UIScreen.screenWidth*0.043)
                }

            }
            
            if showWarning {
                GoldGiftCancelRedemptionWarning(
                    clickYesFunction: {
                        viewModel.resetRedeemData()
                        viewModel.backToNFTDetail.toggle()
                    }, clickNoFunction: {
                        showWarning = false
                    }
                )
            }

        }
    }
}

extension GoldGiftRedemptionDeliveryInfoView {
    func isDisable() -> Binding<Bool> {
        if viewModel.ReceiverName.isEmpty || viewModel.phoneNum.isEmpty || viewModel.addr1.isEmpty {
            return .constant(true)
        }
        return .constant(false)
    }
    
    func StatusBar() -> some View {
        VStack {
            HStack {
                Text("Step 1 of 2")
                    .font(Font.custom("SFProText-Medium", size: FontSize.label))
                Text("Schedule the delivery")
                    .font(Font.custom("SFProText-Regular", size: FontSize.label))
                Spacer()
            }
            ProgressView(value: Float16(CGFloat(1)/2))
                .progressViewStyle(LinearProgressViewStyle(tint: Color("#db0011")))
        }
    }
    func ContactInfo() -> some View {
        VStack(alignment: .leading) {
            Text("Contact information")
                .font(Font.custom("SFProText-Regular", size: FontSize.title4))
            InputTextField(label: "ReceiverName", inputText: $viewModel.ReceiverName)
                .padding(.top, UIScreen.screenWidth*0.008)
                .padding(.bottom, UIScreen.screenWidth*0.015)

            PhoneNumberInput(countryCode: $viewModel.countryCode, phoneNumber: $viewModel.phoneNum)
        }
    }
    func ShippingAddress() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Shipping address")
                .font(Font.custom("SFProText-Regular", size: FontSize.title4))
            
            Text("Country/location/territory")
                .font(Font.custom("SFProText-Regular", size: FontSize.label))
                .padding(.top, UIScreen.screenHeight*0.023)
                .padding(.bottom, UIScreen.screenHeight*0.011)

            Text("Singapore")
                .font(Font.custom("SFProText-Medium", size: FontSize.body))

            Text("City")
                .font(Font.custom("SFProText-Regular", size: FontSize.label))
                .foregroundColor(Color("#333333"))
                .padding(.top, UIScreen.screenHeight*0.015)
                .padding(.bottom, UIScreen.screenHeight*0.003)

            Text("Select from the list")
                .padding()
                .frame(maxWidth: UIScreen.screenWidth, alignment: .leading)
                .frame(height: 48)
                .border(Color("#000000"), width: 1)
                .foregroundColor(Color("#333333"))
                .font(Font.custom("SFProText-Medium", size: FontSize.body))
                .overlay(alignment: .trailing) {
                    Image("Chevron Down")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 13)
                        .padding()
                }
                .padding(.bottom, UIScreen.screenHeight*0.015)

            InputTextField(label: "Address line 1", inputText: $viewModel.addr1)
            Text("\(viewModel.addr1.count)/100")
                .font(Font.custom("SFProText-Regular", size: FontSize.caption))
                .frame(maxWidth: UIScreen.screenWidth, alignment: .trailing)
                .padding(.bottom, UIScreen.screenHeight*0.015)

            InputTextField(label: "Address line 2 (optional)", inputText: $viewModel.addr2)
            Text("\(viewModel.addr2.count)/100")
                .font(Font.custom("SFProText-Regular", size: FontSize.caption))
                .frame(maxWidth: UIScreen.screenWidth, alignment: .trailing)
                .padding(.bottom, UIScreen.screenHeight*0.015)

            InputTextField(label: "Postcode", inputText: $viewModel.postCode)
        }
    }
}

struct GoldGiftRedemptionDeliveryInfoView_Previews: PreviewProvider {
    static var previews: some View {
        GoldGiftRedemptionDeliveryInfoView(viewModel: GoldGiftViewModel())
    }
}
