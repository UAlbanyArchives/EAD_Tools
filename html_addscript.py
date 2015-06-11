from lxml import etree as ET
from bs4 import BeautifulSoup as Soup
import os

path = 'C:\\Users\\gw234478\\Documents\\UID\\html_findingaids\\'
outputdir = 'C:\\Users\\gw234478\\Documents\\UID\\html_output\\'



for input_file in os.listdir(path):
	if input_file.endswith(".htm"):
	
		base = os.path.basename(input_file)
		inputdir = path + input_file
		with open (inputdir, "r") as FA:
			FA_string = FA.read().replace('\n', '')
	
		#script = "&lt;script type='text/javascript' src='http://library.albany.edu/angelfish.js'&gt;&lt;/script&gt;&lt;script type='text/javascript'&gt;agf.pageview();&lt;/script&gt;"
		#FA_output = FA_string[:554] + script + FA_string[554:]
		
		input_string = FA_string.replace(u'\xa0', u' ')
		soup = Soup(input_string)

		title = soup.find('title')
		script1 = soup.new_tag('script')
		script1['type'] = "text/javascript"
		script1['src'] = "http://library.albany.edu/angelfish.js"
		if title is None:
			print base
		title.insert_after(script1)
		script2 = soup.new_tag('script')
		script2['type'] = "text/javascript"
		new_string = soup.new_string("agf.pageview();")
		script2.append(new_string)
		title.insert_after(script2)

		
		#prettyHTML=soup.prettify()
		output = str(soup)
		
		output_path = outputdir + base
		file = open(output_path, "w")
		file.write(output)