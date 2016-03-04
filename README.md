# Overview
Yale Library holds a large collection of theatrical programs from the Yale Repertory Theatre, the School of Drama, and other organizations on campus.

This repo is the basis of an experiment to build a [Scribe-based system](https://github.com/zooniverse/scribeAPI) to crowdsource the transcription of semantic relationships from these material.

# Ingestion and Data Prep Scripts
Files in `scripts/` are for ingesting data from Yale's file servers. They process both the cataloging metadata as well as transform the TIFs from the scanners.

# EnsembleAtYale project
Files in `EnsembleAtYale/` comprise a Scribe [Project](https://github.com/zooniverse/scribeAPI/wiki/Creating-Your-Project) for Yale theatrical programs.  This folder should go in the `project/` directory of a ScribeAPI instance.
