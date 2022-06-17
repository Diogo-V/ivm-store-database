from django import forms


class RawDateSpanQuery(forms.Form):
    start_date = forms.DateField(label='Data de começo')
    end_date = forms.DateField(label='Data de fim')

    def clean(self):
        cleaned_data = super().clean()
        start_date = cleaned_data.get("start_date")
        end_date = cleaned_data.get("end_date")

        if start_date and end_date and start_date > end_date:  # Check if start_date is bigger and end_date
            raise forms.ValidationError("A data de começo é depois da de fim")


class RawDistrictQuery(forms.Form):
    district = forms.CharField(label='Distrito')
