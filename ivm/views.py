from django.shortcuts import render


def landing_page_view(request):
    return render(request, 'index.html')


def retailer_with_most_replaces_view(request):
    return render(request, 'pages/retailer-most-replaces.html')


def retailers_with_simple_categories_view(request):
    return render(request, 'pages/retailers-simple-categories.html')


def products_never_replaced_view(request):
    return render(request, 'pages/products-never-replaced.html')


def products_replaced_by_same_retailer_view(request):
    return render(request, 'pages/products-replaced-same-retailer.html')
