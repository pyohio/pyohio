from django.test import TestCase


class HomepageTestCase(TestCase):
    fixtures = [
        'fixtures/conference.json',
        'fixtures/initial_data.json',
        'fixtures/proposal_base.json',
        'fixtures/sitetree.json',
        'fixtures/sponsor_benefits.json',
        'fixtures/sponsor_levels.json'
    ]

    # Sanity check. Spectacularly fails with a vague Sitetree error if
    # CONFERENCE_ID is not set properly.
    def test_homepage_response_code(self):
        response = self.client.get('/')
        self.assertEqual(response.status_code, 200)
