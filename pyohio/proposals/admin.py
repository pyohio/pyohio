from django.contrib import admin

from pyohio.proposals.models import TalkProposal, TutorialProposal, OpenSpaceProposal


admin.site.register(TalkProposal)
admin.site.register(TutorialProposal)
admin.site.register(OpenSpaceProposal)
