import SwiftUI

struct RegistroView: View {
    
    @Binding var recetas: [Receta]
    @Environment(\.dismiss) private var dismiss

    @State private var nombre = ""
   
    @State private var minutos = ""
    
    @State private var mensajeError = ""

    
    private var nombreLimpio: String {
        nombre.trimmingCharacters(in: .whitespaces)
    }

    private var minutosLimpio: String {
        minutos.trimmingCharacters(in: .whitespaces)
    }

    var body: some View {
        Form {
            TextField("Ingresar nombre", text: $nombre)
            TextField("Tiempo en minutos", text: $minutos)
                .keyboardType(.numberPad)

            if !mensajeError.isEmpty {
                Text(mensajeError)
                    .foregroundStyle(.red)
            }
        }
        .navigationTitle("Nueva receta")
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Guardar", action: guardar)
            }
        }
    }

    
    private func validar() -> String? {
        if nombreLimpio.isEmpty {
            return "Ingrese el nombre de la receta."
        }
        if minutosLimpio.isEmpty {
            return "Ingrese el tiempo de preparación."
        }
        if nombreLimpio.count < 3 {
            return "El nombre debe tener al menos 3 caracteres."
        }
        guard let tiempo = Int(minutosLimpio), (5...180).contains(tiempo) else {
            return "El tiempo debe ser un número entre 5 y 180 minutos."
        }
        return nil
    }

    private func guardar() {
        if let error = validar() {
            mensajeError = error
            return
        }

        
        guard let tiempo = Int(minutosLimpio) else { return }
        recetas.append(Receta(nombre: nombreLimpio, minutos: tiempo))
        dismiss()
    }
}

#Preview {
    NavigationStack {
        RegistroView(recetas: .constant(Receta.ejemplos))
    }
}
