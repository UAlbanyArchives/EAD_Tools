from lxml import etree as ET
#import xml.etree.cElementTree as ET
#from func.prettyprint import prettyprint
#from xml.dom import minidom
import os

inputdir = 'C:\\Users\\gw234478\\Documents\\UID\\findingaids'
outputdir = 'C:\\Users\\gw234478\\Documents\\UID\\output\\'


rep_ID = "nam_"

for input_file in os.listdir(inputdir):
	if input_file.endswith(".xml"):
		input_xml = inputdir + "\\" + input_file
		FA_input = ET.parse(input_xml)
		FA = FA_input.getroot()
		
		for cmpnt in FA.find():
			if cmpnt.tag.startswith("c0"):
				print cmpnt.tag
		"""
		FA_output = ET.tostring(FA)
		output_path = outputdir + coll_ID + ".xml"
		file = open(output_path, "w")
		file.write(FA_output)
		"""