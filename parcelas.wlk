class Parcela {
    var property ancho
    var property largo
    var property horasDeSol
    var property plantas

    method superficie() = self.ancho() * self.largo()

    method cantidadMaximaDePlantasQueTolera() =
        [parcelaMasAncha, parcelaNoMasAncha]
            .filter({ regla => regla.aplica(self) })
            .first()
            .cantidadMaximaDePlantas(self)

    method tieneComplicaciones() =
        self.plantas().any({ planta => planta.horasDeSolQueTolera() < self.horasDeSol() })

    method plantar(planta) =
        [plantacionPermitida, plantacionQueSuperaCapacidad]
            .filter({ regla => regla.aplica(self) })
            .first()
            .plantar(self, planta)

    method seAsociaBien(planta) = false

    method porcentajeDePlantasBienAsociadas() =
        self.plantas().filter({ planta => self.seAsociaBien(planta) }).size() * 100 /
            self.plantas().size().max(1)
}

class ParcelaEcologica inherits Parcela {
    override method seAsociaBien(planta) = !self.tieneComplicaciones() && planta.parcelaEsIdeal(self)
}

class ParcelaIndustrial inherits Parcela {
    override method seAsociaBien(planta) =
        self.plantas().size() <= 2 && planta.esFuerte()
}

object parcelaMasAncha {
    method aplica(parcela) = parcela.ancho() > parcela.largo()

    method cantidadMaximaDePlantas(parcela) = parcela.superficie() / 5
}

object parcelaNoMasAncha {
    method aplica(parcela) = parcela.ancho() <= parcela.largo()

    method cantidadMaximaDePlantas(parcela) = parcela.superficie() / 3 + parcela.largo()
}

object plantacionPermitida {
    method aplica(parcela) =
        parcela.plantas().size() + 1 <= parcela.cantidadMaximaDePlantasQueTolera()

    method plantar(parcela, planta) {
        parcela.plantas().add(planta)
        true
    }
}

object plantacionQueSuperaCapacidad {
    method aplica(parcela) =
        parcela.plantas().size() + 1 > parcela.cantidadMaximaDePlantasQueTolera()

    method plantar(parcela, planta) =
        throw new Exception(message = "La parcela superaria su capacidad maxima")
}