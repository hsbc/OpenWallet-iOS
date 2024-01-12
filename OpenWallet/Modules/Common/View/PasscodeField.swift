import SwiftUI
import Combine

public struct PasscodeField: View {
    
    var maxDigits: Int = 6
    @Binding var pin: String
    @Binding var disableInput: Bool
    @State var isDisabled = false
    var onFinishInput: ((_ newValue: String) -> Void)?
    
    public var body: some View {
        VStack {
            ZStack {
                pinDots
                backgroundField
            }
        }
        
    }
    
    private var pinDots: some View {
        HStack {
            ForEach(0..<maxDigits) { index in
                ZStack {
                    Rectangle()
                        .fill(.clear)
                        .frame(height: UIScreen.screenHeight*0.074)
                        .border(.black, width: 1)
                        .background(disableInput ? Color("#d7d8d6") : Color.clear)
                    Text(self.getNum(at: index)).font(Font.custom("SFProDisplay-Regular", size: 33))
                }
                .overlay(alignment: .bottom) {
                    if index == pin.count - 1 {
                        Rectangle()
                            .fill(Color("#000000"))
                            .frame(height: 3)
                    }
                }
            }
        }
    }
    
    private var backgroundField: some View {
        TextField("", text: $pin)
            .disabled(disableInput)
            .accentColor(.clear)
            .foregroundColor(.clear)
            .keyboardType(.numberPad)
            .onChange(of: pin, perform: { newValue in
                let filtered = newValue.filter { "0123456789".contains($0) }
                if filtered != newValue {
                    self.pin = filtered
                }
                submitPin()
            })
    }
    
    private func submitPin() {
        if pin.count > maxDigits {
            pin = String(pin.prefix(maxDigits))
            return
        }
        
        if pin.count == maxDigits {
            guard !isDisabled else { return }

            onFinishInput?(pin)

            isDisabled = true
            
            // This is intended to debounce fire off 'onFinishInput'. [weihao.zhang]
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                isDisabled = false
            }
        }
    }
    
    private func getNum(at index: Int) -> String {
        if index >= self.pin.count {
            return ""
        }
        return String(pin[index])
    }
}

extension StringProtocol {
    subscript(offset: Int) -> Character {
        self[index(startIndex, offsetBy: offset)]
    }
}

struct PasscodeField_Previews: PreviewProvider {
    @State static var disableInput: Bool = false
    static var previews: some View {
        VStack {
            PasscodeField(pin: .constant("123"), disableInput: $disableInput)
            PasscodeField(pin: .constant("123456"), disableInput: $disableInput)
            
            PasscodeField(maxDigits: 4, pin: .constant("1234"), disableInput: $disableInput)
        }
    }
}
