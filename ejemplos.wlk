class Animal {
  var property nombre
  var property energia = 0

  method especie() = "animal"

  method sonido()

  method comer(cantidad) {
    self.energia(self.energia() + cantidad)
  }

  method estaActivo() = self.energia() > 0
}

class Perro inherits Animal {
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

class Manada {
  var property animales

  method agregar(animal) {
    self.animales().add(animal)
  }

  method sonidos() =
    self.animales().map({ animal => animal.sonido() })

  method animalesActivos() =
    self.animales().filter({ animal => animal.estaActivo() })

  method hayAnimalActivo() =
    self.animales().any({ animal => animal.estaActivo() })

  method todosEstanActivos() =
    self.animales().all({ animal => animal.estaActivo() })

  method energiaTotal() =
    self.animales().sum({ animal => animal.energia() })

  method alimentarTodos(cantidad) {
    self.animales().forEach({ animal => animal.comer(cantidad) })
  }
}

object sonidoConIf {
  method sonidoDe(animal) =
    if (animal.especie() == "perro") "guau"
    else if (animal.especie() == "gato") "miau"
    else "sonido desconocido"
}

object sonidoPolimorfico {
  method sonidoDe(animal) = animal.sonido()
}
