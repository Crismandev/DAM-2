import SwiftUI

struct RegistroView: View {
    // @Binding: la lista pertenece a Mis recetas; aquí solo se le agrega una receta.
    @Binding var recetas: [Receta]
    @Environment(\.dismiss) private var dismiss

    @State private var nombre = ""
    // String porque el TextField trabaja con texto; se convierte a Int al validar.
    @State private var minutos = ""
    // Vacío cuando no hay error; si tiene texto, se muestra debajo de los campos.
    @State private var mensajeError = ""

    // Se ignoran los espacios al inicio y al final antes de validar y guardar.
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

    // Devuelve el mensaje del primer error encontrado, o nil si todo es válido.
    // El orden de las reglas es el que pide el enunciado.
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

        // validar() ya comprobó que el tiempo es un número válido.
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
