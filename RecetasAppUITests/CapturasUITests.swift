import XCTest

// Recorre la app como lo haría un alumno y guarda una captura de cada pantalla
// y de cada caso de validación. Las capturas se usan en el README de la evaluación.
final class CapturasUITests: XCTestCase {
    private let app = XCUIApplication()

    override func setUp() {
        continueAfterFailure = false
        app.launch()
    }

    func testCapturas() {
        // Bienvenida
        XCTAssertTrue(app.buttons["Ingresar"].waitForExistence(timeout: 10))
        capturar("01-bienvenida")
        app.buttons["Ingresar"].tap()

        // Mis recetas
        let misRecetas = app.navigationBars["Mis recetas"]
        XCTAssertTrue(misRecetas.waitForExistence(timeout: 5))
        capturar("02-mis-recetas")

        // Swipe en una receta que no es favorita
        deslizar(fila("Lomo saltado"))
        XCTAssertTrue(app.buttons["Favorita"].waitForExistence(timeout: 5))
        capturar("03-swipe-favorita")
        app.buttons["Favorita"].tap()
        esperar(1)
        capturar("04-lomo-saltado-favorita")

        // Swipe en una receta que ya es favorita
        deslizar(fila("Ceviche"))
        XCTAssertTrue(app.buttons["Quitar"].waitForExistence(timeout: 5))
        capturar("05-swipe-quitar")
        app.buttons["Quitar"].tap()
        esperar(1)

        // Registro vacío
        misRecetas.buttons.firstMatch.tap()
        let nombre = app.textFields["Ingresar nombre"]
        let minutos = app.textFields["Tiempo en minutos"]
        XCTAssertTrue(nombre.waitForExistence(timeout: 5))
        capturar("06-registro")

        // Casos de validación, en el orden del enunciado
        probar(nombre: "", minutos: "30", en: nombre, minutos,
               mensaje: "Ingrese el nombre de la receta.", captura: "07-error-nombre-vacio")
        probar(nombre: "Pollo", minutos: "", en: nombre, minutos,
               mensaje: "Ingrese el tiempo de preparación.", captura: "08-error-tiempo-vacio")
        probar(nombre: "Aj", minutos: "30", en: nombre, minutos,
               mensaje: "El nombre debe tener al menos 3 caracteres.", captura: "09-error-nombre-corto")
        probar(nombre: "Pollo", minutos: "200", en: nombre, minutos,
               mensaje: "El tiempo debe ser un número entre 5 y 180 minutos.", captura: "10-error-tiempo-rango")

        // Datos válidos: se agrega y vuelve a Mis recetas
        escribir("Seco de carne", en: nombre)
        escribir("50", en: minutos)
        capturar("11-datos-validos")
        app.buttons["Guardar"].tap()
        XCTAssertTrue(misRecetas.waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts["Seco de carne"].waitForExistence(timeout: 5))
        esperar(1)
        capturar("12-receta-agregada")
    }

    // MARK: - Ayudas

    private func probar(nombre: String, minutos: String,
                        en campoNombre: XCUIElement, _ campoMinutos: XCUIElement,
                        mensaje: String, captura: String) {
        escribir(nombre, en: campoNombre)
        escribir(minutos, en: campoMinutos)
        app.buttons["Guardar"].tap()
        XCTAssertTrue(app.staticTexts[mensaje].waitForExistence(timeout: 5), mensaje)
        capturar(captura)
    }

    private func fila(_ texto: String) -> XCUIElement {
        app.cells.containing(.staticText, identifier: texto).firstMatch
    }

    // Arrastre corto hacia la derecha: muestra el botón sin ejecutarlo.
    private func deslizar(_ celda: XCUIElement) {
        let inicio = celda.coordinate(withNormalizedOffset: CGVector(dx: 0.1, dy: 0.5))
        let fin = celda.coordinate(withNormalizedOffset: CGVector(dx: 0.45, dy: 0.5))
        inicio.press(forDuration: 0.05, thenDragTo: fin)
    }

    // Toca el final del campo, borra lo que tenga y escribe el texto nuevo.
    private func escribir(_ texto: String, en campo: XCUIElement) {
        campo.coordinate(withNormalizedOffset: CGVector(dx: 0.95, dy: 0.5)).tap()
        if let actual = campo.value as? String, !actual.isEmpty, actual != campo.placeholderValue {
            campo.typeText(String(repeating: XCUIKeyboardKey.delete.rawValue, count: actual.count))
        }
        if !texto.isEmpty {
            campo.typeText(texto)
        }
    }

    private func esperar(_ segundos: TimeInterval) {
        RunLoop.current.run(until: Date().addingTimeInterval(segundos))
    }

    private func capturar(_ nombre: String) {
        let adjunto = XCTAttachment(screenshot: XCUIScreen.main.screenshot())
        adjunto.name = nombre
        adjunto.lifetime = .keepAlways
        add(adjunto)
    }
}
