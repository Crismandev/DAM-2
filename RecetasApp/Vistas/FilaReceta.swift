import SwiftUI

struct FilaReceta: View {
    
    let receta: Receta

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "fork.knife")
                .font(.title2)

            VStack(alignment: .leading) {
                Text(receta.nombre)
                    .bold()
                Text("\(receta.minutos) min")
                    .foregroundStyle(.gray)
            }

            Spacer()

            if receta.esFavorita {
                Image(systemName: "heart.fill")
                    .foregroundStyle(.red)
            }
        }
    }
}

#Preview {
    List(Receta.ejemplos) { receta in
        FilaReceta(receta: receta)
    }
}
