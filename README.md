# Machete de Wollok - UNAHUR

Repositorio de consulta rapida para Programacion con Objetos I. Incluye
explicaciones cortas, ejemplos ejecutables y tests.

## Por donde empezar

- [Machete de sintaxis y conceptos](MACHETE.md)
- [Referencia rapida de la biblioteca Wollok](REFERENCIA-API.md)
- [Ejemplos Wollok](ejemplos.wlk)
- [Tests de los ejemplos](ejemplos.wtest)

Los ejemplos muestran objetos, clases, polimorfismo, herencia con `super()`,
composicion dinamica (patron Strategy con roles), bloques, colecciones
(busquedas y transformaciones), validaciones con `self.error()` e inicializacion
con `initialize()`. En particular, comparan un `if` que pregunta el tipo con
una solucion polimorfica.

## Consultar con GitHub Copilot Chat

Abri Copilot Chat desde GitHub con este repositorio como contexto y pregunta
en español. Las instrucciones de contexto estan en
[.github/copilot-instructions.md](.github/copilot-instructions.md). Por
ejemplo: "¿cuando conviene usar `findOrElse`?" o "¿como evito preguntar el tipo
con `if`?".

## Validar los ejemplos

Con Wollok CLI instalado:

```text
wollok test -f ejemplos.wtest
wollok lint -e ejemplos
```

La referencia resume la guia oficial del lenguaje que compartio el usuario.
Para consultar mas detalles, visita [Wollok](https://www.wollok.org/).
