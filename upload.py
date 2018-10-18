#!/usr/bin/env python

import requests
import os
import sys

url = 'http://[app-name].herokuapp.com/_api/pages.create'
pukiwiki_root = "wiki_mod/wiki"
access_token = "[Access Token]"

args = sys.argv
if len(args) != 2:
    print('Usage: upload.py [dir]')
    exit(1)

for root, dirs, names in os.walk(pukiwiki_root):
    for fn in names:
        fpath = os.path.join(root, fn)
        fn_base, ext = os.path.splitext(os.path.relpath(fpath,start=pukiwiki_root))
        body = u''
        with open(fpath, 'r') as f:
            body = f.read()

        data = {"access_token": access_token,
                "path": "/" + args[1] + "/" + fn_base,
                "body": body}

        rsult = requests.request(method='post', url=url, data=data)
        if rsult.status_code != requests.codes.ok:
            print("Error! status code : " + str(rsult.status_code))
            sys.exit(1)
        print(rsult.text)
