from distutils.core import setup
from setuptools import setup, find_packages

setup(
    name = 'obj805-rpi',
    version = '0.1',
    keywords = ('obj805', 'rpi'),
    description = 'rpi client of obj805',
    license = 'GPLv3',

    author = 'Johann Lee',
    author_email = 'me@qinka.pro',

    packages = find_packages(),
)