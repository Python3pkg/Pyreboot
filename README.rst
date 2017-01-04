Pyreboot
--------

small python library, that allow developers to reboot, power off, others..  a computer
as easy as it sounds, from python code and you can add any beheavior that you
want before rebooter executes.


How to install Install
----------------------
```
pip install Pyreboot
```

Requirements
------------
* Cython
* Linux Operating System (not tested on Mac yet.)


Usage
-----

```python

from Pyreboot import *


_powerOff = NotifyRebooter.RebootCodes.power_off
_title = 'Power Off'
_message = 'powering off your system'

rebooter = NotifyRebooter(_powerOff, _title, _message)
rebooter.start()

```


License
-------
Copyright (c) 2017 Leonardo Javier Esparis Meza and individual contributors. All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

   1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

   2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

   3. Neither the name of Django nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


Contributors
------------
* Leonardo Javier Esparis Meza <leoxnidas.c.14@gmail.com>


Author
-----
* Leonardo Javier Esparis Meza <leoxnidas.c.14@gmail.com>


Version 1.0
-----------
* First commit.
* [fix] changed README.md to README.rst to avoid FileNotFOundError

