
import SwiftUI
/// How to play view
struct TutorialView: View {
    /// Reference to previous view
    @Environment(\.presentationMode) var presentationMode
    /// SwiftUI view
    var body: some View {
        Image("Tutorial")
        .resizable()
        .scaledToFit()
            .navigationBarTitle("How to play", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }, label: {
            HStack{
                Image(systemName: "chevron.left")
                Text("Go back")
            }
            .padding()
            .foregroundColor(Color.white)
            .background(Color.red)
            .cornerRadius(40)
            .fixedSize(horizontal: true, vertical: false)
        }))
    }
}
