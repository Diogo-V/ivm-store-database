import re
from django.shortcuts import render
from django.db import connection
from .forms import RawDateSpanQuery, RawDistrictQuery, RawCategoryQuery, RawRetailerQuery, RawIVMQuery


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


def add_remove_category(request):
    form = RawCategoryQuery()
    result = list()
    if request.method == "POST":
        form = RawCategoryQuery(request.POST)
        if form.is_valid():
            print(form.cleaned_data)

            category = form.cleaned_data["category"]

            if request.POST.get('id') == "addCategory":
                _do_query_without_results(query_add_category, [category])
                result = _do_query(query_show_category)

            elif request.POST.get('id') == "removeCategory":
                _do_query_without_results(query_remove_category, [category])
                result = _do_query(query_show_category)

            elif request.POST.get('id') == "addSuperCategory":
                _do_query_without_results(query_add_super_category, [category])
                result = _do_query(query_show_super_category)

            elif request.POST.get('id') == "removeSuperCategory":
                _do_query_without_results(query_remove_super_category, [category])
                result = _do_query(query_show_super_category)

            elif request.POST.get('id') == "addBasicCategory":
                _do_query_without_results(query_add_basic_category, [category])
                result = _do_query(query_show_basic_category)

            elif request.POST.get('id') == "removeBasicCategory":
                _do_query_without_results(query_remove_basic_category, [category])
                result = _do_query(query_show_basic_category)

    context = {
        "form": form,
        "result": result,
    }
    return render(request, 'pages/add-remove-category.html', context)


def add_remove_retailer(request):
    form = RawRetailerQuery()
    result = list()

    if request.method == "POST":
        form = RawRetailerQuery(request.POST)
        if form.is_valid():
            print(form.cleaned_data)

            retailer_tin = form.cleaned_data["retailer_tin"]
            retailer_name = form.cleaned_data["retailer_name"]

            if request.POST.get('id') == "addRetailer":
                _do_query_without_results(query_add_retailer, [retailer_tin, retailer_name])
                result = _do_query(query_show_retailer)
                print(result)

            elif request.POST.get('id') == "removeRetailer":
                _do_query_without_results(query_remove_retailer, [retailer_tin, retailer_name, retailer_tin, retailer_tin])
                result = _do_query(query_show_retailer)
                print(result)

    context = {
        "form": form,
        "result": result,
    }
    return render(request, 'pages/add-remove-retailer.html', context)


def sold_products_ivm(request):
    form = RawIVMQuery()
    result = list()
    if request.method == "POST":
        form = RawIVMQuery(request.POST)
        if form.is_valid():
            print(form.cleaned_data)

            ivm = form.cleaned_data["ivm"]

            result = _do_query(query_sold_products_by_ivm,
                               [ivm])

    context = {
        "form": form,
        "result": result
    }
    return render(request, 'pages/sold-products-ivm.html', context)


def list_sub_categories(request):
    form = RawCategoryQuery()
    result = list()
    if request.method == "POST":
        form = RawCategoryQuery(request.POST)
        if form.is_valid():
            print(form.cleaned_data)

            category = form.cleaned_data["category"]

            _do_query(query_sub_categories_category,[category])

    context = {
        "form": form,
        "result": result,
    }
    return render(request, 'pages/sub-categories-of-a-category.html', context)


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


def _do_query_without_results(query, params=None):
    with connection.cursor() as cursor:
        if params is None:
            cursor.execute(query)
        else:
            cursor.execute(query, params)

    return 0


# ---------------------------------------------------- SQL QUERIES --------------------------------------------------- #


query_retailer_most_replaces = "select nome from evento_reposicao natural join retalhista group by tin,nome having count(*) >= all (select count(*) from evento_reposicao group by tin);"

query_retailers_with_simple_categories = "select nome from retalhista as R where exists (select nome from (categoria_simples join responsavel_por on categoria_simples.nome=responsavel_por.nome_cat) as X where X.tin = R.tin);"

query_products_never_replaced = " select ean from produto as P where not exists(select ean from evento_reposicao where P.ean = evento_reposicao.ean); "

query_products_replaced_same_retailer = "select ean from evento_reposicao group by ean having count(*)=1;"

query_sold_products_by_date_range = "SELECT SUM(v.unidades), v.dia_semana, v.concelho FROM Vendas AS v WHERE (v.ano BETWEEN %s AND %s) AND (v.dia_mes BETWEEN %s AND %s) AND (v.dia_semana BETWEEN %s AND %s) GROUP BY CUBE(v.dia_semana, v.concelho);"

query_sold_products_by_district = "SELECT SUM(v.unidades), v.dia_semana, v.concelho, v.cat FROM Vendas AS v WHERE v.distrito LIKE %s GROUP BY GROUPING SETS(v.concelho, v.cat, v.dia_semana);"

query_add_category = "INSERT INTO categoria VALUES (%s);"

query_show_category = "SELECT nome FROM categoria;"

query_remove_category = "DELETE FROM categoria WHERE categoria.nome = %s;"

query_add_super_category = "INSERT INTO super_categoria VALUES (%s);"

query_add_basic_category = "INSERT INTO categoria_super VALUES (%s);"

query_remove_super_category = "DELETE FROM super_categoria WHERE super_categoria.nome = %s;"

query_remove_basic_category = "DELETE FROM categoria_simples WHERE categoria_simples.nome = %s;"

query_show_super_category = "SELECT nome FROM super_categoria;"

query_show_basic_category = "SELECT nome FROM categoria_simples;"

query_add_retailer = "INSERT INTO retalhista VALUES (%s, %s);"

query_remove_retailer = "DELETE FROM evento_reposicao AS e, responsavel_por AS rp, retalhista AS r WHERE r.tin = %s AND r.nome = %s AND e.tin = %s AND rp.tin = %s;"

query_show_retailer = "SELECT tin, nome FROM retalhista;"

query_sold_products_by_ivm = "SELECT t.nome, SUM(e.unidades) FROM evento_reposicao AS e, tem_categoria AS t WHERE t.ean = e.ean AND e.num_serie = %s GROUP BY t.nome"

query_sub_categories_category = "WITH RECURSIVE generation AS (SELECT categoria FROM tem_outra WHERE super_categoria like %s UNION ALL SELECT tem_outra.categoria FROM tem_outra JOIN generation g ON g.categoria = tem_outra.super_categoria) SELECT categoria FROM generation;"
