# Machete rapido de Wollok

Referencia de consulta para Programacion con Objetos I. Los ejemplos usan la
sintaxis Wollok del proyecto; cambia nombres y reglas para adaptarlos al
problema del examen. Los ejemplos concretos y sus pruebas estan en
[ejemplos.wlk](ejemplos.wlk) y [ejemplos.wtest](ejemplos.wtest). Para ampliar,
consulta tambien la [pagina de la materia](https://obj1-unahur.github.io/).

## Indice

- [Leer un problema de objetos](#leer-un-problema-de-objetos)
- [Sintaxis basica](#sintaxis-basica)
- [Objetos, clases y estado](#objetos-clases-y-estado)
- [Polimorfismo y referencias](#polimorfismo-y-referencias)
- [Herencia, redefinicion y super](#herencia-redefinicion-y-super)
- [Bloques o closures](#bloques-o-closures)
- [Colecciones: elegir y consultar](#colecciones-elegir-y-consultar)
- [Colecciones: transformar y buscar](#colecciones-transformar-y-buscar)
- [Colecciones: efectos](#colecciones-efectos)
- [Referencia ampliada de la biblioteca](REFERENCIA-API.md)
- [Testing](#testing)
- [Dudas tipicas](#dudas-tipicas)

## Leer un problema de objetos

1. Marca que objetos existen y que sabe o hace cada uno.
2. Separa **consultas** (devuelven informacion) de **efectos** (cambian algo).
3. Asigna cada regla al objeto que tiene la informacion necesaria para resolverla.
4. Si una regla cambia segun el tipo de objeto, usa polimorfismo antes que
   preguntar por el tipo.
5. Prueba casos normales, limites y colecciones vacias.

## Sintaxis basica

```wollok
// Una linea
/*
  Varias lineas
*/

const edad = 20
var puntaje = 0

edad == 20       // igualdad
edad != 18       // desigualdad
edad > 10        // comparaciones: >, >=, <, <=
true && false    // Y
true || false    // O
!true            // negacion
```

- `=` asigna; `==` compara valores; `===` pregunta si son la misma referencia.
- Aritmetica: `+`, `-`, `*`, `/`, `%`; tambien `n.abs()`, `n.max(otro)`,
  `n.min(otro)`, `n.even()` y `n.odd()`.
- `const` indica una referencia que no se reasigna. No vuelve inmutable al
  objeto al que apunta.
- El ultimo valor de un metodo o bloque es su resultado. Las llamadas que
  modifican algo son efectos.

## Objetos, clases y estado

### Objeto unico

Usalo cuando el dominio necesita una sola instancia.

```wollok
object contador {
  var property valor = 0

  method incrementar() {
    self.valor(self.valor() + 1)
  }

  method valorActual() = self.valor()
}
```

### Clase e instanciacion

Usala como molde cuando puede haber varias instancias. `var property` expone
consultas y actualizaciones del atributo; los nombres de argumentos del
constructor deben coincidir con las propiedades.

```wollok
class Persona {
  var property nombre
  var property edad

  method esMayor() = self.edad() >= 18
}

const ana = new Persona(nombre = "Ana", edad = 20)
ana.nombre()      // consulta
ana.edad(21)      // actualiza la propiedad
ana.esMayor()
```

- `self` es el objeto que recibio el mensaje.
- Un metodo puede delegar trabajo a otro: `self.esMayor()`.
- Preferi metodos que expresen una regla del dominio: `pedido.estaCompleto()`
  es mas claro que recalcularlo desde afuera.
- No expongas el estado si alcanza con ofrecer una operacion que lo modifica.

### `initialize()`: inicializacion al crear el objeto

`initialize()` es un metodo especial que Wollok ejecuta automaticamente cuando
se instancia un objeto con `new`. Cumple un rol parecido al constructor de
otros lenguajes: permite dejar el objeto listo para usar.

```wollok
class Preparado {
  var property listo = false

  method initialize() {
    self.listo(true)
  }
}

const preparado = new Preparado()
preparado.listo() // true: initialize ya se ejecuto
```

Para atributos comunes, suele alcanzar con inicializar la propiedad en la
declaracion o darle valor al crear la instancia:
`new Persona(nombre = "Ana", edad = 20)`. Define `initialize()` cuando haga
falta realizar una preparacion adicional. No es un metodo que normalmente
tengas que llamar a mano.

Si una subclase redefine `initialize()` y necesita conservar la inicializacion
de la clase padre, llama `super()`:

```wollok
class PreparadoEspecial inherits Preparado {
  var property verificado = false

  override method initialize() {
    super()
    self.verificado(true)
  }
}
```

## Polimorfismo y referencias

Polimorfismo: distintos objetos responden al mismo mensaje con su propia regla.
El que envia el mensaje no necesita preguntar que clase concreta tiene.

```wollok
class Ave {
  method velocidad() = 0
}

class Halcon inherits Ave {
  override method velocidad() = 120
}

class Caracol inherits Ave {
  override method velocidad() = 1
}

object medidor {
  method mostrarVelocidad(animal) = animal.velocidad()
}
```

`medidor.mostrarVelocidad(animal)` funciona con cualquier objeto que entienda
`velocidad()`.
Esto es tipado por comportamiento: importa que mensajes entiende el objeto.

### Evitar `if` para preguntar el tipo

`if` sirve para elegir segun una condicion del problema. Lo que suele romper
el polimorfismo es usarlo para averiguar la clase/tipo y decidir desde afuera
que comportamiento corresponde:

```wollok
// MAL: cada tipo nuevo obliga a modificar este metodo y agregar otra rama.
if (animal.especie() == "perro") "guau"
else if (animal.especie() == "gato") "miau"
else "sonido desconocido"
```

Deja que cada objeto resuelva su propio comportamiento y envia el mismo
mensaje a todos:

```wollok
animal.sonido()
```

`Perro`, `Gato` y `Vaca` redefinen `sonido()`. Al agregar una clase nueva, la
logica que envia `sonido()` no necesita cambiar. El ejemplo ejecutable y el test
que muestra la diferencia estan en [ejemplos.wlk](ejemplos.wlk) y
[ejemplos.wtest](ejemplos.wtest).

## Herencia, redefinicion y super

```wollok
class Animal {
  var property energia = 0

  method alimentarse() {
    self.energia(self.energia() + 10)
  }

  method estaActivo() = self.energia() > 0
}

class Gato inherits Animal {
  override method alimentarse() {
    super.alimentarse()
    self.energia(self.energia() + 5)
  }
}
```

- `inherits` hereda comportamiento y estado.
- `override` declara que se redefine un metodo heredado.
- `super.metodo(argumentos)` ejecuta la version de la superclase.
- Redefini solo cuando la subclase realmente necesita otro comportamiento.
- En Wollok no hace falta una palabra `abstract class`: una clase que declara
  un metodo sin implementacion es abstracta y no se instancia directamente.
  Las subclases concretas deben implementar ese metodo:

```wollok
class Figura {
  method area()
}

class Cuadrado inherits Figura {
  var property lado
  override method area() = self.lado() * self.lado()
}
```

## Bloques o closures

Un bloque es codigo que se puede pasar como objeto. No se ejecuta al crearlo:
se ejecuta cuando quien lo recibe lo aplica o cuando una coleccion lo usa.

```wollok
{ => 2 + 3 }                         // bloque sin parametros
{ numero => numero * 2 }             // un parametro
{ nombre, apellido => nombre + apellido } // dos parametros
```

Para ejecutarlo manualmente: `{ numero => numero * 2 }.apply(4)`.

Los nombres de parametros son locales al bloque. Usalos para expresar que se
evalua, por ejemplo:

```wollok
plantas.any({ planta => planta.esFuerte() })
plantas.filter({ planta => planta.altura() > 1 })
```

## Colecciones: elegir y consultar

| Necesidad | Lista | Conjunto |
|---|---|---|
| Crear | `[a, b, a]` | `#{a, b}` |
| Orden | Mantiene posiciones | No asumas un orden |
| Repetidos | Puede haber | No se repiten |

Consultas comunes:

| Mensaje | Para que sirve |
|---|---|
| `coleccion.size()` | Cantidad de elementos |
| `coleccion.isEmpty()` | Si esta vacia |
| `coleccion.contains(elemento)` | Si contiene un elemento |
| `lista.get(indice)` | Elemento por indice (empieza en 0) |
| `lista.first()` / `lista.head()` | Primer elemento |
| `lista.last()` | Ultimo elemento |
| `lista.take(n)` | Primeros `n` elementos |
| `coleccion.asList()` / `.asSet()` | Convertir el tipo de coleccion |
| `coleccion.max()` / `.min()` | Mayor / menor elemento comparable |
| `coleccion.sum()` | Sumar numeros |
| `coleccion.flatten()` | Aplanar una coleccion de colecciones |

Ojo: `first()`, `head()`, `last()` y `get(indice)` necesitan que exista ese
elemento. Valida antes si la coleccion puede estar vacia.

## Colecciones: transformar y buscar

Estas operaciones consultan y devuelven un resultado; no agregan ni eliminan
elementos de la coleccion original.

| Mensaje | Resultado | Ejemplo |
|---|---|---|
| `filter(bloque)` | Elementos que cumplen | `plantas.filter({ p => p.esFuerte() })` |
| `map(bloque)` | Un resultado por elemento | `personas.map({ p => p.nombre() })` |
| `any(bloque)` | Si alguno cumple | `plantas.any({ p => p.esFuerte() })` |
| `all(bloque)` | Si todos cumplen | `plantas.all({ p => p.esFuerte() })` |
| `count(bloque)` | Cuantos cumplen | `plantas.count({ p => p.esFuerte() })` |
| `find(bloque)` | Primer elemento que cumple | `plantas.find({ p => p.esFuerte() })` |
| `findOrElse(bloque, alternativa)` | Busca o evalua bloque alternativo | El segundo argumento es un bloque sin parametros |
| `findOrDefault(bloque, valor)` | Busca o devuelve valor por defecto | El segundo argumento es un valor, no un bloque |
| `sum(bloque)` | Suma un calculo por elemento | `plantas.sum({ p => p.altura() })` |
| `flatMap(bloque)` | Transforma y aplana | Para resultados que son colecciones |
| `fold(inicial, bloque)` | Acumula un resultado | `numeros.fold(0, { acum, n => acum + n })` |
| `sortedBy(bloque)` | Nueva coleccion ordenada | Criterio/comparacion segun el bloque |
| `max(bloque)` / `min(bloque)` | Extremo segun criterio | `plantas.max({ p => p.altura() })` |

- `any` da `false` para una coleccion vacia; `all` da `true`.
- `find` requiere que contemples que pasa si no hay coincidencias. Si no estas
  seguro, usa `findOrElse`, `findOrDefault` o valida antes.
- Para filtrar y luego calcular: `plantas.filter({ p => p.esFuerte() }).size()`.
- No uses `forEach` para construir una coleccion nueva: para eso esta `map`.
- `sortedBy` compara pares: por ejemplo,
  `personas.sortedBy({ a, b => a.edad() < b.edad() })`.
- El promedio de una coleccion vacia da error; valida con `isEmpty()` si puede
  ocurrir.

## Colecciones: efectos

Estos mensajes cambian la coleccion existente:

```wollok
plantas.add(nuevaPlanta)
plantas.addAll(otrasPlantas)
plantas.remove(planta)
plantas.clear()
plantas.forEach({ planta => planta.regar() })
```

- `forEach` ejecuta una accion para cada elemento; no es una transformacion.
- `sortBy` ordena una lista existente segun un criterio.
- Si un metodo modifica una coleccion recibida por parametro, eso es un efecto:
  revisa que el problema pida modificarla y no simplemente calcular un
  resultado.

## Testing

```wollok
describe "Comportamiento de Persona" {
  test "es mayor desde los 18 inclusive" {
    const persona = new Persona(nombre = "Ana", edad = 18)
    assert.that(persona.esMayor())
  }

  test "rechaza una operacion invalida" {
    assert.throwsException({ unaOperacionInvalida() })
  }
}
```

Prueba valores limite (por ejemplo `17`, `18`, `19`), ambos resultados de una
condicion, listas vacias y no vacias, y que los efectos cambien el estado
esperado. Un test por comportamiento concreto hace mas facil encontrar errores.

## Dudas tipicas

| Si te preguntas... | Acordate de... |
|---|---|
| `==` o `===`? | Igualdad de valores o identidad de referencia, respectivamente. |
| `map` o `forEach`? | Construir resultados o ejecutar efectos, respectivamente. |
| `filter` o `any`? | Obtener los que cumplen o saber si alguno cumple. |
| `const` significa inmutable? | No: no se reasigna la referencia, pero el objeto puede cambiar. |
| Debo preguntar `if (esSoja)`? | Mejor envia el mismo mensaje y deja que cada tipo responda. |
| `first()` puede fallar? | Si, cuando no hay elementos. Maneja ese caso. |
| Una lista y un conjunto son iguales? | No: la lista tiene orden y admite repetidos; el conjunto no. |

La documentacion de la materia es la referencia final si necesitas confirmar un
mensaje puntual o el comportamiento de una version especifica de Wollok.
