from django import forms


class RawDateSpanQuery(forms.Form):
    start_date = forms.DateField()
    end_date = forms.DateField()


class RawDistrictQuery(forms.Form):
    district = forms.CharField()
