from django import template
from django.utils.html import urlize
from django.utils.safestring import mark_safe

register = template.Library()

@register.filter
def urlize_follow(value):
    return mark_safe(urlize(value, nofollow=False))
