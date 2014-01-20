from distutils.core import setup


setup(
    name='pycon',
    version='2014',
    packages=['pyohio.pyohio_proposals',
              'symposion', 'symposion.cms', 'symposion.boxes',
              'symposion.boxes.templatetags', 'symposion.teams',
              'symposion.teams.templatetags', 'symposion.utils',
              'symposion.reviews', 'symposion.reviews.management',
              'symposion.reviews.management.commands',
              'symposion.reviews.templatetags', 'symposion.schedule',
              'symposion.speakers', 'symposion.speakers.management',
              'symposion.speakers.management.commands', 'symposion.proposals',
              'symposion.proposals.templatetags', 'symposion.conference',
              'symposion.sponsorship', 'symposion.sponsorship.templatetags'],
    url='https://github.com/pyohio/pyohio/',
    license='LICENSE',
    author='',
    author_email='',
    description=''
)
