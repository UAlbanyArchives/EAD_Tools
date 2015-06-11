import lxml.etree as ET
import os
import subprocess

path = 'C:\Users\gw234478\Documents\Transform'
output_path = 'C:\Users\gw234478\Documents\Transform\\'
series = "eadcbs6-su1_gw_4-30-15.xsl"
noseries = "eadcbs6-su1_gw_no_series.xsl"
series_xsl = ET.parse(series)
noseries_xsl = ET.parse(noseries)



for filename in os.listdir(path):
	
	if not filename.endswith('.xml'): continue
	xml_filename = os.path.join(path, filename)
	xml_doc = ET.parse(xml_filename)
	xml_root = xml_doc.getroot()
	pi = xml_root.getprevious()
	
	base = os.path.basename(filename)
	a = "java"
	b = "-cp" 
	c = "c:\saxon\saxon9he.jar net.sf.saxon.Transform"
	d = "-t"
	e = "-s:" + xml_filename
	f = "-xsl:C:\Users\gw234478\Documents\Transform\\"
	g = "-o:"
    
	if isinstance(pi, ET._XSLTProcessingInstruction):
		if "no_series" in str(pi):
			#transform = ET.XSLT(noseries_xsl)
			#output = transform(xml_doc)
			#output_str = ET.tostring(output)
			html_filename = os.path.splitext(base)[0] + ".html"
			#file = open(html_filename, "w")
			#file.write(output_str)
			f = f + noseries
			g = g + output_path + html_filename
			cmd = a + " " + b + " " + c + " " + d + " " + e + " " + f + " " + g
			os.system(cmd)
		else:
			#transform = ET.XSLT(series_xsl)
			#output = transform(xml_doc)
			#output_str = ET.tostring(output)
			html_filename = os.path.splitext(base)[0] + ".html"
			#file = open(html_filename, "w")
			#file.write(output_str)
			f = f + series
			g = g + output_path + html_filename
			cmd = a + " " + b + " " + c + " " + d + " " + e + " " + f + " " + g
			os.system(cmd)