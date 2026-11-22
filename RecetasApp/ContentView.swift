import SwiftUI

struct ContentView: View {
    // Se reemplaza la Bienvenida por Mis recetas en lugar de navegar,
    // así la Bienvenida no queda en la pila y no se puede regresar a ella.
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
