object inta {
    const parcelas = []

    method agregarParcela(parcela) {
        parcelas.add(parcela)
        true
    }

    method promedioDePlantas() =
        parcelas.sum({ parcela => parcela.plantas().size() }) / parcelas.size().max(1)

    method parcelaMasAutosustentable() {
        const candidatas = parcelas
            .filter({ parcela => parcela.plantas().size() > 4 })
            .map({ parcela => new CandidataAutosustentable(parcela = parcela) })
        candidatas.add(new CandidataSinParcela())
        return candidatas.max({ candidata => candidata.porcentaje() }).parcela()
    }
}

class CandidataAutosustentable {
    var property parcela

    method porcentaje() = self.parcela().porcentajeDePlantasBienAsociadas()
}

class CandidataSinParcela {
    method parcela() = null

    method porcentaje() = -1
}
