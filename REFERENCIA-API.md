# Referencia rapida de la biblioteca Wollok

Resumen original para consultar junto con el machete. Toma como base la
**Guia del lenguaje Wollok** que compartiste (referencia de clases y mensajes
de la biblioteca, 65 paginas); no reemplaza la documentacion completa. Se
priorizan los mensajes que suelen servir en los ejercicios de la cursada.

## Colecciones

### Consultas habituales

| Mensaje | Que devuelve | Atencion |
|---|---|---|
| `size()` / `isEmpty()` | Cantidad / si esta vacia | Sirve en listas y conjuntos. |
| `contains(elemento)` | Si aparece el elemento | No modifica la coleccion. |
| `any({ e => condicion })` | Si al menos uno cumple | Da `false` si esta vacia. |
| `all({ e => condicion })` | Si todos cumplen | Da `true` si esta vacia. |
| `count({ e => condicion })` | Cantidad que cumple | La coleccion original no cambia. |
| `filter({ e => condicion })` | Coleccion con los que cumplen | Conserva el tipo de coleccion. |
| `map({ e => resultado })` | Resultado de transformar cada elemento | Conserva el tipo de coleccion. |
| `flatMap({ e => coleccion })` | Transformaciones aplanadas | Devuelve una lista; puede repetir elementos. |
| `flatten()` | Elementos de colecciones internas en una sola | No es lo mismo que transformar. |
| `sum()` / `sum({ e => numero })` | Suma de valores / suma transformada | La suma vacia es `0`. |
| `average()` / `average({ e => numero })` | Promedio | Da error si la coleccion esta vacia. |
| `fold(inicial, { acum, e => nuevoAcum })` | Acumulacion de todos los elementos | El inicial es el resultado de la coleccion vacia. |
| `min()` / `max()` | Menor / mayor elemento comparable | Da error si no hay elementos. |
| `min({ e => criterio })` / `max({ e => criterio })` | Elemento extremo segun el criterio | Da error si no hay elementos. |
| `sortedBy({ a, b => a va antes que b })` | Nueva lista ordenada | El bloque compara dos elementos y devuelve booleano. |
| `find({ e => condicion })` | Primer elemento encontrado | Da `ElementNotFoundException` si no encuentra. |
| `findOrElse(predicado, { alternativa })` | Elemento o resultado del bloque alternativo | La alternativa es un bloque sin parametros. |
| `findOrDefault(predicado, valor)` | Elemento o valor por defecto | El valor alternativo no es un bloque. |
| `forEach({ e => accion })` | Ejecuta una accion por elemento | Tiene efecto; no construye una lista. |

Ejemplos:

```wollok
const nombres = personas.map({ persona => persona.nombre() })
const mayores = personas.filter({ persona => persona.edad() >= 18 })
const edades = personas.sum({ persona => persona.edad() })
const hayAdultos = personas.any({ persona => persona.edad() >= 18 })
const total = numeros.fold(0, { acumulado, numero => acumulado + numero })
const ordenados = personas.sortedBy({ a, b => a.edad() < b.edad() })

const elegido = personas.findOrElse(
  { persona => persona.esFavorita() },
  { personaPorDefecto }
)
const cantidad = numeros.findOrDefault({ n => n > 100 }, 0)
```

### Mutaciones y tipos de coleccion

```wollok
lista.add(elemento)
lista.addAll(otraColeccion)
lista.remove(elemento)
lista.removeAll(otraColeccion)
lista.clear()
```

- Una lista mantiene el orden de insercion y permite repetidos.
- Un conjunto se escribe `#{a, b}`: no tiene orden garantizado ni repite
  elementos.
- `coleccion.asList()` y `coleccion.asSet()` convierten entre ambos tipos.
  Pasar una lista a conjunto elimina repetidos.
- Los conjuntos tambien entienden `union(otra)`, `intersection(otra)` y
  `difference(otra)`; cada mensaje devuelve un conjunto nuevo.
- `copyWith(elemento)` y `copyWithout(elemento)` devuelven una copia; a
  diferencia de `add` y `remove`, no modifican la coleccion original.

### Listas

- `get(indice)` usa indice desde 0; un indice negativo o fuera de rango da error.
- `first()` / `head()` y `last()` necesitan una lista no vacia.
- `subList(desde)` devuelve una parte de la lista.
- `take(cantidad)` y `drop(cantidad)` toman o descartan los primeros elementos.
- `reverse()` devuelve una lista invertida; `randomize()` modifica el orden de
  la lista original.
- `withoutDuplicates()` devuelve una lista sin repetidos, conservando su
  primera aparicion.

## Diccionarios

Sirven para asociar claves con valores:

```wollok
const telefonos = new Dictionary()
telefonos.put("Ana", "1111-2222")

telefonos.containsKey("Ana")              // true
telefonos.getOrElse("Luis", { "sin dato" }) // usa un bloque si falta la clave
telefonos.remove("Ana")
```

- `get(clave)` da error cuando no existe la clave.
- `basicGet(clave)` devuelve `null` cuando no existe.
- `getOrElse(clave, { alternativa })` evalua el bloque alternativo solo si no
  encuentra la clave.
- `put`, `remove` y `clear` modifican el diccionario.

## Numeros, rangos y cadenas

### Numeros

```wollok
8.div(3)       // division entera: 2
8 % 3          // resto: 2
3 ** 2         // potencia: 9
4.max(10)      // 10
4.min(10)      // 4
```

Otros mensajes utiles: `abs()`, `even()`, `odd()`, `round()`, `floor()`,
`ceil()`, `isInteger()` e `isPrime()`. La documentacion tambien presenta
`rem(otro)` para el resto.

### Rangos

```wollok
const delUnoAlCinco = 1..5
delUnoAlCinco.forEach({ numero => Console.println(numero) })
const suma = delUnoAlCinco.fold(0, { acumulado, numero => acumulado + numero })
```

Los extremos del rango son inclusivos. Tambien se puede configurar `step`.
Los rangos comparten operaciones de colecciones como `map`, `filter`, `sum`,
`any`, `all` y `fold`.

### Cadenas

- `length()` / `size()` consultan la longitud.
- `startsWith(prefijo)` y `endsWith(sufijo)` verifican extremos.
- `indexOf(texto)` busca la primera posicion; devuelve `-1` si no esta.
- `substring(desde)` / `substring(desde, hasta)` extraen una parte.
- `split(separador)` separa y devuelve una lista.
- `take(cantidad)` y `drop(cantidad)` toman o descartan caracteres iniciales.
- `replace(busqueda, reemplazo)` reemplaza texto.

## Bloques y tests

- Un bloque sin parametros se escribe `{ => expresion }`; con parametros:
  `{ elemento => expresion }`.
- `bloque.apply(argumentos)` ejecuta un bloque directamente.
- `assert.that(condicion)` falla si la condicion es falsa.
- `assert.notThat(condicion)` falla si la condicion es verdadera.
- `assert.throwsException({ operacion() })` verifica que la operacion lance
  una excepcion.

```wollok
assert.that([1, 2, 3].contains(2))
assert.throwsException({ [].first() })
```

## Inicializacion de instancias

La guia oficial describe `initialize()` como un mensaje de `Object` que se
ejecuta cuando se instancia cualquier objeto. Se puede redefinir para preparar
el estado de una clase:

```wollok
class Preparado {
  var property listo = false

  method initialize() {
    self.listo(true)
  }
}

const preparado = new Preparado()
preparado.listo() // true
```

En general, usa argumentos nombrados de `new` para dar valores iniciales a las
propiedades (`new Persona(nombre = "Ana")`) y redefine `initialize()` solo
cuando necesitas logica adicional. Si redefinis el inicializador en una
subclase y tambien necesitas la preparacion heredada, llama a `super()`.
Hay un ejemplo comprobable en [ejemplos.wlk](ejemplos.wlk) y
[ejemplos.wtest](ejemplos.wtest).

## Fuente y alcance

Esta guia es un resumen didactico preparado para este repositorio a partir del
PDF **Guia del lenguaje Wollok** compartido para la cursada. Para detalles de
version, casos menos comunes o cambios de la biblioteca, consulta el PDF
original y la [documentacion oficial de Wollok](https://www.wollok.org/).
