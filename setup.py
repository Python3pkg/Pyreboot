import os
import io

from setuptools import find_packages, setup
from distutils.extension import Extension

try:
    from Cython.Build import build_ext
except ImportError:
    raise RuntimeError('install Cython first')

def read(filename):
    content = ''
    with io.open(filename, encoding='utf-8') as file:
        content += file.read()
    return content

CURRENT_PATH = os.path.dirname(os.path.abspath(__file__))
NAME = 'Pyreboot'
AUTHOR = 'Leonardo Javier Esparis Meza'
AUTHOR_EMAIL = 'leoxnidas.c.14@gmail.com'
VERSION = '1.0'
HOME_URL = DOWNLOAD_URL = 'https://github.com/leoxnidas/Pyreboot'
LICENSE = 'BSD'
SHORT_DESCRIPTION = ('small python library, that allow developers to reboot'
                     'power off, others..  a computer as easy as it sounds')
PLATFORMS = ['linux']
KEYWORD = 'reboot rebooter trollrebooter gtkrebooter'
PACKAGES = ['Pyreboot']
PACKAGES_DATA = { 'Pyreboot': ['*.pyx'] }

LONG_DESCRIPTION = read(os.path.join(CURRENT_PATH, 'README.rst'))
EXT_MODULES = [
    Extension('_reboot', ['Pyreboot/_reboot.pyx'])
]
CMD_CLASS = {'build_ext': build_ext}


setup(
    name=NAME,
    version=VERSION,
    url=HOME_URL,
    download_url=DOWNLOAD_URL,
    license=LICENSE,
    description=SHORT_DESCRIPTION,
    long_description=LONG_DESCRIPTION,
    author=AUTHOR,
    author_email=AUTHOR_EMAIL,
    packages=PACKAGES,
    package_data=PACKAGES_DATA,
    keywords=KEYWORD,
    platforms=PLATFORMS,
    zip_safe=False,
    ext_modules=EXT_MODULES,
    cmdclass = CMD_CLASS,
    classifiers=[
        'Development Status :: 5 - Production/Stable',
        'Intended Audience :: Developers',
        'License :: OSI Approved :: BSD License',
        'Operating System :: OS Independent',
        'Programming Language :: Python',
        'Programming Language :: Python :: 2',
        'Programming Language :: Python :: 2.3',
        'Programming Language :: Python :: 2.4',
        'Programming Language :: Python :: 2.5',
        'Programming Language :: Python :: 2.6',
        'Programming Language :: Python :: 2.7',
        'Programming Language :: Python :: 3',
        'Programming Language :: Python :: 3.0',
        'Programming Language :: Python :: 3.1',
        'Programming Language :: Python :: 3.2',
        'Programming Language :: Python :: 3.3',
        'Programming Language :: Python :: 3.4',
        'Programming Language :: Python :: 3.5',
        'Programming Language :: Python :: 3.6',
        'Topic :: Software Development :: Libraries',
        'Topic :: Software Development :: Libraries :: Python Modules',
    ]
)
