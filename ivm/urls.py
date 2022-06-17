from django.urls import path
from . import views


urlpatterns = [
    path('', views.landing_page_view),
    path('retailer-more-replaces/', views.retailer_with_most_replaces_view),
    path('retailers-simple-categories/', views.retailers_with_simple_categories_view),
    path('products-never-replaced/', views.products_never_replaced_view),
    path('products-replaced-same-retailer/', views.products_replaced_by_same_retailer_view),
    path('sold-products-date-range/', views.sold_products_by_date_range),
    path('sold-products-district/', views.sold_products_by_district),
]
