class Animal {
  var property nombre
  var property energia = 0

  // Cada subclase responde con su propio comportamiento.
  method especie() = "animal"
  method sonido()

  // Consulta heredable: las subclases reutilizan este metodo.
  method comer(cantidad) {
    self.energia(self.energia() + cantidad)
  }

  method estaActivo() = self.energia() > 0
}

class Perro inherits Animal {
  // Redefine los mensajes de Animal para el comportamiento de perro.
  override method especie() = "perro"
  override method sonido() = "guau"
}

class Gato inherits Animal {
  override method especie() = "gato"

  override method sonido() = "miau"
}

class Vaca inherits Animal {
  override method especie() = "vaca"

  override method sonido() = "muuu"
}

class Preparado {
  var property listo = false

  // initialize se ejecuta automaticamente al crear cada instancia.
  method initialize() {
    self.listo(true)
  }
}

class Manada {
  var property animales

  // Efecto: agrega el animal a la lista existente.
  method agregar(animal) {
    self.animales().add(animal)
  }

  // map transforma cada animal en su sonido; no modifica la lista.
  method sonidos() =
    self.animales().map({ animal => animal.sonido() })

  // filter devuelve solo los animales activos.
  method animalesActivos() =
    self.animales().filter({ animal => animal.estaActivo() })

  // any y all responden preguntas booleanas sobre la coleccion.
  method hayAnimalActivo() =
    self.animales().any({ animal => animal.estaActivo() })

  method todosEstanActivos() =
    self.animales().all({ animal => animal.estaActivo() })

  method energiaTotal() =
    self.animales().sum({ animal => animal.energia() })

  // forEach aplica un efecto a cada elemento.
  method alimentarTodos(cantidad) {
    self.animales().forEach({ animal => animal.comer(cantidad) })
  }
}

// Antipatron: si aparece una nueva especie hay que sumar otra rama al if.
object sonidoConIf {
  method sonidoDe(animal) =
    if (animal.especie() == "perro") "guau"
    else if (animal.especie() == "gato") "miau"
    else "sonido desconocido"
}

// Polimorfismo: todas las especies entienden sonido() y cada una lo redefine.
object sonidoPolimorfico {
  method sonidoDe(animal) = animal.sonido()
}
