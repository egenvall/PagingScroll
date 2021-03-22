import SwiftUI

struct ContentView: View {
    let cases: [DisplayStyle] = [.smallLeading, .smallCentered, .cardLeading, .cardCentered, .fullScreen]
    var body: some View {
        NavigationView {
            List(cases, id: \.self) { testCase in
                NavigationLink(destination: DisplayStyleDetailView(displayStyle: testCase)) {
                    CaseRow(testCase: testCase)
                }
            }.navigationTitle("Examples")
        }
    }
}


struct CaseRow: View {
    var testCase: DisplayStyle
    var body: some View {
        HStack {
            Text(testCase.rawValue)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


