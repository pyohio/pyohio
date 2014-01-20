import factory

from pyohio.pyohio_proposals import models as pyohio_proposals


class ProposalFactory(factory.django.DjangoModelFactory):
    FACTORY_FOR = pyohio_proposals.Proposal

    audience_level = factory.fuzzy.FuzzyChoice([
        pyohio_proposals.Proposal.AUDIENCE_LEVEL_NOVICE,
        pyohio_proposals.Proposal.AUDIENCE_LEVEL_EXPERIENCED,
        pyohio_proposals.Proposal.AUDIENCE_LEVEL_INTERMEDIATE,
    ])
    recording_release = factory.fuzzy.FuzzyChoice([True, False])


class TalkProposalFactory(ProposalFactory):
    pass


class TutorialProposalFactory(ProposalFactory):
    pass


class OpenSpaceProposalFactory(ProposalFactory):
    pass
