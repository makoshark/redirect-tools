MediaWiki Redirect Tools
=======================================================================

  | **Author:** `Benjamin Mako Hill`__ <mako@atdot.cc>
  | **Homepage:** http://networkcollectiv.es/wiki-redirects/
  | **License:** `GNU GPLv3 or any later version`__ (see COPYING)
  | **Description:** Tools to to generate a redirect spells dataset from "raw" MediaWiki XML dumps like those published by the Wikimedia foundation.

__ http://mako.cc/
__ http://www.gnu.org/copyleft/gpl.html

If you use this software for research, please **cite the following
paper** in any resulting publication:

  *Hill, Benjamin Mako and Aaron Shaw. "Consider the Redirect:  A Missing
  Dimension of Wikipedia Research." In Proceedings of the 10th International
  Symposium on Open Collaboration (OpenSym 2014). ACM Press, 2014.*

**Overview:**

To use these tools, you will need need to start with a MediaWiki dump
file. For Wikimedia Foundation projects, you can download them all from:
http://dumps.wikimedia.org/

Wikis from Wikia.com and other Wikimedia projects all use the same XML format
for their projects.

In the examples in this README, I will use a dump of `Simple English
Wikipedia`__ that I downloaded with the following command::

  wget http://dumps.wikimedia.org/simplewiki/20140410/simplewiki-20140410-pages-meta-history.xml.7z

__ https://simple.wikipedia.org/

Before you start, you may also want to change the default directories
for writing intermediate output files.  The default directories for
writing and reading files are at the top of the file `redirect_tools.R`
and can be changed by editing that file. By default, all files will be
written to the subdirectory "./output" in the local directory. If you
want to use the default directories, you will still need to create them
with a command like this::

  mkdir output/redir output/spells

Step 2: Find Redirects in Revisions
=======================================================================

Dependencies:

- Python 2.7
- Wikimedia Utilities (https://bitbucket.org/halfak/wikimedia-utilities)

Input: 

- Wikimedia XML Dump files (compressed in some form)

Output:

- bzip2 compressed TSV files (one line per revision)

Run the file `01-extract_redirects.py` to build a dataset of revisions or edits
that marks every revisions as either containinig a revision, or not.

The script `01-extract_redirects.py` takes a MediaWiki dump file on STDIN and
outputs a TSV file on STDOUT of the following form.

+---------+-------------+--------------------------------+------------+---------+----------+--------------------+
| page.id | revision.id | page.title                     | timestamp  | deleted | redirect | target             |
+=========+=============+================================+============+=========+==========+====================+
| 1935456 | 17563584    | Mikhail Alekseevich Lavrentiev | 1116962833 | FALSE   | FALSE    | NA                 |
| 1935456 | 22034930    | Mikhail Alekseevich Lavrentiev | 1125245577 | FALSE   | TRUE     | Mikhail Lavrentyev |
+---------+-------------+--------------------------------+------------+---------+----------+--------------------+


In this case, the first revision of the article "Mikhail Alekseevich
Lavrentiev" was not a redirect but the second is a redirect to "Mikhail
Lavrentyev".

If you were using the Simple English dump (which is a single file) I would
run the following command to send the output to the default ::

  7za x -so simplewiki-20140410-pages-meta-history.xml.7z | 
  python2.7 01-extract_redirects.py | bzip2 -c - > output/redir/simple_redirs.tsz.bz2

Because our dumpfile is 7z compressed, I used 7za to uncompress it. If I had
used a gzip or bzip compressed file, I would use `zcat` or `bzcat` instead. I'm
also catting the output to `bzip2 -c` which will bzip the TSV output to
conserve space. The next step assumes a bzip2 compressed file. If you don't
want to bzip2 compress, you'll need to modify the code.


Step 2: Generate spells
=======================================================================

Dependencies:

- GNU R
- data.table (http://cran.r-project.org/web/packages/data.table/)
- foriegn (http://cran.r-project.org/web/packages/foreign/)

Input: 

- bzip compressed TSV files 

Outp1ut: 

- RData files containing data.frame of redirect spells named `redirect.spell`
  (one file per input file)
- Stata DTA file (same data)
- TSV file (same data)

The file `redirect_tools.R` contains an R function `generate.spells()` that
takes a data frame of edit data as created in step 1 and a list of page title
and which will create a list of redirect spells for those pages.  It also
contains a function `filename.to.spells()` which takes the filename of a bzip
compressed file of the form created in step 1 and outputs a full list of
redirect spells.

You can run the command with::

  R --no-save < 02-generate_spells.R

By default, output will be saved into `output/spells`.

The 

Running Code in Parallel
=======================================================================

Because the full history dumps from the WMF foundation are split into many
files, it is can be appropriate to parse these dumps in parallel. Although the
specific ways you choose to do this will vary by the queuing system you use,
we've included examples of the scripts we used with Condor on the Harvard/MIT
Data Center (HMDC) in the "examples/" directory. They will not work without
modification for your computing environment because they have our environment
hardcoded in but they will give you an idea of where you might want to start.

Additionally, there is a third step `03-assemble_redirect_spells.R` that
contains R code that will read in all of the separate RData files, assmebles
the many smaller dataframes into a single data.frame, and then saves that
unified data.frame into a single RData file.

