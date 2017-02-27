# About

Contribution to the morphological analyser of Latin LEMLAT 3.0 provided by the CIRCSE Research Centre.


# Database

- lemlat_db.sql: MySQL database dump used by LEMLAT 3.0 to process wordforms. All tables are released under CC-BY-NC-SA 4.0 (https://creativecommons.org/licenses/by-nc-sa/4.0/)
- lemlat_documentation.pdf: description of the tables of lemlat_db and of the overall process of wordform analysis


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
./APPLICATION_NAME [-s 0|1|2]
```
to start the application in interactive mode.

You will be iteratively promted to enter a single worform to process or a command to modify the behavior of the analyser.
The optional parameter `-s` allows to select the lexical basis to use, according to the following input values:
```
     	0 for BASE
     	1 for ONOMASTICON
     	2 for BASE + ONOMASTICON [default option]
```
BASE: lexical basis resulting from the collation of three Latin dictionaries (40,014 lexical entries; 43,432 lemmas):
- Georges, K.E., and Georges, H. 1913-1918. *Ausführliches Lateinisch-Deutsches Handwörterbuch*. Hahn, Hannover.
- Glare, P.G.W. 1982. *Oxford Latin Dictionary*. Oxford University Press, Oxford.
- Gradenwitz, O. 1904. *Laterculi Vocum Latinarum*. Hirzel, Leipzig.

ONOMASTICON: 26,415 lemmas from the Onomasticon of Forcellini, E. 1940. *Lexicon Totius Latinitatis*. Typis Seminarii, Padova.

At the first prompt the full list of the available commands is provided:
```
	\h to show the list of available commands 
	\q to QUIT 
	\B to select BASE source 
	\O to select ONOMASTICON source 
	\A to select BASE + ONOMASTICON source 
	\a to write output in 'lemresult' FILE 
	\d to write output on SCREEN 
```
You can always recall such list by entering the command `\h`.

### Batch Mode
You can process a batch of worforms by entering an input file featuring the wordforms to analyse and an output file in a specified format by typing:
```
./APPLICATION_NAME [-s 0|1|2] -i input_file_name -o|-c|-x output_file_name 
```
Like for the interactive mode, the input parameter `-s` allows to select the lexical basis to use.

The format of the output file is specified according to the following input parameters:
```
 -o for plain text format
 -x for XML format
 -c for CSV format
``` 
The three different formats provide different information:
- the plain text file reports exactly the same information displayed in the interactive mode
- the XML file includes the complete analysis for each wordform
- the CSV file assigns to each wordform its lemma and Part of Speech (basic lemmatization). If one wordform is assigned more than one lemma, these are provided on separate lines. The Part of Speech is given both by using the [tagset of LEMLAT](http://www.lemlat3.eu/wp-content/uploads/2016/10/LEMLAT3.0-tagset_english.pdf) and the so called CODLEM (see [page 29 of LEMLAT database description](http://www.lemlat3.eu/wp-content/uploads/2016/10/LEMLAT3_database_description.pdf))

The list of the unknown worforms is provided in a separate plain text file with the same name of the input file and the extension '.unk'.

