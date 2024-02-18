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

## Installation
## Usage

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

