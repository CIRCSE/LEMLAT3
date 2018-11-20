# About

Contribution of the [CIRCSE Research Centre](https://centridiricerca.unicatt.it/circse_index.html) to the Latin morphological analyzer and lemmatizer **LEMLAT 3.0**.

To cite all versions of LEMLAT 3.0, you can adapt the following:

>Marco Passarotti, Paolo Ruffolo, Flavio M. Cecchini, Eleonora Litta, Marco Budassi (2018) LEMLAT 3.0. DOI: https://doi.org/10.5281/zenodo.1492133

DOIs for the individual releases of LEMLAT 3.0 are available here: [![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.1492133.svg)](https://doi.org/10.5281/zenodo.1492133)

# Database

- lemlat_db.sql: MySQL database dump used by LEMLAT 3.0 to process wordforms. All tables are released under CC-BY-NC-SA 4.0 (https://creativecommons.org/licenses/by-nc-sa/4.0/)
- lemlat_documentation.pdf: description of the tables of lemlat_db and of the overall process of wordform analysis


# Build environment

Source code and build enviroments are in the folder 'lemlat_workspace':
- Makefiles and packeging scripts for GNU/Linux and OSX are in sub-folder 'lemlat_workspace/Lemlat_client'
- A Visual C solution is in sub-folder 'lemlat_workspace/winBuild'

Mysql binaries are needed to build up the embedded databases


# Binaries

In the bin directory we provide a CLI implementation of the wordform analysis for Linux, OSX an Windows operation systems.
Two versions are made available:
- a client version, which requires a working MySQL server containing the provided database
- a stand alone version, which uses an embedded version of the database

## Client installation

### Prerequisite
In order to use this version you need a working copy of MySQL Server in which the provided dump of the database is restored.
 
- download the archive containing the client version for your operation system
- extract the archive and open a console in the extracted directory
- edit the configuration file `my.cnf.sample` providing the information needed to access the database and save it as `my.cnf`

## Stand alone installation
- download the archive containing the embedded version for your operation system
- extract the archive and open a console in the extracted directory


## Usage
Both the client version and the stand-alone version use the same CLI interface. So, in the following replace `APPLICATION_NAME` either with `lemlat_client` or with `lemlat` according to the version you are using. For Windows do not use the initial `./`

### Get help
Type:
```
./APPLICATION_NAME -h
```
to show basic usage information.

### Interactive mode
Type:
```
./APPLICATION_NAME [-s 0|1|2|3]
```
to start the application in interactive mode.

The optional parameter `-s` allows to select the lexical basis to use, according to the following input values:
```
     	0 for BASE
     	1 for ONOMASTICON
     	2 for DU CANGE
     	3 for ALL lexical bases [default option]
```
BASE: lexical basis resulting from the collation of three Latin dictionaries (40,014 lexical entries; 43,432 lemmas):
- Georges, K.E., and Georges, H. 1913-1918. *Ausführliches Lateinisch-Deutsches Handwörterbuch*. Hahn, Hannover.
- Glare, P.G.W. 1982. *Oxford Latin Dictionary*. Oxford University Press, Oxford.
- Gradenwitz, O. 1904. *Laterculi Vocum Latinarum*. Hirzel, Leipzig.

ONOMASTICON: 26,415 lemmas from the Onomasticon of Forcellini, E. 1940. *Lexicon Totius Latinitatis*. Typis Seminarii, Padova.

DU CANGE: 82,557 lemmas from the Medieval Latin Glossary by Charles du Fresne Du Cange, Bénédictins de Saint-Maur, Pierre Carpentier, Louis Henschel, and Léopold Favre. 1883–1887. *Glossarium mediae et infimae latinitatis*. Niort.

For instance, in Windows, type:
```
lemlat.exe
```

If you want to select just the ONOMASTICON lexical basis, type:
```
lemlat.exe -s 1
```

You will be iteratively prompted to enter a single wordform to process or a command to modify the behavior of the analyzer.
At the first prompt the full list of the available commands is provided:
```
	\h to show this HELP 
	\q to QUIT 
	\B select BASE LES source 
	\O select ONOMASTICON LES source 
	\D select DU CANGE LES source
	\A select ALL LES source 
	\a to output in 'lemresult' FILE 
	\d to output on SCREEN 
```
You can always recall such list by entering the command `\h`. To exit LEMLAT 3.0, type `end`.

### Batch Mode
You can process a bunch of wordforms by entering an input file featuring the list of wordforms to analyze. A full text can also be given in input. Processing an input file is performed by typing

```
./APPLICATION_NAME [-s 0|1|2|3] -i input_file_name -o|-c|-x output_file_name 
```
Like for the interactive mode, the input parameter `-s` allows to select the lexical basis to use.

The format of the output file is specified according to the following input parameters:
```
 -o for plain text format
 -x for XML format
 -c for CSV format
``` 
The three different formats provide different information:
- the plain text file reports exactly the same information displayed in the interactive mode. For each analysis of a processed wordform, it provides
	- segmentation into formative elements
	- morphological features, according to the [tagset of LEMLAT](http://www.lemlat3.eu/wp-content/uploads/2016/10/LEMLAT3.0-tagset_english.pdf)
	- lemma with PoS. PoS is provided both according to the [tagset of LEMLAT](http://www.lemlat3.eu/wp-content/uploads/2016/10/LEMLAT3.0-tagset_english.pdf) and according to the CODLEM (see [page 29 of LEMLAT database description](http://www.lemlat3.eu/wp-content/uploads/2016/10/LEMLAT3_database_description.pdf))
	- information about the derivational process of each morphologically derived lemma. See the [Word Formation Latin project](http://wfl.marginalia.it/) for details  
- the XML file includes the complete analysis for each wordform organized into explicitly named elements and attributes
- the CSV file assigns to each wordform its lemma and Part of Speech (basic lemmatization). If one wordform is assigned more than one lemma, these are provided on separate lines. The Part of Speech is given both by using the [tagset of LEMLAT](http://www.lemlat3.eu/wp-content/uploads/2016/10/LEMLAT3.0-tagset_english.pdf) and the CODLEM (see [page 29 of LEMLAT database description](http://www.lemlat3.eu/wp-content/uploads/2016/10/LEMLAT3_database_description.pdf)). The format of the CSV file is the following:
	- input wordform
	- processed wordform
	- lemma
	- PoS: CODLEM
	- n_id of the lexical entry in the database of LEMLAT
	- gender (for nouns only; * for adjectives)
	- PoS: tagset of LEMLAT

The list of the unknown wordforms is provided in a separate plain text file with the same name of the input file and the extension '.unk'.

For instance, in Windows, type:
```
lemlat.exe -s 1 -i cicero.txt -c cicero_lemmatized.txt
```
for using the ONOMASTICON lexical basis (`-s 1`) to analyze an input text named 'cicero.txt' (`-i cicero.txt`) and output a CSV file named 'cicero_lemmatized.txt' (`-c cicero_lemmatized.txt`).
NB: in this example, it is assumed that the input file 'cicero.txt' is placed in the same folder where 'lemlat.exe' is. Otherwise, provide the full path to the input file.
