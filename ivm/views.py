import re
from django.shortcuts import render
from django.db import connection
from .forms import RawDateSpanQuery, RawDistrictQuery


# ------------------------------------------------------- VIEWS ------------------------------------------------------ #


def landing_page_view(request):
    return render(request, 'index.html')


def retailer_with_most_replaces_view(request):
    result = _do_query(query_retailer_most_replaces)
    context = {
        "result": list(map(lambda x: x[0], result))
    }
    return render(request, 'pages/retailer-most-replaces.html', context)


def retailers_with_simple_categories_view(request):
    result = _do_query(query_retailers_with_simple_categories)
    context = {
        "result": list(map(lambda x: x[0], result))
    }
    return render(request, 'pages/retailers-simple-categories.html', context)


def products_never_replaced_view(request):
    result = _do_query(query_products_never_replaced)
    context = {
        "result": list(map(lambda x: x[0], result))
    }
    return render(request, 'pages/products-never-replaced.html', context)


def products_replaced_by_same_retailer_view(request):
    result = _do_query(query_products_replaced_same_retailer)
    context = {
        "result": list(map(lambda x: x[0], result))
    }
    return render(request, 'pages/products-replaced-same-retailer.html', context)


def sold_products_by_date_range(request):
    form = RawDateSpanQuery()
    result = list()
    if request.method == "POST":
        form = RawDateSpanQuery(request.POST)
        print("here 2")
        if form.is_valid():
            print(form.cleaned_data)
            start = form.cleaned_data["start_date"]
            end = form.cleaned_data["end_date"]

            result = _do_query(query_sold_products_by_date_range,
                               [start.year, end.year, start.month, end.month, start.day, end.day])
            print(type(start.year))
            print(end.month)
            print(end.day)
            print(result)

    context = {
        "form": form,
        "result": result
    }

    return render(request, 'pages/sold-products-date-range.html', context)


def sold_products_by_district(request):
    form = RawDistrictQuery()
    result = list()
    if request.method == "POST":
        form = RawDistrictQuery(request.POST)
        if form.is_valid():
            print(form.cleaned_data)

            district = form.cleaned_data["district"]

            result = _do_query(query_sold_products_by_district,
                               [district])

    context = {
        "form": form,
        "result": result
    }
    return render(request, 'pages/sold-products-district.html', context)


# ------------------------------------------------------ HELPERS ----------------------------------------------------- #


def _do_query(query, params=None):
    result = []
    with connection.cursor() as cursor:
        if params is None:
            cursor.execute(query)
        else:
            cursor.execute(query, params)
        result = cursor.fetchall()

    return result


# ---------------------------------------------------- SQL QUERIES --------------------------------------------------- #


query_retailer_most_replaces = "select nome from evento_reposicao natural join retalhista group by tin,nome having count(*) >= all (select count(*) from evento_reposicao group by tin);"

query_retailers_with_simple_categories = "select nome from retalhista as R where exists (select nome from (categoria_simples join responsavel_por on categoria_simples.nome=responsavel_por.nome_cat) as X where X.tin = R.tin);"

query_products_never_replaced = " select ean from produto as P where not exists(select ean from evento_reposicao where P.ean = evento_reposicao.ean); "

query_products_replaced_same_retailer = "select ean from evento_reposicao group by ean having count(*)=1;"

query_sold_products_by_date_range = "SELECT SUM(v.unidades), v.dia_semana, v.concelho FROM Vendas AS v WHERE (v.ano BETWEEN %s AND %s) AND (v.dia_mes BETWEEN %s AND %s) AND (v.dia_semana BETWEEN %s AND %s) GROUP BY CUBE(v.dia_semana, v.concelho);"

query_sold_products_by_district = "SELECT SUM(v.unidades), v.dia_semana, v.concelho, v.cat FROM Vendas AS v WHERE v.distrito LIKE %s GROUP BY GROUPING SETS(v.concelho, v.cat, v.dia_semana);"