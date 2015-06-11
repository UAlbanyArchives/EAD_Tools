# -*- coding: utf-8 -*-
from lxml import etree as ET
import StringIO
import os
import string
import sys
import os.path
import bagit
import shutil
reload(sys)  
sys.setdefaultencoding('utf8')

inputdir = 'C:\Users\gw234478\Documents\Student_Newspapers'
outputdir = 'C:\Users\gw234478\Documents\Student_Newspapers/'

filedir = "//romeo/wwwroot/asp_issues/"
movedir = "//romeo/wwwroot/university_archives/ua809/"

rep_ID = "nam_"

for input_file in os.listdir(inputdir):
	if input_file.endswith("studentnewspapers.xml"):
	
		input_xml = inputdir + "\\" + input_file
		parser = ET.XMLParser(remove_blank_text=True)
		FA_input = ET.parse(input_xml, parser)
		FA = FA_input.getroot()
		#pi = FA.getprevious()
		
		root = ET.Element('root')
		for year in FA.find('body'):
			if year.tag == "dl":
				series_in = year.find('dt/strong').text
				if " (" in series_in:
					series_num = series_in.rsplit(' (', 1)[0]
				else:
					series_num = series_in
					
				series_id = "nam_ua809-" + series_num
			
				c02_element = ET.Element('c02')
				c02_element.set('id', series_id)
				root.append(c02_element)
				did_element = ET.Element('did')
				c02_element.append(did_element)
				unittitle_element = ET.Element('unittitle')
				unittitle_element.text = series_num
				did_element.append(unittitle_element)
				unitdate_element = ET.Element('unitdate')
				unitdate_element.text = series_num
				unitdate_element.set('normal', series_num)
				did_element.append(unitdate_element)
				
				item_count = 0
				for item in year.find('ul'):
					item_count = item_count + 1
					text = item.find('a').text
					if ",N" in text:
						text = text.replace(",N", ", N")
					
					n = 2
					groups = item.find('a').text.split(' ')
					text = ' '.join(groups[:n]), ' '.join(groups[n:])
					date, title = text
					
					if ",N" in title:
						title = title.replace(",N", ", N")
						
					item_id = series_id + "_" + str(item_count)
					
					item_path = item.find('a').attrib['href']
					
					date_parts = date.strip().split(' ')
					month, day = date_parts
					if month.lower() == "january":
						norm_month = "1"
					elif month.lower() == "february":
						norm_month = "2"
					elif month.lower() == "march":
						norm_month = "3"
					elif month.lower() == "april":
						norm_month = "4"
					elif month.lower() == "may":
						norm_month = "5"
					elif month.lower() == "june":
						norm_month = "6"
					elif month.lower() == "july":
						norm_month = "7"
					elif month.lower() == "august":
						norm_month = "8"
					elif month.lower() == "september":
						norm_month = "9"
					elif month.lower() == "october":
						norm_month = "10"
					elif month.lower() == "november":
						norm_month = "11"
					elif month.lower() == "december":
						norm_month = "12"
					else:
						print "ERROR: " + item_id
					norm_date = series_num + "-" + norm_month + "-" + day
					
					link = item.find('a').attrib['href']
					new_link = 'http://library.albany.edu/speccoll/findaids/university_archives/ua809/' + item_id + '.pdf'
					
					c03_element = ET.Element('c03')
					c03_element.set('id', item_id)
					c02_element.append(c03_element)
					did_element2 = ET.Element('did')
					c03_element.append(did_element2)
					unittitle_element = ET.Element('unittitle')
					did_element2.append(unittitle_element)
					unittitle_element.text = title
					unitdate_element = ET.Element('unitdate')
					unitdate_element.text = series_num + " " + date
					unitdate_element.set('normal', norm_date)
					did_element2.append(unitdate_element)
					dao_element = ET.Element('dao')
					did_element2.append(dao_element)
					dao_element.set('actuate', 'onrequest')
					dao_element.set('href', new_link)
					dao_element.set('id', item_id)
					dao_element.set('linktype', 'simple')
					dao_element.set('show', 'new')
					
					#object_path = filedir + os.path.basename(link)
					#print os.path.basename(link) + " becoming " + item_id + ".pdf"
					#shutil.copy(object_path, movedir)
					#os.rename(movedir + os.path.basename(link), movedir + item_id + ".pdf")
						
					physdesc_element = ET.Element('physdesc')
					did_element2.append(physdesc_element)
					size = os.path.getsize(movedir + "data/" + item_id + ".pdf")/(1024*1024.0)
					round = ("%.2f" % size)
					physdesc_element.text = str(round) + " MB"
					
		
					
		output_string = ET.tostring(root, pretty_print=True, xml_declaration=True, encoding="utf-8")
			
		output_path = outputdir + 'news_inventory' + ".xml"
		file = open(output_path, "w")
		file.write(output_string)
#print "Bagging files..."
#bag = bagit.make_bag(movedir, {'Contact-Name': 'Gregory Wiedeman'})
#print "Complete!"