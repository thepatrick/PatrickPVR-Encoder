PatrickPVR-Encoder
==========

A MacOS X program that watches a folder for .m2t files and then uses AppleScript to control the Elgato Turbo.264 HD encoder application. Included is a pair of shell scripts that do a similar thing with the Handbrake CLI (and should ultimately be included in PatrickPVR-Encoder as a fallback when the Turbo.264 HD application/usb device are unavailable).

All it does is (with a timer every minute) watches a folder, and adds any files it sees to its internal queue. It then asks the Turbo.264 HD encoder to encode the file, checks every minute to see if it is still encoding, and if not assumes it has finished. It then checks to see if the expected file was created, and if the Turbo.264 HD encoder reports an error. If all goes well it moves the file to the chosen directory and sends an AppleScript message to TVMagic2 to add the encoded file to iTunes

Notes
-----

1. This application is very very basic. It is likely not yet ready for general use, and due to the reliance on the Turbo.264 HD usb device likely to have quite limited appeal.

ToDo
--------
1. Ideally it will eventually use the Turbo.264 HD QuickTime encoder and not AppleScript so it can have actual knowledge of progress. Also that would allow for more seamless fallback to a software (e.g. Handbrake) h.264 encoder.
2. It should be configurable as to what it does with the end file. e.g. it shouldn't just do the AppleScript thing to TVMagic2, it should actually ask / have a configureable option.
3. Integrate something like HDTVtoMPEG to remove advertising.
4. Support AppleScript itself so that the PVR can just tell it to encode things rather than polling.

Requirements
------------

Tested only on Mac OS X 10.6 with the latest Elgato Turbo.264 HD encoder software.

Licence
-------

Copyright (c) 2009 Patrick Quinn-Graham

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

Acknowledgements
----------------

**RegexKitLit**
Copyright (c) 2008-2009, John Engelhart

All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright
notice, this list of conditions and the following disclaimer.

* Redistributions in binary form must reproduce the above copyright
notice, this list of conditions and the following disclaimer in the
documentation and/or other materials provided with the distribution.

* Neither the name of the Zang Industries nor the names of its
contributors may be used to endorse or promote products derived from
this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
"AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.