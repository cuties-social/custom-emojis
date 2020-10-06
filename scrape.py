#!/usr/bin/python3
"""
Scrape custom emojis from a given mastodon instance
"""

import argparse
import os
import re
import requests

parser = argparse.ArgumentParser(description='Scrape custom emojis from mastodon servers to import/')
parser.add_argument('instance',help='instance to scrape')
args = parser.parse_args()
instance = args.instance
print(instance)
basepath="import/"

emojis = requests.get("https://" + instance + "/api/v1/custom_emojis").json()

regex=r".*\/.*\.(png|jpeg|jpg|gif)"

for emoji in emojis:
	url=emoji['url']
	shortcode=emoji['shortcode']
	category = 'uncategorized'	

	if 'category' in emoji and emoji['category']:
		category = emoji['category']

	print(url)
	ext=re.findall(regex, url)[0]

	if not os.path.isdir(basepath + instance + '/' + category):
		os.makedirs(basepath + instance + '/' + category)
	
	filepath=basepath  + instance + '/' + category + '/'+ shortcode + '.' + ext
	print(filepath)
	with open(filepath, 'wb') as f:
		f.write(requests.get(url).content)

