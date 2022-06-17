from django.shortcuts import render
from django.db import connection
from .forms import RawDateSpanQuery, RawDistrictQuery


# ------------------------------------------------------- VIEWS ------------------------------------------------------ #


def landing_page_view(request):
    return render(request, 'index.html')


def retailer_with_most_replaces_view(request):
    result = _do_query("SELECT name FROM ivm_product")
    return render(request, 'pages/retailer-most-replaces.html', {"result": result})


def retailers_with_simple_categories_view(request):
    return render(request, 'pages/retailers-simple-categories.html')


def products_never_replaced_view(request):
    return render(request, 'pages/products-never-replaced.html')


def products_replaced_by_same_retailer_view(request):
    return render(request, 'pages/products-replaced-same-retailer.html')


def sold_products_by_date_range(request):
    form = RawDateSpanQuery()
    if request.method == "POST":
        form = RawDateSpanQuery(request.POST)
        if form.is_valid():
            print(form.cleaned_data)
    context = {
        "form": form
    }
    return render(request, 'pages/sold-products-date-range.html', context)


def sold_products_by_district(request):
    form = RawDistrictQuery()
    if request.method == "POST":
        form = RawDistrictQuery(request.POST)
        if form.is_valid():
            print(form.cleaned_data)
    context = {
        "form": form
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
