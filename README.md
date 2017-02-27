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
- Georges, K.E., and Georges, H. 1913-1918. Ausführliches Lateinisch-Deutsches Handwörterbuch. Hahn, Hannover.
- Glare, P.G.W. 1982. Oxford Latin Dictionary. Oxford University Press, Oxford.
- Gradenwitz, O. 1904. Laterculi Vocum Latinarum. Hirzel, Leipzig.

ONOMASTICON: 26,415 lemmas from the Onomasticon of Forcellini, E. 1940. Lexicon Totius Latinitatis. Typis Seminarii, Padova.

At the first prompt the full list of the available commands is provided:
```
	\h to show the list of available commands 
	\q to QUIT 
	\B to select BASE LES source 
	\O to select ONOMASTICON LES source 
	\A to select ALL LES source 
	\a to output in 'lemresult' FILE 
	\d to output on SCREEN 
```
You can always recall such list by entering the command `\h`.

### Batch Mode
You can process a batch of worform entering an input file conataining the wordforms you wish to analyze and an output file in a specified format by typing:
```
./APPLICATION_NAME [-s 0|1|2] -i input_file_name -o|-c|-x output_file_name 
```
As for the interactive mode the input parameter -s allows to select the LES source to use for the processing.
The ouput file format is specified according to the preceding input parameter:
```
 -o for plain text format
 -x for XML format
 -c for CSV format
``` 
The three different formats bear different information as well: the plain text format is an exact copy of the information displayed in the interactive mode, in the xml output file there is the complete analysis, in the  CSV output files are reported anly the information about the lemma(s) each analyzed wordforms is referring to. 
The list of not analuzed worforms is reported in an outpute text file having the same name of the input file plus the expension '.unk'

