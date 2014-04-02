#!/usr/bin/env python
# (c) 29-11-2013
# by Lilian Besson (mailto:lbessonATens-cachanDOTfr)
import json, os

pseudo = "lbesson"
os.system("curl https://bitbucket.org/api/1.0/users/" + pseudo + " > bitbucket.json")

b = json.load(open('bitbucket.json'))
for i in b['repositories']:
 print i['slug']
