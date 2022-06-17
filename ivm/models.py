from django.db import models


# Create your models here.
class Categoria(models.Model):
    nome = models.CharField(max_length=80, null=False, unique=True, primary_key=True)


class CategoriaSimples(models.Model):  # TODO: verificar com a equipa
    nome = models.ForeignKey(Categoria, on_delete=models.DO_NOTHING)


class SuperCategoria(models.Model):
    nome = models.CharField(max_length=80, null=False, unique=True, primary_key=True)
    fk_super_categoria_nome = models.ForeignKey(Categoria, on_delete=models.DO_NOTHING)
    # TODO: falta a ligação com o tem TemOutra


class TemOutra(models.Model):  # TODO: verificar com a equipa
    pass


class Produto(models.Model):
    ean = models.IntegerField(max_length=10, null=False, unique=True, primary_key=True)
    cat = models.ForeignKey(Categoria, on_delete=models.DO_NOTHING, to_field=Categoria.nome)
    desc = models.CharField(max_length=256, null=False)


class TemCategoria(models.Model):
    ean = models.ForeignKey(Produto, on_delete=models.DO_NOTHING, to_field=Produto.ean)
    nome = models.ForeignKey(Categoria, on_delete=models.DO_NOTHING, to_field=Categoria.nome)


class Ivm(models.Model):
    num_serie = models.IntegerField(max_length=10, null=False, unique=True)
    fabricante = models.CharField(max_length=80, null=False, unique=True)

    class Meta:
        constraints = [
            models.UniqueConstraint(
                fields=['num_serie', 'fabricante'], name='Ivm_num_serie_fabricante_combination'
            )
        ]


class PontoDeRetalho(models.Model):
    nome = models.CharField(max_length=80, null=False, unique=True, primary_key=True)
    distrito = models.CharField(max_length=80, null=False, unique=True)
    concelho = models.CharField(max_length=80, null=False, unique=True)


class InstaladaEm(models.Model):
    num_serie = models.ForeignKey(Ivm, on_delete=models.DO_NOTHING, to_field=Ivm.num_serie)
    fabricante = models.ForeignKey(Ivm, on_delete=models.DO_NOTHING, to_field=Ivm.fabricante)
    local = models.CharField(max_length=80, null=False)

    class Meta:
        constraints = [
            models.UniqueConstraint(
                fields=['num_serie', 'fabricante'], name='InstaladaEm_num_serie_fabricante_combination'
            )
        ]


class Prateleira(models.Model):
    nro = models.IntegerField(max_length=16, null=False, unique=True)
    num_serie = models.ForeignKey(Ivm, on_delete=models.DO_NOTHING, to_field=Ivm.num_serie)
    fabricante = models.ForeignKey(Ivm, on_delete=models.DO_NOTHING, to_field=Ivm.fabricante)
    altura = models.IntegerField(max_length=16, null=False)
    nome = models.CharField(max_length=80, null=False)

    class Meta:
        constraints = [
            models.UniqueConstraint(
                fields=['nro', 'num_serie', 'fabricante'], name='Prateleira_nro_num_serie_fabricante_combination'
            )
        ]


class Planograma(models.Model):
    ean = models.ForeignKey(Produto, on_delete=models.DO_NOTHING, to_field=Produto.ean)
    nro = models.ForeignKey(Prateleira, on_delete=models.DO_NOTHING, to_field=Prateleira.nro)
    num_serie = models.ForeignKey(Prateleira, on_delete=models.DO_NOTHING, to_field=Prateleira.num_serie)
    fabricante = models.ForeignKey(Prateleira, on_delete=models.DO_NOTHING, to_field=Prateleira.fabricante)

    class Meta:
        constraints = [
            models.UniqueConstraint(
                fields=['ean', 'nro', 'num_serie', 'fabricante'], name='Planograma_ean_nro_num_serie_fabricante_combination'
            )
        ]


class Retalhista(models.Model):
    tin = models.IntegerField(max_length=16, null=False, unique=True, primary_key=True)
    nome = models.CharField(max_length=80, null=False, unique=True)


class ResponsavelPor(models.Model):
    tin = models.ForeignKey(Retalhista, on_delete=models.DO_NOTHING, to_field=Retalhista.tin)
    num_serie = models.ForeignKey(Ivm, on_delete=models.DO_NOTHING, to_field=Ivm.num_serie)
    fabricante = models.ForeignKey(Ivm, on_delete=models.DO_NOTHING, to_field=Ivm.fabricante)
    nome_cat = models.ForeignKey(Categoria, on_delete=models.DO_NOTHING, to_field=Categoria.nome)

    class Meta:
        constraints = [
            models.UniqueConstraint(
                fields=['num_serie', 'fabricante'], name='ResponsavelPor_num_serie_fabricante_combination'
            )
        ]


class EventoReposicao(models.Model):
    ean = models.ForeignKey(Planograma, on_delete=models.DO_NOTHING, to_field=Planograma.ean)
    nro = models.ForeignKey(Planograma, on_delete=models.DO_NOTHING, to_field=Planograma.nro)
    num_serie = models.ForeignKey(Planograma, on_delete=models.DO_NOTHING, to_field=Planograma.num_serie)
    fabricante = models.ForeignKey(Planograma, on_delete=models.DO_NOTHING, to_field=Planograma.fabricante, related_name='+')
    tin = models.ForeignKey(Retalhista, on_delete=models.DO_NOTHING, to_field=Retalhista.tin)
    unidades = models.IntegerField(max_length=16, null=False)
    instante = models.DateTimeField(null=False, unique=True)

    class Meta:
        constraints = [
            models.UniqueConstraint(
                fields=['ean', 'nro', 'num_serie', 'fabricante', 'instante'],
                name='unique_ean_nro_num_serie_fabricante_instante_combination'
            )
        ]
