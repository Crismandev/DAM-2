import SwiftUI

struct BienvenidaView: View {
    // @Binding: el valor pertenece a ContentView; al cambiarlo aquí,
    // ContentView reemplaza esta pantalla por Mis recetas.
    @Binding var mostrarMisRecetas: Bool

    var body: some View {
        ZStack {
            // El fondo ignora el área segura para cubrir toda la pantalla.
            Color.orange
                .ignoresSafeArea()

            VStack(spacing: 16) {
                Image(systemName: "fork.knife.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundStyle(.white)

                Text("Recetas App")
                    .font(.largeTitle)
                    .bold()
                    .foregroundStyle(.white)

                Button("Ingresar") {
                    mostrarMisRecetas = true
                }
                .font(.headline)
                .foregroundStyle(.orange)
                .padding(.horizontal, 40)
                .padding(.vertical, 12)
                .background(.white)
                .clipShape(Capsule())
                .padding(.top, 24)
            }
        }
    }
}

#Preview {
    BienvenidaView(mostrarMisRecetas: .constant(false))
}
