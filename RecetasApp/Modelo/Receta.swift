import Foundation

// Struct (tipo valor): al cambiar una propiedad, SwiftUI detecta el cambio
// en el arreglo @State y vuelve a dibujar la lista.
struct Receta: Identifiable {
    let id = UUID()
    var nombre: String
    var minutos: Int
    var esFavorita: Bool = false

    // Datos iniciales en memoria: la app no tiene persistencia.
    static let ejemplos: [Receta] = [
        Receta(nombre: "Ceviche", minutos: 30, esFavorita: true),
        Receta(nombre: "Lomo saltado", minutos: 40),
        Receta(nombre: "Ají de gallina", minutos: 60, esFavorita: true),
        Receta(nombre: "Causa limeña", minutos: 45)
    ]
}
