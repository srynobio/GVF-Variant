#GVF DB PROJECT

Requirements:
```
        DBIx::Class
        DBIx::Class::Schema::Loader
        tabix
```

* Using DBIx::Class to add the data to the database.
* Used DBIx::Class::Schema::Loader to add sql schema to the database.  This is a mapper, which orders relationships between tables and creates classes based on sql schema.

##Command line example:
```  
  dbicdump -o dump_directory=  -o components='["InflateColumn::DateTime"]' -o preserve_case=1 GVF::DB::Variant dbi:mysql:database=GVF_DB_Variant USER PASSWORD '{ quote_char => "`" }'
```

* Used Tabix for the addition of 1000G file (chrY not included).  Tabix requires sorting based on location name and genome position. Try doing this by command line alone,
  but tabix would not accept the file, so had to sort individually based on chromosome, then concatenate the file:

  commands used:
  example:  
```  
  grep '\bchr#\b' 1000G_file |sort -k2n > <file>
  cat [list of chr files] >file
  bgzip file >file.gz
  tabix -p vcf file.gz  # vcf was best option based on file type.
```

##Directory structure:
```
  bin/
                Contains all the files needed to add a GVF to the database.  
                GVFParser.pl is the main script used to add data.
                TabixToDB.pl is used by GVFParser, it finds match to 1000k genomes/cosmic files.
                GenomeValadator.pl to check that the file is hg19 build.
                CosmicToGVFParser.pl builds GVF file from Cosmic file v56
  data/
                Has various data, GVF/Cosmic, and fasta file for validator
 
  lib/
                Use and created by DBIx::Class

  mysql/
                Has MySQL schema used this project
                
  tabix/
                Contains the tabix created files.
                
```
