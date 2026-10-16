class Planta {
    var property anioObtencion
    var property altura

    method horasDeSolQueTolera() = 0

    method esFuerte() = self.horasDeSolQueTolera() > 10

    method daNuevasSemillas() = self.esFuerte() || self.condicionAlternativaParaDarSemillas()

    method condicionAlternativaParaDarSemillas() = false

    method espacioQueOcupa() = 0

    method parcelaEsIdeal(parcela) = false
}

class Menta inherits Planta {
    override method horasDeSolQueTolera() = 6

    override method condicionAlternativaParaDarSemillas() = self.altura() > 0.4

    override method espacioQueOcupa() = self.altura() * 3

    override method parcelaEsIdeal(parcela) = parcela.superficie() > 6
}

class Soja inherits Planta {
    override method horasDeSolQueTolera() =
        [
            sojaAlturaBaja,
            sojaAlturaMedia,
            sojaAlturaAlta
        ].filter({ regla => regla.aplica(self.altura()) }).first().horasDeSol()

    override method condicionAlternativaParaDarSemillas() = self.anioObtencion() > 2007 && self.altura() > 1

    override method espacioQueOcupa() = self.altura() / 2

    override method parcelaEsIdeal(parcela) = parcela.horasDeSol() == self.horasDeSolQueTolera()
}

class Quinoa inherits Planta {
    var property horasDeSol

    override method horasDeSolQueTolera() = self.horasDeSol()

    override method condicionAlternativaParaDarSemillas() = self.anioObtencion() < 2005

    override method espacioQueOcupa() = 0.5

    override method parcelaEsIdeal(parcela) = !parcela.plantas().any({ planta => planta.altura() > 1.5 })
}

class SojaTransgenica inherits Soja {
    override method daNuevasSemillas() = false

    override method parcelaEsIdeal(parcela) = parcela.cantidadMaximaDePlantasQueTolera() == 1
}

class Hierbabuena inherits Menta {
    override method espacioQueOcupa() = self.altura() * 6
}

object sojaAlturaBaja {
    method aplica(altura) = altura < 0.5

    method horasDeSol() = 6
}

object sojaAlturaMedia {
    method aplica(altura) = altura >= 0.5 && altura <= 1

    method horasDeSol() = 7
}

object sojaAlturaAlta {
    method aplica(altura) = altura > 1

    method horasDeSol() = 9
}