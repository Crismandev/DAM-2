import SwiftUI

struct BienvenidaView: View {
    
    @Binding var mostrarMisRecetas: Bool

    var body: some View {
        ZStack {
            
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
