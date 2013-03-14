from django.contrib import admin

from pyohio.proposals.models import TalkProposal, TutorialProposal


admin.site.register(TalkProposal)
admin.site.register(TutorialProposal)
