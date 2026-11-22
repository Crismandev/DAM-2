# Guía de sustentación oral - T1: Recetas App

Esta guía contiene la explicación técnica y conceptual del código desarrollado para la **Primera Evaluación (T1)** de *Desarrollo de Aplicaciones Móviles II* (CIBERTEC).

---

## 1. Arquitectura y manejo de estado de cada vista

| Vista | Propiedad | Tipo | Explicación técnica |
|---|---|---|---|
| `ContentView` | `mostrarMisRecetas` | `@State` | Controla qué pantalla principal está visible. Al cambiar a `true`, la vista se redibuja mostrando `MisRecetasView` en lugar de `BienvenidaView`. Como no se usa `NavigationStack` aquí, la Bienvenida no entra a la pila de navegación y no se puede retroceder a ella. |
| `BienvenidaView` | `mostrarMisRecetas` | `@Binding` | No es dueña del estado; recibe una referencia bidireccional desde `ContentView`. Al presionar el botón «Ingresar», modifica este binding a `true`. |
| `MisRecetasView` | `recetas` | `@State` | Es la vista dueña y fuente de la verdad (*source of truth*) de la lista de recetas en memoria. Inicializada con `Receta.ejemplos`. Modifica el estado al alternar favoritas. |
| `RegistroView` | `recetas` | `@Binding` | Recibe la referencia enlazada (`$recetas`) de `MisRecetasView`. Cuando se guarda una nueva receta con `.append()`, se inserta directamente en el estado de la vista padre. |
| `RegistroView` | `nombre`, `minutos` | `@State` | Estado local temporal exclusivo del formulario. `minutos` se maneja como `String` porque `TextField` opera con cadenas de texto; luego se convierte y valida como `Int`. |
| `RegistroView` | `mensajeError` | `@State` | Cadena reactiva de error. Cuando está vacía (`""`), no se muestra nada. Cuando contiene un mensaje, SwiftUI redibuja la vista y muestra el texto en color rojo debajo de los campos. |
| `RegistroView` | `dismiss` | `@Environment(\.dismiss)` | Variable de entorno proporcionada por SwiftUI para cerrar la vista actual y sacarla de la pila del `NavigationStack` por código. |
| `FilaReceta` | `receta` | `let` | Estructura inmutable de solo lectura. Solo se encarga de renderizar los datos (nombre, tiempo e ícono de corazón si es favorita). |

---

## 2. Preguntas frecuentes de sustentación

### 1. ¿Por qué la lista usa `@State` en Mis recetas y `@Binding` en el Registro?
Porque en SwiftUI los datos deben tener una **única fuente de verdad** (*single source of truth*).
`MisRecetasView` es la vista principal que lista los elementos, por lo que es la **dueña** de los datos y los declara con `@State`.
`RegistroView` necesita agregar una nueva receta a esa misma lista; si usara `@State`, crearía una copia independiente desconectada. Al recibirla con `@Binding var recetas: [Receta]`, recibe una referencia directa a la lista original, logrando que al ejecutar `recetas.append(...)` y volver con `dismiss()`, la lista en `MisRecetasView` ya contenga la nueva receta y se actualice en pantalla de forma reactiva.

---

### 2. ¿Por qué no se puede volver a la Bienvenida desde Mis recetas?
Porque el paso de Bienvenida a Mis recetas **no se realizó mediante un `NavigationLink` ni dentro de un `NavigationStack`**.
En su lugar, `ContentView` utiliza un condicional reactivo `if/else`:
```swift
if mostrarMisRecetas {
    MisRecetasView()
} else {
    BienvenidaView(mostrarMisRecetas: $mostrarMisRecetas)
}
```
Al presionar «Ingresar», `mostrarMisRecetas` pasa a `true`, destruyendo la jerarquía de `BienvenidaView` y montando `MisRecetasView` desde cero. Como `BienvenidaView` nunca fue apilada en la barra de navegación, el sistema no genera botón de retroceso (`< Back`).

---

### 3. ¿Cómo encuentras la receta que se marcó con el swipe?
Se busca en el arreglo por su identificador único (`UUID`) usando `firstIndex(where:)`:
```swift
private func alternarFavorita(_ receta: Receta) {
    if let indice = recetas.firstIndex(where: { $0.id == receta.id }) {
        recetas[indice].esFavorita.toggle()
    }
}
```
**¿Por qué no usar el índice visual de la fila?**
Porque si la lista se filtra, se reordena o cambia de tamaño, el índice visual puede no coincidir con el índice del arreglo original en memoria, lo que causaría modificar el elemento incorrecto. El `id` garantiza que siempre se modifique la receta exacta. Al ser `Receta` un `struct` (tipo por valor), modificar una propiedad dentro del arreglo `@State` hace que SwiftUI detecte la mutación y redibuje inmediatamente la fila, mostrando u ocultando el corazón rojo.

---

### 4. ¿Cómo aparece y desaparece el mensaje de error en el Registro?
`mensajeError` es una variable `@State String`.
Al presionar el botón «Guardar», se ejecuta el método `validar()` que evalúa las reglas en orden:
1. Nombre no vacío (`nombreLimpio.isEmpty`).
2. Tiempo no vacío (`minutosLimpio.isEmpty`).
3. Nombre con mínimo 3 caracteres (`nombreLimpio.count < 3`).
4. Tiempo numérico entero entre 5 y 180 (`guard let tiempo = Int(minutosLimpio), (5...180).contains(tiempo)`).

Si alguna regla no se cumple, `validar()` retorna la cadena con el mensaje de error y se asigna a `mensajeError`. Como una propiedad `@State` cambió, SwiftUI ejecuta nuevamente el `body` de la vista, donde la condición `if !mensajeError.isEmpty` evalúa a `true` y muestra:
```swift
if !mensajeError.isEmpty {
    Text(mensajeError)
        .foregroundStyle(.red)
}
```
Si todo es válido, `validar()` retorna `nil`, no se asigna error y se procede a guardar.

---

### 5. ¿Cómo regresa el Registro a la lista después de guardar?
Utilizando el disparador del entorno de SwiftUI `@Environment(\.dismiss)`:
```swift
@Environment(\.dismiss) private var dismiss
```
Una vez agregada la receta al arreglo mediante `recetas.append(...)`, se invoca `dismiss()`. Esto notifica al `NavigationStack` contenedor que retire la vista `RegistroView` de la pila de navegación (*pop*), regresando de inmediato a `MisRecetasView`.
