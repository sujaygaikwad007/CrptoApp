import SwiftUI

struct XmarkButton: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        
        Button {
            presentationMode.wrappedValue.dismiss()
            print("Xmark")
        } label: {
            Image(systemName: "xmark")
                .font(.headline)
        }
        
    }
}

struct XmarkButton_Previews: PreviewProvider {
    static var previews: some View {
        XmarkButton()
    }
}
