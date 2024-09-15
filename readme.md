# decwar

historic fortran, macro, and teco code running on simh pdp10 with standard tops10. here's [game instructions](decwar.md), the excellent [decwar wikipedia page](https://en.wikipedia.org/wiki/Decwar), the [utexas center for american history](https://briscoecenter.org/) [catalog info](https://repositories.lib.utexas.edu/items/7e2ccf50-e814-4bce-91d2-a7f6440eabe4), and a 1982 letter from utexas to compuserve, before utexas sent the primordial decwar tape.

_I have received your request for sources to the DECWAR program. We will be pleased to send you the sources, but first we must ask you to sign and return the enclosed license agreement. DECWAR was developed at the University of Texas at Austin, and it is being maintained. Hence our interest in using the agreement to record and control who gets the source to it._

_DECWAR is a sophisticated real-time space battle game designed to be played by from 1 to 18 people. It was written at the University of Texas at Austin, primarily by Jeff Potter and Bob Hysick. The game was originally based on a very limited, single job, single terminal, two player Star Trek type game known as WAR. This game came from the CDC-6600/6400 system at the University of Texas at Austin, author unknown. Robert Schneider re-wrote the original source on the CDC and started the transfer to the DEC-10. In the transfer process, the game was renamed to DECWAR, largely re-designed, and almost entirely re-written, so that the current version bears little resemblance to the original. Almost all the commands were added once the game was on the DEC-10, as well as the basic concept of separate jobs controlling each ship, and most of the other features that make the game challenging, exciting, and enjoyable. The first version was installed on the DEC-10 in August 1978. After several revisions, a greatly enhanced and improved game, version 2.0, was installed in July 1979._

# folder structure
    
- utexas folder reflects the contents of utexas/decwar.imp and the primordial tape sent from utexas to compuserve
  - utexas/tec are teco files for extracting fortran from macro
  - utexas/hlp are files used as part of building the game's help system
- compuserve folder is fortran and macro files likely associated with compuserve
  - compuserve/docs folder is files associated with compuserve documenting the primordial tape's arrival from utexas. also some related 'operational' files. decwar.map has logging from a compuserve ki10 dated 19820519.
- deploy folder is files expected for 'deploying' the built game. these are generated, for example see utexas/hlp
- scripts folder is build automations
- docs are notes from 2024 forward
  - docs/misc are miscellaneous tops-10 related things

# docs

- [section 1, boot disk](docs/sec1-boot-disks.md)
- [section 2, kermit](docs/sec2-kermit.md)
- [section 3, prep source files](docs/sec3-prep-source-files.md)
- [section 4, building decwar](docs/sec4-compiling-decwar.md)
- [section 4a, build files](docs/sec4a-build-files.md)
- [section 4b, continuation line issue](docs/sec4b-continuation-line-issue.md)
- [section 5, minimalist walkthrough](docs/sec5-minimalist-walkthrough.md)
- [appendix 0, foundations](docs/app0-foundations.md)
- [appendix 1, tops-10 versions](docs/app1-tops-10-versions.md)
- [appendix 2, tap files](docs/app2-tap-files.md)
- [appendix 3, sos](docs/app3-sos.md)

# special thanks to merlyn

here's the original note from merlyn concerning the work he did to get things working on simh pdp10.

_all changes commented and additions noted by DrForbin AKA Merlyn Cousins. search for (drforbin), all things yet to be fixed, search (tofix)_
    
here's [more info](docs/app0-foundations.md) from merlyn around that.
