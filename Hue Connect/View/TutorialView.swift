
import SwiftUI

struct TutorialView: View {
    @Environment(\.presentationMode) var presentationMode
    
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

struct TutorialView_Previews: PreviewProvider {
    static var previews: some View {
        TutorialView()
            .preferredColorScheme(.dark)
    }
}
