# -*- coding: utf-8 -*-
from lxml import etree as ET
import StringIO
import os
import string
import sys
reload(sys)  
sys.setdefaultencoding('utf8')

inputdir = 'C:\\Users\\gw234478\\Documents\\UID\\output'
outputdir = 'C:\\Users\\gw234478\\Documents\\UID\\output2\\'


rep_ID = "nam_"

for input_file in os.listdir(inputdir):
	if input_file.endswith(".xml"):
		input_xml = inputdir + "\\" + input_file
		parser = ET.XMLParser(remove_blank_text=True)
		FA_input = ET.parse(input_xml, parser)
		FA = FA_input.getroot()
		pi = FA.getprevious()

		
		#standardize collection id
		if "id" in FA.attrib:
			coll_ID = FA.attrib['id']
		else:
			coll_ID = FA.find('eadheader/eadid').text
		FA.set("id", "nam_" + coll_ID)
		FA.find('eadheader/eadid').text = "nam_" + coll_ID
		if FA.find('archdesc/did/unitid') is None:
			unitid_element = ET.Element('unitid')
			unitid_element.text = "nam_" + coll_ID
			if FA.find('archdesc/did/head') is None:
				FA.find('archdesc/did').insert(0, unitid_element)
			else:
				FA.find('archdesc/did').insert(1, unitid_element)
		else:
			FA.find('archdesc/did/unitid').text = "nam_" + coll_ID
		

			
			
		FA_string = ET.tostring(FA, pretty_print=True, xml_declaration=True, encoding="utf-8", doctype="<!DOCTYPE ead SYSTEM 'ead.dtd'>")
		
		#insert stylesheet processing instruction
		if isinstance(pi, ET._XSLTProcessingInstruction):
			if "no_series" in str(pi):
				FA_output = FA_string[:38] + "\n<?xml-stylesheet type='text/xsl' href='eadcbs6-su1_gw_no_series.xsl'?> " + FA_string[38:]
			else:
				FA_output = FA_string[:38] + "\n<?xml-stylesheet type='text/xsl' href='eadcbs6-su1_gw_4-30-15.xsl'?> " + FA_string[38:]
			
		
		output_path = outputdir + coll_ID + ".xml"
		file = open(output_path, "w")
		file.write(FA_output)