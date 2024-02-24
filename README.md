# exercism-exercise-and-unit-tests-sample-for_DCL-Lite
> Sample exercises, unit tests, and test library, for proposed Exercism track, DCL-Lite

|||
| :---     | :--- |
| author:  | Anthony J. Borla |
| contact: | [ajborla@bigpond.com](ajborla@bigpond.com) |
| license: | MIT |

## Overview

### DCL
_DCL_ is an acronym for [DIGITAL Command Language](https://en.wikipedia.org/wiki/DIGITAL_Command_Language), the language of the command line interpreter (CLI) used in the [OpenVMS](https://en.wikipedia.org/wiki/OpenVMS) operating system.

_DCL_ dates back to 1978, making it one of the earliest [command languages](https://en.wikipedia.org/wiki/Command_language). Such a language is similar to a scripting language like _Perl_ or _Python_, but with an emphasis on interactivity, and ready access to operating system resources.

_DCL_ may be most closely likened to the language of [CMD](https://en.wikipedia.org/wiki/Cmd.exe), the standard Windows CLI, with which it shares a number of similarities, or, more distantly, to that of [bash](https://en.wikipedia.org/wiki/Bash_(Unix_shell)), the standard CLI on Linux systems.

Writing, and executing, a command file / script, in any of the abovementioned CLI's is a very similar process.

### DCL-Lite
Although _DCL_ is primarily used on the _OpenVMS_ platform, it has been ported to other platforms, including _DOS_, _Windows_, and _Linux_. This effort has mostly been conducted by commercial organisations seeking to provide proprietary tools to facilitate the migration of _OpenVMS_ applications to these other platforms.

[DCL-Lite](https://jonesrh.info/dcll/dcll_why_i_use.html#products_terms_vms_dcl) is one such product. It is a feature-reduced, **freely downloadable**, version of a commercial product that is no longer marketed. It is a faithful, robust implementation of _DCL_. All the key features of the language have been retained, but important utilities are missing, and the ability to perform file I/O has been disabled.

Putting this into perspective, its utility as an interactive tool mimicing _OpenVMS_ idioms to manage system resources, has been substantially diminished. However, its usefulness as a vehicle for implementing Exercism exercises using _DCL_ idioms, remains intact.

### Test Library
A _DCL_-native unit test framework / library, reliant on the presence of certain (missing) utilities could not be used. Further, a custom, _DCL_-native implementation was ruled out by missing file I/O facilities.

Instead, a custom _bash_-based solution, comprising 23 lines of code, was used. This code consists of 3 functions, and is hosted in the `DCLUNIT` file.

Using `source`, the file is included in each test script, and the set of test parameters there contained, executed.

The set of 21 included exercises have been reliably tested using this small library. Planned extensions (contingent on acceptance of _DCL-Lite_ as an Exercism track) include:
* Emit TAP-compliant output
* Emit Exercism spec-compliant JSON output

## Installation
The unit test library, unit tests, and Exercism exercises, are all resident in the current repository, and require no installation.

_DCL-Lite_ requires separate installation. It is available for various platforms, including various *NIX, Linux and Windows, although only the last two will be covered here.

### Linux Installation
The archive has, for several years, been hosted on the DECUS website, and is obtainable via:

```plain
curl -sLk http://www.decuslib.com/decus/vmslt01b/net/dcll_i386_linux_221.tar > dcll_i386_linux_221.tar
```

To point to the `dcll_i386_linux_221` directory, ready for installation, do:

```plain
gzip -dv dcll_i386_linux_221_tar.gz
mv dcll_i386_linux_221_tar dcll_i386_linux_221.tar
mkdir dcll_i386_linux_221 && cd dcll_i386_linux_221 && tar -xvf ../dcll_i386_linux_221.tar
```

Should sourcing the archive prove problematic, an alternative is to clone the following repository:

`git clone https://github.com/johnsonjh/Open-DCL-Lite`

and point to the `dcll_i386_linux_221` directory, ready for installation:

`cd Open-DCL-Lite/dcll_i386_linux_221`

In both cases, issuing: `sudo ./install` will install the application.

A `Hello, World!` string appearing on the console after issuing the following command:

```plain
dcll -c 'write Sys$Output "Hello, World!"'
```

is indicative of a successful installation.

### Windows Installation
A Windows installation is normally performed using an installer executable. One _is_ available, but it only executes on older Windows versions such as Windows XP.

Therefore, the only way to effect an installation on _newer_ Windows platforms is to first do so, via the installer, on an older Windows version, then manually copy the files to the target platform.

To obtain the installer, clone this website:

`git clone https://github.com/johnsonjh/Open-DCL-Lite`

The installer will be found:

`Open-DCL-Lite\dist\dcllite_setup_221.exe`

Successful execution (on Windows XP) will see the application installed into the following directory:

`C:\Progra~1\accelr8\dcll`

On the target platform, create the following directory structure:

`C:\Progra~2\accelr8\dcll`

and copy the installed files across. Add the new directory to the `PATH` environment variable, and, from a _Command Prompt_, test the installation:

A `Hello, World!` string appearing on the console after issuing the following command:

```plain
dcll -c "write Sys$Output """Hello, World!""" "
```

is indicative of a successful installation.

Please note the unit tests and exercises assume a *NIX / Linux environment. These _should_ execute under _Git for Windows_, or similar, emulation environment. The exercises using the `shell` command may, however, fail depending on the command string issued.

## Usage
Assuming command-line operation, and that the current directory points to a clone of this repository, the unit tests for an exercise, for example, the `leap` exercise, may be effected by invoking the `leap-test` script, like so:

```plain
./leap-test
```

A successful execution will see generation of the following output:

```plain
OK - Year not divisible by 4: common year
OK - Year divisible by 2, not divisible by 4 in common year
OK - Year divisible by 4, not divisible by 100: leap year
OK - Year divisible by 4 and 5 is still a leap year
OK - Year divisible by 100, not divisible by 400: common year
OK - Year divisible by 100 but not by 3 is still not a leap year
OK - Year divisible by 400: leap year
OK - Year divisible by 400 but not by 125 is still a leap year
OK - Year divisible by 200, not divisible by 400 in common year
OK - No input should return an error
OK - Too many arguments should return an error
OK - Float number input should return an error
OK - Alpha input should return an error
```

Continuing the current example, `leap.com`, is the exercise file. Note the `.com` extension (short for _command_); it contains the _DCL_ code under test (CUT).

The accompanying file, `leap-test` is the test file, and contains _bash_ code. It is structured as follows:

```bash
#!/usr/bin/env bash

#
# Load unit test routines
#
. DCLUNIT

#
# Perform tests. Overall test status returned
#
runtests << EOF
Year not divisible by 4: common year^==^0^false^leap 2015
Year divisible by 2, not divisible by 4 in common year^==^0^false^leap 1970
Year divisible by 4, not divisible by 100: leap year^==^0^true^leap 1996
Year divisible by 4 and 5 is still a leap year^==^0^true^leap 1960
Year divisible by 100, not divisible by 400: common year^==^0^false^leap 2100
Year divisible by 100 but not by 3 is still not a leap year^==^0^false^leap 1900
Year divisible by 400: leap year^==^0^true^leap 2000
Year divisible by 400 but not by 125 is still a leap year^==^0^true^leap 2400
Year divisible by 200, not divisible by 400 in common year^==^0^false^leap 1800
No input should return an error^==^1^ERROR: Invalid arguments. USAGE: @leap year^leap
Too many arguments should return an error^==^1^ERROR: Invalid arguments. USAGE: @leap year^leap 2016 4562 4566
Float number input should return an error^==^1^ERROR: Only positive numbers allowed. USAGE: @leap year^leap "2016.54"
Alpha input should return an error^==^1^ERROR: Only positive numbers allowed. USAGE: @leap year^leap "abcd"
EOF
```

The test script first sources the test library, then proceeds to feed the HEREDOC to the `runtests` function. Each line of the HEREDOC is a unit test, and each **_^_**-separated component, a test parameter.

While **_^_** may seem an unusual choice for a separator:

* It was necessary to avoid the use of both single and double quotes in test parameters (except for the right-most parameter)
* Strings with spaces still had to be accommodated
* No separator likely to appear within a test string, such as ',' or ';' or ':', could be used

Note that tests may be commented out (using **_#_** at the start of a HEREDOC line), modified, and new tests added.

## Acknowledgements
The author frequently referred to, and adapted, the unit tests in the [Exercism Bash Track](https://exercism.org/tracks/bash). Many thanks to the authors of those tests for their work, particularly, the clarity of test names, and the addition of extra tests.

Profound thanks, also, to [Richard H. Jones](https://jonesrh.info), for sharing his extensive, detailed research on DCL-Lite. This information is nothing short of priceless.

## TODO
Assuming acceptance of this proposal, commence working on the newly-created repositories:

`https://github.com/exercism/dcllite`

and:

`https://github.com/exercism/dcllite-test-runner`

The author expects to effect the transference of current repository contents to the new track.

However, should there be interest, welcomes contributions in the form of new exercises. These should be quite straightforward to implement since committed exercises may be used as templates.

