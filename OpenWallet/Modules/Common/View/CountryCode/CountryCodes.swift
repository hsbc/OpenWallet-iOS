//
//  CountryCodes.swift
//  OpenWallet
//
//  Created by 陈炳辉 on 2022/8/30.
//

import SwiftUI

struct CountryCodes: View {
    
    @Binding var countryCode: String
    @Binding var isShow: Bool
    @State private var searchText = ""
    @State var itemLists: [CountryCodeModel] = []
    @State var isLoadingState: Bool = true
        
    var body: some View {
        
        GeometryReader { geo in
            NavigationView {
                ScrollView {
                    ForEach(searchResults, id: \.self) { item in
                        HStack {
                            Text(item.country)
                            Spacer()
                            Text("+\(item.code)").foregroundColor(.secondary)
                        }
                        .background(Color.white)
                        .padding()
                        .onTapGesture {
                            self.countryCode = String(item.code)
                            self.isShow = false
                        }
                        Divider()
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        HStack {
                            Text("Select country/location/territory code")
                            Spacer()
                            Image("Close")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 15, height: 15)
                                .onTapGesture {
                                    self.isShow = false
                                }
                                .accessibilityLabel("Click here to hide area code list")

                        }
                    }
                }
                .overlay(alignment: .center) {
                    if isLoadingState {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .black))
                    }
                }
            }
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
            .frame(width: geo.size.width)
            .onAppear {
                Task {
                    isLoadingState = false
                    itemLists = await User.shared.fetchCountryCode()
                }
            }
        }
    }
    
    var searchResults: [CountryCodeModel] {
        if searchText.isEmpty {
            return itemLists
        } else {
            return itemLists.filter {
                $0.country.lowercased().contains(searchText.lowercased()) ||
                String($0.code).contains(searchText)
            }
        }
    }
    
    struct CountryCodes_Previews: PreviewProvider {
        
        static var previews: some View {
            CountryCodes(countryCode: .constant(""), isShow: .constant(true))
        }
    }
    
}
