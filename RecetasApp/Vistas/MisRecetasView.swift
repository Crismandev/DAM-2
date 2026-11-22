import SwiftUI

struct MisRecetasView: View {
    
    @State private var recetas = Receta.ejemplos

    var body: some View {
        NavigationStack {
            List(recetas) { receta in
                FilaReceta(receta: receta)
                    .swipeActions(edge: .leading) {
                        if receta.esFavorita {
                            Button("Quitar", systemImage: "heart.slash") {
                                alternarFavorita(receta)
                            }
                            .tint(.gray)
                        } else {
                            Button("Favorita", systemImage: "heart.fill") {
                                alternarFavorita(receta)
                            }
                            .tint(.red)
                        }
                    }
            }
            .navigationTitle("Mis recetas")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        RegistroView(recetas: $recetas)
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }

    
    private func alternarFavorita(_ receta: Receta) {
        if let indice = recetas.firstIndex(where: { $0.id == receta.id }) {
            recetas[indice].esFavorita.toggle()
        }
    }
}

#Preview {
    MisRecetasView()
}
