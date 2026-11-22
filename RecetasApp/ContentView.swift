import SwiftUI

struct ContentView: View {
    
    @State private var mostrarMisRecetas = false

    var body: some View {
        if mostrarMisRecetas {
            MisRecetasView()
        } else {
            BienvenidaView(mostrarMisRecetas: $mostrarMisRecetas)
        }
    }
}

#Preview {
    ContentView()
}
