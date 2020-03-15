"""
Scrape custom emojis from a given mastodon instance
"""

import argparse
import os
import json
import re
from urllib import request

parser = argparse.ArgumentParser(description='Scrape custom emojis from mastodon servers to import/')
parser.add_argument('instance',help='instance to scrape')
args = parser.parse_args()
instance = args.instance
print(instance)
basepath="import/"

data = request.urlopen("https://" + instance + "/api/v1/custom_emojis")
emojis = json.loads(data.read())

regex=r".*\/.*\.(png|jpeg|jpg)"

for emoji in emojis:
	url=emoji['url']
	shortcode=emoji['shortcode']
	category = 'uncategorized'	

	if 'category' in emoji:
		category = emoji['category']

	print(url)
	ext=re.findall(regex, url)[0]

	if not os.path.isdir(basepath + instance + '/' + category):
		os.makedirs(basepath + instance + '/' + category)
	
	filepath=basepath  + instance + '/' + category + '/'+ shortcode + '.' + ext
	print(filepath)
	with open(filepath, 'wb') as f:
		response = request.urlopen(url)
		f.write(response.read())




