from datetime import datetime
import json

from django.core.urlresolvers import reverse
from django.contrib.sites.models import Site
from django.http import HttpResponse

from symposion.schedule.models import Slot


def json_serializer(obj):
    if isinstance(obj, datetime.time):
        return obj.strftime("%H:%M")
    raise TypeError


def duration(start, end):
    start_dt = datetime.strptime(start.isoformat(), "%H:%M:%S")
    end_dt = datetime.strptime(end.isoformat(), "%H:%M:%S")
    delta = end_dt - start_dt
    return delta.seconds // 60


def schedule_json(request):
    slots = Slot.objects.all().order_by("start")
    data = []
    for slot in slots:
        print slot.kind
        if slot.kind.label in ["talk", "tutorial", "plenary"] and slot.content and slot.content.proposal.kind.slug in ["talk", "tutorial"]:
            slot_data = {
                "name": slot.content.title,
                "room": ", ".join(room["name"] for room in slot.rooms.values()),
                "start": datetime.combine(slot.day.date, slot.start).isoformat(),
                "end": datetime.combine(slot.day.date, slot.end).isoformat(),
                "duration": duration(slot.start, slot.end),
                "authors": [s.name for s in slot.content.speakers()],
                "license": "",
                "contact": [s.email for s in slot.content.speakers()],
                "abstract": slot.content.abstract.raw,
                "description": slot.content.description.raw,
                "conf_key": slot.pk,
                "conf_url": "https://%s%s" % (
                    Site.objects.get_current().domain,
                    reverse("schedule_presentation_detail", args=[slot.content.pk])
                ),
                "kind": slot.content.proposal.kind.slug,
                "tags": "",
            }
        else:
            continue
        data.append(slot_data)
    
    return HttpResponse(
        json.dumps(data, default=json_serializer),
        content_type="application/json"
    )
