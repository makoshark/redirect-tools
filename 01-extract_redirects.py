#!/usr/bin/env python27

from wmf import dump
import sys
import re

dumpIterator = dump.Iterator(sys.stdin)

print(u"\t".join(["page.id", "revision.id", "page.title", "timestamp", "deleted", "redirect", "target"]))

for page in dumpIterator.readPages():
   #Do things with a page
   #like extract it's title: page.getTitle()
   #or it's ID: page.getId()
   
   for revision in page.readRevisions():
      rev_data = []

      rev_data.append(unicode(page.getId()))
      rev_data.append(unicode(revision.getId()))
      rev_data.append(unicode(page.getTitle()))
      rev_data.append(unicode(revision.getTimestamp()))

      text = revision.getText()
     
      if text == None:
          rev_data.append("TRUE") # revision was deleted
          rev_data.append("NA") # redirect bool = unknown
          rev_data.append("NA") # redirect target missing
      else:
          rev_data.append("FALSE") # revision was not deleted
          match = re.match(r"^#redirect \[\[(.*)\]\]", text, re.IGNORECASE)
          if match:
              target = match.group(1)
              rev_data.append("TRUE") # redirect bool = TRUE
              rev_data.append(target) # redirect target
          else:
              rev_data.append("FALSE") # redirect bool = FALSE
              rev_data.append("NA") # redirect target missing

      print(u"\t".join(rev_data).encode("utf-8"))
