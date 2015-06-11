# -*- coding: utf-8 -*-
from lxml import etree as ET
import StringIO
import os
import string
import sys
reload(sys)  
sys.setdefaultencoding('utf8')

inputdir = 'C:\\Users\\gw234478\\Documents\\UID\\findingaids'
outputdir = 'C:\\Users\\gw234478\\Documents\\UID\\output\\'

creator_list = 'C:\\Users\\gw234478\\Documents\\UID\\creator.xml'

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
		FA.set("id", coll_ID)
		FA.find('eadheader/eadid').text = coll_ID
		if FA.find('archdesc/did/unitid') is None:
			unitid_element = ET.Element('unitid')
			unitid_element.text = coll_ID
			if FA.find('archdesc/did/head') is None:
				FA.find('archdesc/did').insert(0, unitid_element)
			else:
				FA.find('archdesc/did').insert(1, unitid_element)
		else:
			FA.find('archdesc/did/unitid').text = coll_ID
		
		#copyright symbol fix
		pub_date = FA.find('eadheader/filedesc/publicationstmt/date')
		if pub_date is None:
			pass
		else:
			if "©2" in pub_date.text:
				pub_date.text = pub_date.text.replace("©2", "Copyright 2", 1)
			elif "©19" in pub_date.text:
				pub_date.text = pub_date.text.replace("©19", "Copyright 19", 1)
			elif " ©" in pub_date.text:
				pub_date.text = pub_date.text.replace(" ©", "Copyright", 1)
			elif "andcopy" in pub_date.text:
				pub_date.text = pub_date.text.replace("andcopy", "Copyright", 1)
			elif "and#169;" in pub_date.text:
				pub_date.text = pub_date.text.replace("and#169;", "Copyright", 1)
			else:
				pub_date.text = "Copyright" + pub_date.text
				
		#series-level id
		c1 = 0
		if FA.find('archdesc/dsc') is None:
			pass
		else:
			for cmpnt in FA.find('archdesc/dsc'):
				if cmpnt.tag == "c01":
					c1 = c1 + 1
					cmpnt.set('id', "nam_" + coll_ID + "-" + str(c1))
					if cmpnt.find('c02') is None:
						pass
					else:
						c2 = 0
						for cmpnt2 in cmpnt:
							if cmpnt2.tag == "c02":
								c2 = c2 + 1
								if cmpnt2.find('c03') is None:
									cmpnt2.set('id', "nam_" + coll_ID + "-" + str(c1) + "_" + str(c2))
								else:
									c3 = 0
									cmpnt2.set('id', "nam_" + coll_ID + "-" + str(c1) + "." + str(c2))
									for cmpnt3 in cmpnt2:
										if cmpnt3.tag == "c03":
											c3 = c3 + 1
											if cmpnt3.find('c04') is None:
												cmpnt3.set('id', "nam_" + coll_ID + "-" + str(c1) + "." + str(c2) + "_" + str(c3))
											else:
												c4 = 0
												cmpnt3.set('id', "nam_" + coll_ID + "-" + str(c1) + "." + str(c2) + "." + str(c3))
												for cmpnt4 in cmpnt3:
													if cmpnt4.tag == "c04":
														c4 = c4 + 1
														if cmpnt4.find('c05') is None:
															cmpnt4.set('id', "nam_" + coll_ID + "-" + str(c1) + "." + str(c2) + "." + str(c3) + "_" + str(c4))
														else:
															c5 = 0
															i = 0
															cmpnt4.set('id', "nam_" + coll_ID + "-" + str(c1) + "." + str(c2) + "." + str(c3) + "_" + str(c4))
															for cmpnt5 in cmpnt4:
																if cmpnt5.tag == "c05":
																	c5 = c5 + 15
																	i = i + 1
																	if cmpnt5.find('c06') is None:
																		cmpnt5.set('id', "nam_" + coll_ID + "-" + str(c1) + "." + str(c2) + "." + str(c3) + "_" + str(c4) + "." + str(c5))
																		container_element = ET.Element('container')
																		cmpnt5.find('did').insert(0, container_element)
																		container_element.set('type', 'item')
																		container_element.text = str(i)
																	else:
																		print coll_ID
												
		#restrictions fix
		for level in FA.iter():
			tag_test = str(level.tag)
			if tag_test.startswith("c0"):
				if level.find('accessrestrict') is None:
					pass
				else:
					level.find('accessrestrict').clear()
					p_element = ET.Element('p')
					level.find('accessrestrict').append(p_element)
					p_element.text = "Must consult archivist before viewing this material."
					for child in level.iterchildren():
						tag_test3 = str(child.tag)
						if tag_test3.startswith('c0'):
							if child.find('accessrestrict'):
								level.find('accessrestrict').clear()
								p_element = ET.Element('p')
								level.find('accessrestrict').append(p_element)
								p_element.text = "Must consult archivist before viewing this material."
							else:
								accessrestrict_element = ET.Element('accessrestrict')
								child.insert(1, accessrestrict_element)
								p_element = ET.Element('p')
								accessrestrict_element.append(p_element)
								p_element.text = "Must consult archivist before viewing this material."
								for subchild in child.iterchildren():
									tag_test2 = str(subchild.tag)
									if tag_test2.startswith('c0'):
										print "MORE!"
					if "RESTRICTED" in level.find('did/unittitle').text or "Restricted" in level.find('did/unittitle').text:
						pass
					else:
						level.find('did/unittitle').text = level.find('did/unittitle').text + " RESTRICTED"
		for unittitle in FA.iter():
			if unittitle.text:
				if "RESTRICTED" in unittitle.text:
					if unittitle.tag == "unittitle":
						unittitle.text = unittitle.text.replace("RESTRICTED", "[RESTRICTED]", 1)
						if unittitle.getparent().getparent().find('accessrestrict'):
							unittitle.getparent().getparent().find('accessrestrict/p').text = "Must consult archivist before viewing this material."
						else:
							accessrestrict_element = ET.Element('accessrestrict')
							unittitle.getparent().getparent().insert(1, accessrestrict_element)
							p_element = ET.Element('p')
							accessrestrict_element.append(p_element)
							p_element.text = "Must consult archivist before viewing this material."
					else:
						print coll_ID
						print unittitle.text
				elif "[Restricted]" in unittitle.text:
					if unittitle.tag == "unittitle":
						unittitle.text = unittitle.text.replace("[Restricted]", "[RESTRICTED]", 1)
						if unittitle.getparent().getparent().find('accessrestrict'):
							unittitle.getparent().getparent().find('accessrestrict/p').text = "Must consult archivist before viewing this material."
						else:
							accessrestrict_element = ET.Element('accessrestrict')
							unittitle.getparent().getparent().insert(1, accessrestrict_element)
							p_element = ET.Element('p')
							accessrestrict_element.append(p_element)
							p_element.text = "Must consult archivist before viewing this material."
					else:
						print coll_ID
						print unittitle.text
						
		#creator fix
		creator_input = ET.parse(creator_list, parser)
		creator = creator_input.getroot()
		if FA.find('archdesc/did/origination'):
			FA.find('archdesc/did/origination').clear()
			count_match = 0
			for ex in creator:
				if ex.find('id').text == coll_ID:
					count_match = count_match + 1
					new_element = ET.Element(ex.find('element').text)
					FA.find('archdesc/did/origination').append(new_element)
					new_element.text = ex.find('creator').text
					if ex.find('element').text == "corpname":
						marc = "610"
					elif ex.find('element').text == "persname":
						marc = "600"
					else:
						print "encoding analog error: " + coll_ID
					if marc is None:
						pass
					else:
						new_element.set('encodinganalog', marc)
					new_element.set('source', ex.find('source').text)
			if count_match != 1:
				print "did not find match: " + coll_ID + ", " + 
		else:
			origination_element = ET.Element('origination')
			FA.find('archdesc/did').insert(4, origination_element)
			count_match = 0
			for ex in creator:
				if ex.find('id').text == coll_ID:
					count_match = count_match + 1
					new_element = ET.Element(ex.find('element').text)
					origination_element.append(new_element)
					new_element.text = ex.find('creator').text
					if ex.find('element').text == "corpname":
						marc = "610"
					elif ex.find('element').text == "persname":
						marc = "600"
					else:
						print "encoding analog error: " + coll_ID
					if marc is None:
						pass
					else:
						new_element.set('encodinganalog', marc)
					new_element.set('source', ex.find('source').text)
			if count_match != 1:
				print "did not find match: " + coll_ID
			
			
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