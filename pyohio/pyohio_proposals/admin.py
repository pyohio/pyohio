from django.contrib import admin

from .pyohio_proposals.models import (OpenSpaceProposal, TalkProposal,
    TutorialProposal)


admin.site.register(OpenSpaceProposal)
admin.site.register(TalkProposal)
admin.site.register(TutorialProposal)
