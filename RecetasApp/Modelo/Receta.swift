import Foundation


struct Receta: Identifiable {
    let id = UUID()
    var nombre: String
    var minutos: Int
    var esFavorita: Bool = false

    
    static let ejemplos: [Receta] = [
        Receta(nombre: "Ceviche", minutos: 30, esFavorita: true),
        Receta(nombre: "Lomo saltado", minutos: 40),
        Receta(nombre: "Ají de gallina", minutos: 60, esFavorita: true),
        Receta(nombre: "Causa limeña", minutos: 45)
    ]
}
