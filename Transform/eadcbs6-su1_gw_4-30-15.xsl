<!-- Based on EAD Cookbook Style 6   Version 0.9   19 January 2004 -->

<!--  This stylesheet generates a Table of Contents in an HTML table cell
along the left side of the screen. It is an update to eadcbs2.xsl designed
to work with EAD 2002.-->

<!--This stylesheet does not format the <dsc> portion of a finding aid.   Users
need to select another stylesheet for the dsc and reference that file
in the <xsl:include> statement that appears at the end of this file.-->


<!-- ******************************************************************** -->
<!-- ******                    CHANGE RECORD                      ******* -->
<!-- ******************************************************************** -->

<!-- MRC - 2/10/09
           Minor fix to glitch in chronlist (text longer than one line was not 
           wrappping) -->

<!-- MRC - 11/22/08
           Added deflist handling for abbreviation lists (for Laubach Literacy) -->

<!-- MRC - 7/7/08
           Added suppression of the subtitle "Subject" under controlaccess 
           when there are only local ones -->

<!-- MRC - 11/6/07
           Added suppression of subject elements with source=local in the HTML. 
           These are just ours, not LC; we put them in the XML so we can use 
           them for our subject clusters but they don't need to be visible to 
           the end user. -->

<!-- MRC - 10/25/07
           Added Reel as allowable 2d container (when was it removed??).  -->

<!-- MRC - 9/13/07
           Added comment in output giving version of style sheets used 
           to create it (uses last change dates in change records).  -->

<!-- MRC - 8/24/07
           Forced ID for other finding aid section to be "otherfindaid"
           so could easily/consistently link to it. -->

<!-- MRC - 7/18/07
           Added archref handling (for linking to related materials) -->

<!-- MRC - 7/5/07
           Added show=new attribute handling for extref to force 
           opening in a new window -->

<!-- MRC - 7/2/07
           Added alt attribute to img for SU logo to make it HTML 4.0
           compliant -->

<!-- MRC - 6/27/07
           Moved Related Finding Aids section to follow arrangement. -->

<!-- MRC - 8/24/06 - modified to handle ref elements in index, moved
           index location to end of finding aid rather than end of header
           info, for-each'ed to get all indexes to show up in TOC, 
           added checking for @id in indexes so we can link to them if
           we want to.

           Also added "Return to TOC" link to end of ALL finding aids -->

<!-- MRR - 5/31/06 - modified titleproper and subtitle handling so that
           the contents are actually processed, in order to retain any
           special markup such as italics, line breaks, etc.  Note that
           the capture of the title for the header of the HTML document
           does NOT retain special formatting, so need to include a space
           as well as a line break for it to come out correctly.    -->

<!-- MRR - 5/15/06 
         - added ability to do marked lists in arrangement and scopecontent
         - added handling of blockquote in separated mat and related mat  -->

<!-- MRR - 5/3/06
         - lists in archdesc/scopecontent were not indenting properly, fixed.  
         - in archdesc/arrangement/list/item, disabled the automatic
           conversion of list items to links.  It's kind of nice but prefer to 
           be able to control when and where links appear. If this ever gets
           changed back, be sure to check the George Aker papers with the 
           changes. -->

<!-- MRR - 4/12/06 - swapped output order of separated mat and related mat -->

<!-- MRR - 4/7/06 
	 - fixed note handling in archdesc items 
         - exempted revisiondesc from list handling 
         - added inventory creator, date and revision info to Admin Info -->

<!-- MRR - 1/4/06 
	 - added ID handling for list items (useful when finding aid
           includes selected index to correspondence) 
	 - fixed note handling in list items (only note text should be
           italicized, not entire item text) -->

<!-- MRR - 11/2/05 - added blockquote handling (for indented chunks) -->

<!-- MRR - 10/23/05 - changed marker for marked lists from asterisk to bullet (looks nicer) -->

<!-- MRR - 8/29/05 - Added minimal extptr processing.  If @SHOW is set to embed,
           it will create an IMG tag as output.
           If not, it will create a clickable link (A HREF="") as output -->

<!-- MRR - 8/10/05
         - Changed ABSTRACT to be on same line as title, with "-" separater (in su1.xsl)
         - reduced indentation of lists so nested ones look better -->

<!-- 8/3/05 - added handling for FUNCTION, FAMNAME, TITLE in controlled access headings -->

<!-- 8/1/05 - added processing for notes in tables -->

<!-- 7/25/05 - changed caption for <corpname> from Business to Corporate Bodies -->

<!-- 7/20/05 - fixed location for INCLUDE statement and for sulogo graphic -->


<!-- ******************************************************************** -->
<!-- *******                 END OF CHANGE RECORD                 ******* -->
<!-- ******************************************************************** -->




	<!-- ****************************************************************** -->
	<!-- Outputs header information for the HTML document 			-->
	<!-- ****************************************************************** -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:ns2="http://www.w3.org/1999/xlink">
	<xsl:strip-space elements="*"/>
	<xsl:output method="html" encoding="ISO-8859-1" doctype-public="-//W3C//DTD HTML 4.0 Transitional//EN"/>
	<!-- Creates the body of the finding aid.-->
	<xsl:template match="/ead">
		<html>

			<head>
				<style type="text/css">
				h1, h2, h3, h4 {font-family: times new roman}
				td {vertical-align: top}
				</style>
		
				<title>
					<xsl:value-of select="eadheader/filedesc/titlestmt/titleproper"/>
					<xsl:text>  </xsl:text>
					<xsl:value-of select="eadheader/filedesc/titlestmt/subtitle"/>
				</title>

				<!-- *********************************** -->
				<!-- scripts for visit, question forms   -->
				<!-- *********************************** -->

				 <!--<xsl:comment>#INCLUDE VIRTUAL="/digital/guides/ead/scripts.htm"</xsl:comment>-->
		
				<xsl:call-template name="metadata"/>
				<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.8/jquery.min.js"></script>
				<script type="text/javascript">
				$(document).ready(function(){
					$(".toggle").toggle(
						function(){$(this).children("span").css({"display": "inline"});},
						function(){$(this).children("span").css({"display": "none"});
					});
				});
				</script>
				
				  <!-- ANGELFISH METRICS -->
				  <script type="text/javascript" src="http://library.albany.edu/angelfish.js"></script>
				  <script type="text/javascript">
					  agf.pageview();
				  </script>
				
			</head>


	<!-- ****************************************************************** -->
	<!-- Sets up two-column format.  Table of contents goes in the left	-->
	<!-- column, content data goes in the right				-->
	<!-- ****************************************************************** -->

			<body>
				<table>
					<tr>
						<!-- Calls toc template to generate TOC  -->
			
						<td valign="top" bgcolor="#D9C880" width="20%">
							<xsl:call-template name="toc"/>

							<!-- *********************************** -->
							<!-- links for visit, question forms     -->
							<!-- *********************************** -->

							<!--<xsl:comment>#INCLUDE VIRTUAL="/digital/guides/ead/scriptcall.htm"</xsl:comment>-->

						</td>
				
						<!--The body of the finding aid is in the right column.  -->	
						<td valign="top" bgcolor="#FFFCE4" width="80%">
							
							<!--Marks test area for links at top-->
							
								
							
						
								
							
	
				<!-- Inserts logo and title at the top of the display. -->

                               <center>
			       <img alt="Grenander banner" src="newheader.jpg"/>
			       </center>				


                                <xsl:apply-templates select="eadheader"/>
				
				
														
				<hr></hr>
				
				<!--To change the order of display, adjust the sequence of
				the following apply-template statements which invoke the various
				templates that populate the finding aid.  Multiple statements
				are included to handle the possibility that descgrp has been used
				as a wrapper to replace add and admininfo.  In several cases where
				multiple elements are displayed together in the output, a call-template
				statement is used-->	
					
							<xsl:apply-templates select="archdesc/did"/>
							<xsl:apply-templates select="archdesc/bioghist"/>
							<xsl:apply-templates select="archdesc/scopecontent"/>
							<xsl:apply-templates select="archdesc/arrangement"/>
							<xsl:apply-templates select="archdesc/otherfindaid | archdesc/*/otherfindaid"/>
							<xsl:call-template name="archdesc-restrict"/>
							<xsl:call-template name="archdesc-relatedmaterial"/>
							<xsl:apply-templates select="archdesc/controlaccess"/>
							<xsl:apply-templates select="archdesc/odd"/>
							<xsl:apply-templates select="archdesc/originalsloc"/>
							<xsl:apply-templates select="archdesc/phystech"/>
							<xsl:call-template name="archdesc-admininfo"/>
							<xsl:apply-templates select="archdesc/fileplan | archdesc/*/fileplan"/>
							<xsl:apply-templates select="archdesc/bibliography | archdesc/*/bibliography"/>
							<xsl:apply-templates select="archdesc/dsc"/>
							<p>
							   <a href="#">Return to the Table of Contents</a>
							</p>
							<hr/>				
							<xsl:apply-templates select="archdesc/index | archdesc/*/index"/>
						</td>
					</tr>
				</table>
			</body>
		</html>
	</xsl:template>



	<!-- ****************************************************************** -->
	<!-- Generates HTML meta tags that are inserted into the HTML ouput	-->
	<!-- for use by web search engines indexing this file.   The content 	-->
	<!-- of each META tag uses Dublin Core semantics and is drawn from	-->
	<!-- the controlaccess subelements (genreform, subject, etc.)		-->
	<!-- ****************************************************************** -->

	<xsl:template name="metadata">
		<meta http-equiv="Content-Type" name="dc.title"
		content="{eadheader/filedesc/titlestmt/titleproper&#x20; } {eadheader/filedesc/titlestmt/subtitle}"/>
		<meta http-equiv="Content-Type" name="dc.author" content="{archdesc/did/origination}"/>
		
		<xsl:for-each select="//controlaccess/persname | //controlaccess/corpname">
			<xsl:choose>
				<xsl:when test="@encodinganalog='600'">
				<meta http-equiv="Content-Type" name="dc.subject" content="{.}"/>
				</xsl:when>

				<xsl:when test="//@encodinganalog='610'">
					<meta http-equiv="Content-Type" name="dc.subject" content="{.}"/>
				</xsl:when>

				<xsl:when test="//@encodinganalog='611'">
					<meta http-equiv="Content-Type" name="dc.subject" content="{.}"/>
				</xsl:when>

				<xsl:when test="//@encodinganalog='700'">
					<meta http-equiv="Content-Type" name="dc.contributor" content="{.}"/>
				</xsl:when>

				<xsl:when test="//@encodinganalog='710'">
					<meta http-equiv="Content-Type" name="dc.contributor" content="{.}"/>
				</xsl:when>

				<xsl:otherwise>
					<meta http-equiv="Content-Type" name="dc.contributor" content="{.}"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
		<xsl:for-each select="//controlaccess/subject">
			<meta http-equiv="Content-Type" name="dc.subject" content="{.}"/>
		</xsl:for-each>
		<xsl:for-each select="//controlaccess/geogname">
			<meta http-equiv="Content-Type" name="dc.subject" content="{.}"/>
		</xsl:for-each>
		
		<meta http-equiv="Content-Type" name="dc.title" content="{archdesc/did/unittitle}"/>
		<meta http-equiv="Content-Type" name="dc.type" content="text"/>
		<meta http-equiv="Content-Type" name="dc.format" content="manuscripts"/>
		<meta http-equiv="Content-Type" name="dc.format" content="finding aids"/>
		
	</xsl:template>


	<!-- ****************************************************************** -->
	<!-- TABLE OF CONTENTS TEMPLATE						-->
	<!-- Performs a series of tests to determine which elements will be 	-->
	<!-- included in the table of contents.  Each if statement tests for	-->
	<!-- a matching element with content in the finding aid.  If the 	-->
	<!-- element exists, it's added to the TOC and an ID is generated for	-->
	<!-- so it can be linked to. ID attribute in XML is ignored.		-->
	<!-- ****************************************************************** -->

	<xsl:template name="toc">

                <br />
				<!--Link Image below for Table of Contents-->
                <!--<img align="center" alt="" src=""/>-->
                <h3 align="center">Table Of Contents</h3>
                <h3 align="center"></h3>
		
		<xsl:if test="string(archdesc/did/head)">
			<p>
				<b>
					<a href="#{generate-id(archdesc/did/head)}">
						<xsl:value-of select="archdesc/did/head"/>
					</a>
				</b>
			</p>
		</xsl:if>
		<xsl:if test="string(archdesc/bioghist/head)">
			<p style="margin-top:-5pt">
				<b>
					<a href="#{generate-id(archdesc/bioghist/head)}">
						<xsl:value-of select="archdesc/bioghist/head"/>
					</a>
				</b>
			</p>
		</xsl:if>
		<xsl:if test="string(archdesc/scopecontent/head)">
			<p style="margin-top:-5pt">
				<b>
					<a href="#{generate-id(archdesc/scopecontent/head)}">
						<xsl:value-of select="archdesc/scopecontent/head"/>
					</a>
				</b>
			</p>
		</xsl:if>
		<xsl:if test="string(archdesc/arrangement/head)">
			<p style="margin-top:-5pt">
				<b>
					<a href="#{generate-id(archdesc/arrangement/head)}">
						<xsl:value-of select="archdesc/arrangement/head"/>
					</a>
				</b>
			</p>
		</xsl:if>

		<xsl:if test="string(archdesc/otherfindaid/head)
			or string(archdesc/*/otherfindaid/head)">
			<p style="margin-top:-5pt">
				<b>
					<xsl:choose>
						<xsl:when test="archdesc/otherfindaid/head">
							<a href="#otherfindaid">
								<xsl:value-of select="archdesc/otherfindaid/head"/>
							</a>
						</xsl:when>
						<xsl:when test="archdesc/*/otherfindaid/head">
							<a href="#otherfindaid">
								<xsl:value-of select="archdesc/*/otherfindaid/head"/>
							</a>
						</xsl:when>
					</xsl:choose>
				</b>
			</p>
		</xsl:if>
		
		<xsl:if test="string(archdesc/userestrict/head)
		or string(archdesc/accessrestrict/head)
		or string(archdesc/*/userestrict/head)
		or string(archdesc/*/accessrestrict/head)">
			<p style="margin-top:-5pt">
				<b>
					<a href="#restrictlink">
						<xsl:text>Restrictions</xsl:text>
					</a>
				</b>
			</p>
		</xsl:if>
		<xsl:if test="string(archdesc/controlaccess/head)">
			<p style="margin-top:-5pt">
				<b>
					<a href="#{generate-id(archdesc/controlaccess/head)}">
						<xsl:value-of select="archdesc/controlaccess/head"/>
					</a>
				</b>
			</p>
		</xsl:if>
		<xsl:if test="string(archdesc/relatedmaterial)
		or string(archdesc/separatedmaterial)
		or string(archdesc/*/relatedmaterial)
		or string(archdesc/*/separatedmaterial)">
			<p style="margin-top:-5pt">
				<b>
					<a href="#relatedmatlink">
						<xsl:text>Related Material</xsl:text>
					</a>
				</b>
			</p>
		</xsl:if>
		<xsl:if test="string(archdesc/acqinfo/*)
		or string(archdesc/processinfo/*)
		or string(archdesc/prefercite/*)
		or string(archdesc/custodialhist/*)
		or string(archdesc/processinfo/*)
		or string(archdesc/appraisal/*)
		or string(archdesc/accruals/*)
		or string(archdesc/*/acqinfo/*)
		or string(archdesc/*/processinfo/*)
		or string(archdesc/*/prefercite/*)
		or string(archdesc/*/custodialhist/*)
		or string(archdesc/*/processinfo/*)
		or string(archdesc/*/appraisal/*)
		or string(archdesc/*/accruals/*)">
			<p style="margin-top:-5pt">
				<b>
					<a href="#adminlink">
					<xsl:text>Administrative Information</xsl:text>
					</a>
				</b>
			</p>
		</xsl:if>
		
		
		<!--The next test covers the situation where there is more than one odd element
			in the document.-->
		<xsl:if test="string(archdesc/odd/head)">
			<xsl:for-each select="archdesc/odd">
				<p style="margin-top:-5pt">
					<b>
						<a href="#{generate-id(head)}">
							<xsl:value-of select="head"/>
						</a>
					</b>
				</p>
			</xsl:for-each>
		</xsl:if>
		
		<xsl:if test="string(archdesc/bibliography/head)
			or string(archdesc/*/bibliography/head)">
			<p style="margin-top:-5pt">
				<b>
					<xsl:choose>
						<xsl:when test="archdesc/bibliography/head">
							<a href="#{generate-id(archdesc/bibliography/head)}">
								<xsl:value-of select="archdesc/bibliography/head"/>
							</a>
						</xsl:when>
						<xsl:when test="archdesc/*/bibliography/head">
							<a href="#{generate-id(archdesc/*/bibliography/head)}">
								<xsl:value-of select="archdesc/*/bibliography/head"/>
							</a>
						</xsl:when>
					</xsl:choose>
				</b>
			</p>
		</xsl:if>
		
		<xsl:if test="string(archdesc/index/head)
			or string(archdesc/*/index/head)">
			<xsl:for-each select="archdesc/index/head | archdesc/*/index/head">
			    <p style="margin-top:-5pt">
				<b>
					<xsl:choose>
                                                <xsl:when test="../@id">
							<a href="#{../@id}">
								<xsl:value-of select="."/>
							</a>
                                                </xsl:when>
                                                <xsl:otherwise>
						    <xsl:choose>
							<xsl:when test="name(../..)='archdesc'">
								<a href="#{generate-id(.)}">
									<xsl:value-of select="."/>
								</a>
							</xsl:when>
							<xsl:when test="not[name(../..)='archdesc']">
								<a href="#{generate-id(.)}">
									<xsl:value-of select="."/>
								</a>
							</xsl:when>
						    </xsl:choose>
                                                </xsl:otherwise>
					</xsl:choose>
				</b>
			    </p>
                        </xsl:for-each>
		</xsl:if>
		
		<xsl:if test="string(archdesc/dsc/head)">
			<p style="margin-top:-5pt">
				<b>
					<a href="#{generate-id(archdesc/dsc/head)}">
						<xsl:value-of select="archdesc/dsc/head"/>
					</a>
				</b>
			</p>

			<!-- *************************************************	-->
			<!-- Captures unittitle and unitdates for c01's whose	-->
			<!-- @level is subgrp, subcollection,series or 		-->
			<!-- subseries, and generates ID so can link to.	-->
			<!-- *************************************************	-->

			<xsl:for-each select="archdesc/dsc/c01[@level='series' or @level='subseries'
			or @level='subgrp' or @level='subcollection']">
				<p style="margin-top:-5pt; margin-left:15pt; font-size:10pt">
					<b>
						<a>
							<xsl:attribute name="href">
								<xsl:text>#series</xsl:text>
								<xsl:number count="c01" from="dsc"/>
							</xsl:attribute>
		
							<xsl:choose>
								<xsl:when test="did/unittitle/unitdate">
									<xsl:for-each select="did/unittitle">
										<xsl:value-of select="text()"/>
										<xsl:text> </xsl:text>
										<xsl:apply-templates select="./unitdate"/>
									</xsl:for-each>
								</xsl:when>
								
								<xsl:otherwise>
									<xsl:apply-templates select="did/unittitle"/>
									<xsl:text> </xsl:text>
									<xsl:apply-templates select="did/unitdate"/>
								</xsl:otherwise>
								</xsl:choose>
						</a>
					</b>
				</p>
			</xsl:for-each>
			<!--This ends the section that causes the c01 titles to appear in the table of contents.-->
		</xsl:if>
		<!--End of the table of contents. -->
	</xsl:template>


	<!-- ******************************************************************	-->
	<!-- Formats variety of text properties (bold, italic) from @RENDER     -->
	<!-- Also BLOCKQUOTE handling                                           -->
	<!-- ****************************************************************** -->

	<xsl:template match="blockquote">
		<blockquote>
			<xsl:apply-templates/>
		</blockquote>
	</xsl:template>


	<xsl:template match="blockquote/p">
		<blockquote>
			<xsl:apply-templates/>
		</blockquote>
	</xsl:template>


	<xsl:template match="emph[@render='bold']">
		<b>
			<xsl:apply-templates/>
		</b>
	</xsl:template>

	<xsl:template match="emph[@render='italic']">
		<i>
			<xsl:apply-templates/>
		</i>
	</xsl:template>

	<xsl:template match="emph[@render='underline']">
		<u>
			<xsl:apply-templates/>
		</u>
	</xsl:template>

	<xsl:template match="emph[@render='sub']">
		<sub>
			<xsl:apply-templates/>
		</sub>
	</xsl:template>

	<xsl:template match="emph[@render='super']">
		<super>
			<xsl:apply-templates/>
		</super>
	</xsl:template>
	
	<xsl:template match="emph[@render='quoted']">
		<xsl:text>"</xsl:text>
		<xsl:apply-templates/>
		<xsl:text>"</xsl:text>
	</xsl:template>
	
	<xsl:template match="emph[@render='doublequote']">
		<xsl:text>"</xsl:text>
		<xsl:apply-templates/>
		<xsl:text>"</xsl:text>
	</xsl:template>

	<xsl:template match="emph[@render='singlequote']">
		<xsl:text>'</xsl:text>
		<xsl:apply-templates/>
		<xsl:text>'</xsl:text>
	</xsl:template>

	<xsl:template match="emph[@render='bolddoublequote']">
		<b>
			<xsl:text>"</xsl:text>
			<xsl:apply-templates/>
			<xsl:text>"</xsl:text>
		</b>
	</xsl:template>

	<xsl:template match="emph[@render='boldsinglequote']">
		<b>
			<xsl:text>'</xsl:text>
			<xsl:apply-templates/>
			<xsl:text>'</xsl:text>
		</b>
	</xsl:template>

	<xsl:template match="emph[@render='boldunderline']">
		<b>
			<u>
				<xsl:apply-templates/>
			</u>
		</b>
	</xsl:template>

	<xsl:template match="emph[@render='bolditalic']">
		<b>
			<i>
				<xsl:apply-templates/>
			</i>
		</b>
	</xsl:template>

	<xsl:template match="emph[@render='boldsmcaps']">
		<font style="font-variant: small-caps">
			<b>
				<xsl:apply-templates/>
			</b>
		</font>
	</xsl:template>

	<xsl:template match="emph[@render='smcaps']">
		<font style="font-variant: small-caps">
			<xsl:apply-templates/>
		</font>
	</xsl:template>

	<xsl:template match="title[@render='bold']">
		<b>
			<xsl:apply-templates/>
		</b>
	</xsl:template>

	<xsl:template match="title[@render='italic']">
		<i>
			<xsl:apply-templates/>
		</i>
	</xsl:template>

	<xsl:template match="title[@render='underline']">
		<u>
			<xsl:apply-templates/>
		</u>
	</xsl:template>

	<xsl:template match="title[@render='sub']">
		<sub>
			<xsl:apply-templates/>
		</sub>
	</xsl:template>

	<xsl:template match="title[@render='super']">
		<super>
			<xsl:apply-templates/>
		</super>
	</xsl:template>

	<xsl:template match="title[@render='quoted']">
		<xsl:text>"</xsl:text>
		<xsl:apply-templates/>
		<xsl:text>"</xsl:text>
	</xsl:template>

	<xsl:template match="title[@render='doublequote']">
		<xsl:text>"</xsl:text>
		<xsl:apply-templates/>
		<xsl:text>"</xsl:text>
	</xsl:template>
	
	<xsl:template match="title[@render='singlequote']">
		<xsl:text>'</xsl:text>
		<xsl:apply-templates/>
		<xsl:text>'</xsl:text>
	</xsl:template>

	<xsl:template match="title[@render='bolddoublequote']">
		<b>
			<xsl:text>"</xsl:text>
			<xsl:apply-templates/>
			<xsl:text>"</xsl:text>
		</b>
	</xsl:template>

	<xsl:template match="title[@render='boldsinglequote']">
		<b>
			<xsl:text>'</xsl:text>
			<xsl:apply-templates/>
			<xsl:text>'</xsl:text>
		</b>
	</xsl:template>

	<xsl:template match="title[@render='boldunderline']">
		<b>
			<u>
				<xsl:apply-templates/>
			</u>
		</b>
	</xsl:template>

	<xsl:template match="title[@render='bolditalic']">
		<b>
			<i>
				<xsl:apply-templates/>
			</i>
		</b>
	</xsl:template>

	<xsl:template match="title[@render='boldsmcaps']">
		<font style="font-variant: small-caps">
			<b>
				<xsl:apply-templates/>
			</b>
		</font>
	</xsl:template>

	<xsl:template match="title[@render='smcaps']">
		<font style="font-variant: small-caps">
			<xsl:apply-templates/>
		</font>
	</xsl:template>

	<!-- ****************************************************************** -->
	<!-- LINKS								-->
	<!-- Converts REF, EXTREF and PTR elements into HTML links as needed 	-->
	<!-- ****************************************************************** -->

	<xsl:template match="ref">
		<a href="#{@target}">
			<xsl:apply-templates/>
		</a>
	</xsl:template>

	<xsl:template match="extref | archref">
		<xsl:choose>
			<xsl:when test="self::extref[@show='new']">
                              <a href="{@href}" target="_blank"><xsl:apply-templates/></a>
			</xsl:when>
			<xsl:otherwise>
                              <a href="{@href}"><xsl:apply-templates/></a>
			</xsl:otherwise>
                </xsl:choose>
	</xsl:template>

	<xsl:template match="ptr">
		<a href="{@href}">
			<xsl:value-of select="@href"/><xsl:apply-templates/>
		</a>
	</xsl:template>

	<xsl:template match="extptr">

		<xsl:choose>
			<xsl:when test="self::extptr[@show='embed']">
                              <img src="{@xpointer}" alt="{@title}" align="{@altrender}"/>
			</xsl:when>

			<xsl:otherwise>
                              <a href="{@xpointer}">"{@title}"</a>
			</xsl:otherwise>
                </xsl:choose>

	</xsl:template>


   <xsl:template match="dao">
      <xsl:if test="preceding-sibling::dao">
          <br/>
	  </xsl:if>
      <xsl:choose>
         <xsl:when test="self::dao[@show='new']">
            <a href="{@href}" target="_blank"><xsl:value-of select="preceding-sibling::unittitle"/></a>
         </xsl:when>
         <xsl:otherwise>
            <a href="{@href}"></a>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   

	
	<!-- ****************************************************************** -->
	<!-- LIST								-->
	<!-- Formats a list anywhere except in ARRANGEMENT or REVISIONDESC.   	-->
	<!-- Three values for attribute TYPE are implemented: "simple" gives   	-->
	<!-- an indented list with no marker, "marked" gives an indented list  	-->
	<!-- with each item bulleted, "deflist" used with appropriate child     -->
        <!-- elements gives a table with "Abbreviation" and "Definition"        -->
	<!-- columns.                                                           -->
        <!--     (why are revisiondesc and arrangement treated separately???    -->
	<!-- ****************************************************************** -->

        
	<xsl:template match="archdesc/scopecontent/list[not(@type='deflist')]">
		<div style="margin-left: 25pt">
			<xsl:apply-templates/>
		</div>
	</xsl:template>


	<xsl:template match="list[parent::*[not(self::arrangement)]]/head">
		<div style="margin-left: 25pt">
			<b>
				<xsl:apply-templates/>
			</b>
		</div>
	</xsl:template>


	<xsl:template match="list[parent::*[not((self::arrangement)|(self::revisiondesc))]]/item">
		<xsl:if test="@id">
			<a id="{@id}"></a>
		</xsl:if>
		<xsl:choose>
			<xsl:when test="parent::list[@type='marked']">
				<div style="margin-left: 25pt">
					&#x2022; <xsl:apply-templates/>
				</div>
			</xsl:when>
			<xsl:otherwise>
		             <div style="margin-left: 25pt"><xsl:apply-templates/></div>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


	<xsl:template match="list[parent::*[not(self::arrangement)]]/item/note">
		<i><xsl:apply-templates/></i>
	</xsl:template>


        <!-- DEFLIST handling -->

	<xsl:template match="list[@type='deflist']">
           <table width="100%">
              <tr>
                 <td width="5%"> </td>
                 <td width="30%"> </td>
                 <td width="65%"> </td>
              </tr>
              <xsl:apply-templates/>
           </table>
	</xsl:template>


	<xsl:template match="list[@type='deflist']/listhead">
           <tr>
              <td> </td>
              <td>
                 <b>
                    <xsl:apply-templates select="head01"/>
                 </b>
              </td>
              <td>
                 <b>
                    <xsl:apply-templates select="head02"/>
                 </b>
              </td>
          </tr>
	</xsl:template>

	<xsl:template match="defitem">
           <tr>
              <td> </td>
              <td valign="top">
                 <xsl:apply-templates select="label"/>
              </td>
              <td valign="top">
                 <xsl:apply-templates select="item"/>
              </td>
            </tr>
	</xsl:template>

        <!-- end DEFLIST handling -->


	<!-- ****************************************************************** -->
	<!-- TABLE								-->
	<!-- Formats a simple table. The width of each column is defined 	-->
	<!-- by the colwidth attribute in a colspec element. The template	-->
	<!-- is named so it can be called from inside c0# elements.  ID  	-->
	<!-- attribute is implemented for ROW but not ENTRY 			-->
	<!-- ****************************************************************** -->
	
	<xsl:template match="table">
		<xsl:call-template name="table"/>
	</xsl:template>


	<xsl:template name="table">
		<table width="75%" style="margin-left: 25pt">
			<tr>
				<td colspan="3">
					<h4>
						<xsl:apply-templates select="head"/>
					</h4>
				</td>
			</tr>
			<xsl:for-each select="tgroup">
				<tr>
					<xsl:for-each select="colspec">
						<td width="{@colwidth}"></td>
					</xsl:for-each>
				</tr>
				<xsl:for-each select="thead">
					<xsl:for-each select="row">
						<tr>
							<xsl:for-each select="entry">
								<td valign="top">
									<b>
										<xsl:apply-templates/>
									</b>
								</td>
							</xsl:for-each>
						</tr>
					</xsl:for-each>
				</xsl:for-each>

				<xsl:for-each select="tbody">
					<xsl:for-each select="row">
						<xsl:if test="@id">
							<a id="{@id}"></a>
						</xsl:if>
						<tr>
							<xsl:for-each select="entry">
								<td valign="top">
									<xsl:apply-templates/>
								</td>
							</xsl:for-each>
						</tr>
					</xsl:for-each>
				</xsl:for-each>
			</xsl:for-each>
		</table>
	</xsl:template>

	<xsl:template match="entry/note">
		<br/><i><xsl:apply-templates/></i>
	</xsl:template>


	<!-- ****************************************************************** -->
	<!-- CHRONLIST								-->
	<!-- Formats a chronology list with items			 	-->
	<!-- ****************************************************************** -->

	<xsl:template match="chronlist">
		<table width="90%" style="margin-left:25pt">
			<tr>
				<td width="5%"> </td>
				<td width="15%"> </td>
				<td width="80%"> </td>
			</tr>
			<xsl:apply-templates/>
		</table>
	</xsl:template>
	
	<xsl:template match="chronlist/head">
		<tr>
			<td colspan="3">
				<h4>
					<xsl:apply-templates/>			
				</h4>
			</td>
		</tr>
	</xsl:template>
	
	<xsl:template match="chronlist/listhead">
		<tr>
			<td> </td>
			<td>
				<b>
					<xsl:apply-templates select="head01"/>
				</b>
			</td>
			<td>
				<b>
					<xsl:apply-templates select="head02"/>
				</b>
			</td>
		</tr>
	</xsl:template>

	<xsl:template match="chronitem">
		<!--Determine if there are event groups.-->
		<xsl:choose>
			<xsl:when test="eventgrp">
				<!--Put the date and first event on the first line.-->
				<tr>
					<td> </td>
					<td valign="top">
						<xsl:apply-templates select="date"/>
					</td>
					<td valign="top">
						<xsl:apply-templates select="eventgrp/event[position()=1]"/>
					</td>
				</tr>
				<!--Put each successive event on another line.-->
				<xsl:for-each select="eventgrp/event[not(position()=1)]">
					<tr>
						<td> </td>
						<td> </td>
						<td valign="top">
							<xsl:apply-templates select="."/>
						</td>
					</tr>
				</xsl:for-each>
			</xsl:when>
			<!--Put the date and event on a single line.-->
			<xsl:otherwise>
				<tr>
					<td> </td>
					<td valign="top">
						<xsl:apply-templates select="date"/>
					</td>
					<td valign="top">
						<xsl:apply-templates select="event"/>
					</td>
				</tr>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


	<!-- ****************************************************************** -->
	<!-- TITLEPROPER and SUBTITLE are output	 			-->
	<!-- ****************************************************************** -->

	<xsl:template match="eadheader">
	<h2 style="text-align:center">
		<a name="{generate-id(titlestmt/titleproper)}">
		<!--	<xsl:value-of select="filedesc/titlestmt/titleproper"/> -->
			<xsl:apply-templates select="filedesc/titlestmt/titleproper"/>
		</a>
	</h2>
	<h5 style="text-align:center">For reference queries contact the <a href="http://library.albany.edu/archive/reference">Grenander Department Reference staff</a> or call (518)-437-3935.</h5>
	<h3 style="text-align:center"><i>
		<!--	<xsl:value-of select="filedesc/titlestmt/subtitle"/> -->
			<xsl:apply-templates select="filedesc/titlestmt/subtitle"/>
<br/><xsl:apply-templates select="filedesc/titlestmt/sponsor"/></i> 
	</h3>
		

	<br></br>
	</xsl:template>


	<!-- ****************************************************************** -->
	<!-- DID processing: 							-->
	<!-- This template creates a table for the did, inserts the head and  	-->
	<!-- then each of the other did elements.  To change the order of 	-->
	<!-- appearance of these elements, change the sequence here.		-->
	<!-- UNITID is suppressed as not being useful to researchers; to show	-->
	<!-- it, uncomment the unitid line below.				-->
	<!-- ****************************************************************** -->

	<xsl:template match="archdesc/did">
		<table width="100%">
			<tr>
				<td width="25%"> </td>
				<td width="75%"> </td>
			</tr>
			<tr>
				<td colspan="2">
					<h3>
						<a name="{generate-id(head)}">
							<xsl:apply-templates select="head"/>
						</a>
					</h3>
				</td>
			</tr>	

			<xsl:apply-templates select="origination"/>	
			<xsl:apply-templates select="unittitle"/>	
			<xsl:apply-templates select="unitdate"/>		
			<xsl:apply-templates select="physdesc"/>	
			<xsl:apply-templates select="abstract"/>	
			<!-- <xsl:apply-templates select="unitid"/>  -->
			<xsl:apply-templates select="physloc"/>
			<xsl:apply-templates select="langmaterial"/>
			<xsl:apply-templates select="repository"/>
			<xsl:apply-templates select="materialspec"/>
			<xsl:apply-templates select="note"/>
		</table>
		<hr></hr>
	</xsl:template>



	<!-- ****************************************************************** -->
	<!-- COLLECTION INFO: 							-->
	<!-- This handles repository, origination, physdesc, abstract,unitid, 	-->
	<!-- physloc and materialspec elements of archdesc/did which share a 	-->
	<!-- common appearance.  Labels are also generated; to change the label	-->
	<!-- generated for these sections, modify the text below.		-->
	<!-- ****************************************************************** -->

	<xsl:template match="archdesc/did/repository
	| archdesc/did/origination
	| archdesc/did/physdesc
	| archdesc/did/unitid
	| archdesc/did/physloc
	| archdesc/did/abstract
	| archdesc/did/langmaterial
	| archdesc/did/materialspec">

	<!-- ****************************************************************** -->
	<!-- Tests for @LABEL.  If @LABEL is present it is used, otherwise 	-->
	<!-- a label is supplied (to alter supplied text, make change below).	-->
	<!-- ****************************************************************** -->

		<xsl:choose>
			<xsl:when test="@label">
				<tr>
				
					<td valign="top">
						<b>
							<xsl:value-of select="@label"/>
						</b>
					</td>
					<td>
						<xsl:apply-templates/>
					</td>
				</tr>
			</xsl:when>
			<xsl:otherwise>
				<tr>
					<td valign="top">
						<b>
							<xsl:choose>
								<xsl:when test="self::repository">
									<xsl:text>Repository: </xsl:text>
								</xsl:when>
								<xsl:when test="self::origination">
									<xsl:text>Creator: </xsl:text>
								</xsl:when>
								<xsl:when test="self::physdesc">
									<xsl:text>Quantity: </xsl:text>
								</xsl:when>
								<xsl:when test="self::physloc">
									<xsl:text>Location: </xsl:text>
								</xsl:when>
								<xsl:when test="self::unitid">
									<xsl:text>Identification: </xsl:text>
								</xsl:when>
								<xsl:when test="self::abstract">
									<xsl:text>Abstract:</xsl:text>
								</xsl:when>
								<xsl:when test="self::langmaterial">
									<xsl:text>Language: </xsl:text>
								</xsl:when>
								<xsl:when test="self::materialspec">
									<xsl:text>Technical: </xsl:text>
								</xsl:when>
							</xsl:choose>
						</b>
					</td>
					<td>
						<xsl:apply-templates/>
					</td>
				</tr>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- ****************************************************************** -->
	<!-- UNITTITLE, UNITDATE						-->
	<!-- If @LABEL is present it is used, otherwise a label is generated.	-->
	<!-- ****************************************************************** -->

	<xsl:template match="archdesc/did/unittitle">

		<xsl:choose>

			<xsl:when test="@label">
				<tr>
					
					<td valign="top">
						<b>
							<xsl:value-of select="@label"/>
						</b>
					</td>
					<td>
						<xsl:apply-templates select="text() |* [not(self::unitdate)]"/>
					</td>
				</tr>
			</xsl:when>
		
			<xsl:otherwise>
				<tr>
					
					<td valign="top">
						<b>
							<xsl:text>Title: </xsl:text>
						</b>
					</td>
					<td>
						<xsl:apply-templates select="text() |* [not(self::unitdate)]"/>
					</td>
				</tr>

			</xsl:otherwise>

		</xsl:choose>


		<xsl:if test="child::unitdate[@type='inclusive']">

			<xsl:choose>
				<xsl:when test="unitdate[@type='inclusive']/@label">
					<tr>
						
						<td valign="top">
							<b>
								<xsl:value-of select="unitdate[@type='inclusive']/@label"/>
							</b>
						</td>
						<td>
							<xsl:apply-templates select="unitdate[@type='inclusive']"/>
						</td>
					</tr>
				</xsl:when>
	
				<xsl:otherwise>
					<tr>
						
						<td valign="top">
							<b>
								<xsl:text>Dates: </xsl:text>
							</b>
						</td>
						<td>
							<xsl:apply-templates select="unitdate[@type='inclusive']"/>
						</td>
					</tr>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
		<xsl:if test="child::unitdate[@type='bulk']">
			
			<xsl:choose>
				<xsl:when test="unitdate[@type='bulk']/@label">
					<tr>
						
						<td valign="top">
							<b>
								<xsl:value-of select="unitdate[@type='bulk']/@label"/>
							</b>
						</td>
						<td>
							<xsl:apply-templates select="unitdate[@type='bulk']"/>
						</td>
					</tr>
				</xsl:when>
				
				<xsl:otherwise>
					<tr>
						
						<td valign="top">
							<b>
								<xsl:text>Bulk Dates: </xsl:text>
							</b>
						</td>
						<td>
							<xsl:apply-templates select="unitdate[@type='bulk']"/>
						</td>
					</tr>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>

	<xsl:template match="archdesc/did/unitdate">

		<xsl:choose>
			<xsl:when test="@label">
				<tr>
					
					<td valign="top">
						<b>
							<xsl:value-of select="@label"/>
						</b>
					</td>
					<td>
						<xsl:apply-templates/>
					</td>
				</tr>
			</xsl:when>
		
			<xsl:otherwise>
				<tr>
				
					<td valign="top">
						<b>
							<xsl:text>Dates: </xsl:text>
						</b>
					</td>
					<td>
						<xsl:apply-templates/>
					</td>
				</tr>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	
	<!-- ************************* -->
	<!-- NOTE element within a DID -->
	<!-- ************************* -->

	<xsl:template match="archdesc/did/note">
		<xsl:for-each select="p">
			<!--The template tests to see if there is a label attribute, inserting the contents if there is or adding one if there isn't. -->
			<xsl:choose>
				<xsl:when test="parent::note[@label]">
					<!--This nested choose tests for and processes the first paragraph. Additional paragraphs do not get a label.-->
					<xsl:choose>
						<xsl:when test="position()=1">
							<tr>
							
								<td valign="top">
									<b>
										<xsl:value-of select="@label"/>
									</b>
								</td>
								<td valign="top">
									<xsl:apply-templates/>
								</td>
							</tr>
						</xsl:when>

						<xsl:otherwise>
							<tr>
								
								<td valign="top"></td>
								<td valign="top">
									<xsl:apply-templates/>
								</td>
							</tr>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>

				<xsl:otherwise>

					<xsl:choose>
						<xsl:when test="position()=1">
							<tr>
								
								<td valign="top">
									<b>
										<xsl:text>Note: </xsl:text>
									</b>
								</td>
								<td>
									<xsl:apply-templates/>
								</td>
							</tr>
						</xsl:when>
		
						<xsl:otherwise>
							<tr>
								<td valign="top"></td>
								<td>
									<xsl:apply-templates/>
								</td>
							</tr>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
			<!--Closes each paragraph-->
		</xsl:for-each>
	</xsl:template>


	<!-- ****************************************************************** -->
	<!-- ARCHDESC Processing						-->
	<!-- Formats the top-level bioghist, scopecontent, phystech, odd, and	-->
	<!-- arrangement elements and creates a link back to the top of the	-->
	<!-- page after the display of the element.  Each HEAD element is also	-->
	<!-- given a generated ID so it can be linked to from the TOC.		-->
	<!-- ****************************************************************** -->

	<xsl:template match="archdesc/bioghist |
			archdesc/scopecontent |
			archdesc/phystech |
			archdesc/odd   |
			archdesc/arrangement">
		<xsl:if test="string(child::*)">	
			<xsl:apply-templates/>
			<p>
				<a href="#">Return to the Table of Contents</a>
			</p>
			<hr></hr>
		</xsl:if>
	</xsl:template>

	<xsl:template match="archdesc/bioghist/head  |
			archdesc/scopecontent/head |
			archdesc/arrangement/head |
			archdesc/phystech/head |
			archdesc/controlaccess/head |
			archdesc/odd/head">
		<h3>
			<a name="{generate-id()}">
				<xsl:apply-templates/>
			</a>
		</h3>
	</xsl:template>

	<xsl:template match="archdesc/bioghist/p |
			archdesc/scopecontent/p |
			archdesc/arrangement/p |
			archdesc/phystech/p |
			archdesc/controlaccess/p |
			archdesc/odd/p">
		<p style="margin-left:25pt">
			<xsl:apply-templates/>
		</p>
	</xsl:template>

	<xsl:template match="archdesc/bioghist/note/p |
			archdesc/scopecontent/note/p |
			archdesc/arrangement/note/p |
			archdesc/phystech/note/p |
			archdesc/controlaccess/note/p |
			archdesc/odd/note/p">
		<p style="margin-left:25pt"><i>Note:
			<xsl:apply-templates/></i>
		</p>
	</xsl:template>
	
	<xsl:template match="archdesc/bioghist/bioghist/head |
		archdesc/scopecontent/scopecontent/head">
		<h3 style="margin-left:25pt">
			<xsl:apply-templates/>
		</h3>
	</xsl:template>
	
	<xsl:template match="archdesc/bioghist/bioghist/p |
		archdesc/scopecontent/scopecontent/p |
		archdesc/bioghist/bioghist/note/p |
		archdesc/scopecontent/scopecontent/note/p">
		<p style="margin-left: 50pt">
			<xsl:apply-templates/>
		</p>
	</xsl:template>


	<!-- Formats an arrangement statement embedded in <scopecontent>. -->
		
	<xsl:template match="archdesc/scopecontent/arrangement/head">
		<h4 style="margin-left:25pt">
			<a name="{generate-id(head)}">
				<xsl:apply-templates/>
			</a>
		</h4>
	</xsl:template>
	
		
	<xsl:template match="archdesc/scopecontent/arrangement/p
	| archdesc/scopecontent/arrangement/note/p">
		<p style="margin-left:50pt">
			<xsl:apply-templates/>
		</p>
	</xsl:template>


	<!-- The next three templates format a list within an arrangement
	statement whether it is directly within <archdesc> or embedded in
	<scopecontent>.-->
	
	<xsl:template match="archdesc/scopecontent/arrangement/list/head">
		<div style="margin-left:25pt">
			<a name="{generate-id(head)}">
				<xsl:apply-templates/>
			</a>
		</div>
	</xsl:template>
	
	<xsl:template match="archdesc/arrangement/list/head">
		<div style="margin-left:25pt">
			<a name="{generate-id()}">
				<xsl:apply-templates/>
			</a>
		</div>
	</xsl:template>
	
	<xsl:template match="archdesc/scopecontent/arrangement/list/item
	| archdesc/arrangement/list/item">
		<div style="margin-left:50pt">
			<!-- <xsl:attribute name="href">#series<xsl:number/></xsl:attribute>
			<xsl:apply-templates/> -->
			<xsl:choose>
				<xsl:when test="parent::list[@type='marked']">
					<div style="margin-left: 25pt">
						&#x2022; <xsl:apply-templates/>
					</div>
				</xsl:when>
				<xsl:otherwise>
		             	<div style="margin-left: 25pt"><xsl:apply-templates/></div>
				</xsl:otherwise>
			</xsl:choose>
		</div>
	</xsl:template>



	<!-- ****************************************************************** -->
	<!-- RELATED MATERIAL, SEPARATED MATERIAL Processing			-->
	<!-- Formats the top-level related material elements by combining any 	-->
	<!-- related or separated materials elements. Test for RELATEDMATERIAL	-->
	<!-- or SEPARATEDMATERIAL elements with content; if present they are	-->
	<!-- combined.  Includes processing of any NOTE or LIST child elements.	-->
	<!-- ****************************************************************** -->
	
	<xsl:template name="archdesc-relatedmaterial">
		<xsl:if test="string(archdesc/relatedmaterial) or
		string(archdesc/*/relatedmaterial) or
		string(archdesc/separatedmaterial) or
		string(archdesc/*/separatedmaterial)">
			<h3>
				<a name="relatedmatlink">
					<b>
						<xsl:text>Related Material</xsl:text>
					</b>
				</a>
			</h3>
                        <!-- <xsl:if test="string(archdesc/separatedmaterial/head)">
                        	<h4 style="margin-left: 25pt"><xsl:apply-templates select="archdesc/separatedmaterial/head"/></h4>
                        </xsl:if> -->
			<xsl:apply-templates select="archdesc/separatedmaterial/p
				| archdesc/*/separatedmaterial/p
				| archdesc/separatedmaterial/blockquote
				| archdesc/separatedmaterial/note/p
				| archdesc/*/separatedmaterial/note/p
				| archdesc/separatedmaterial/list"/>
                        <!-- <xsl:if test="string(archdesc/relatedmaterial/head)">
                        	<h4 style="margin-left: 25pt"><xsl:apply-templates select="archdesc/relatedmaterial/head"/></h4>
                        </xsl:if> -->
			<xsl:apply-templates select="archdesc/relatedmaterial/p
				| archdesc/relatedmaterial/blockquote
				| archdesc/*/relatedmaterial/p
				| archdesc/relatedmaterial/note/p
				| archdesc/*/relatedmaterial/note/p
				| archdesc/relatedmaterial/list"/>
			<p>
				<a href="#">Return to the Table of Contents</a>
			</p>
			<hr></hr>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="archdesc/relatedmaterial/p
		| archdesc/*/relatedmaterial/p
		| archdesc/separatedmaterial/p
		| archdesc/*/separatedmaterial/p
		| archdesc/relatedmaterial/note/p
		| archdesc/*/relatedmaterial/note/p
		| archdesc/separatedmaterial/note/p
		| archdesc/*/separatedmaterial/note/p
		| archdesc/separatedmaterial/list
		| archdesc/relatedmaterial/list">
		<p style="margin-left: 25pt">
			<xsl:apply-templates/>
		</p>
	</xsl:template>


	<!-- ****************************************************************** -->
	<!-- Controlled Access headings 					-->
	<!-- Formats controlled access headings.  Does NOT handle recursive 	-->
	<!-- controlaccess elements. Does NOT require HEAD elements (makes for	-->
	<!-- easier tagging), instead captions are generated.  Subelements 	-->
	<!-- (genreform, etc) do not need to be alphabetized or sorted by type, -->
	<!-- the style sheet handles this.					-->
	<!-- ****************************************************************** -->
	
	<xsl:template match="archdesc/controlaccess">
		<xsl:if test="string(child::*)">
			<h3><b><a name="{generate-id(head)}">Subject Headings</a></b></h3>
			<xsl:if test="persname | famname">
				<h4 style="margin-left:25pt"><b>Persons</b></h4>
				<xsl:for-each select="famname | persname">
					<xsl:sort select="." data-type="text" order="ascending"/>
					<div style="margin-left:50pt"><xsl:apply-templates/></div>
				</xsl:for-each>
			</xsl:if>
			<xsl:if test="corpname">
				<h4 style="margin-left:25pt"><b>Corporate Bodies</b></h4>
				<xsl:for-each select="corpname">
					<xsl:sort select="." data-type="text" order="ascending"/>
					<div style="margin-left:50pt"><xsl:apply-templates/></div>
				</xsl:for-each>
			</xsl:if>
			<xsl:if test="title">
				<h4 style="margin-left:25pt"><b>Associated Titles</b></h4>
				<xsl:for-each select="title">
					<xsl:sort select="." data-type="text" order="ascending"/>
					<div style="margin-left:50pt"><xsl:apply-templates/></div>
				</xsl:for-each>
			</xsl:if>

			<xsl:if test="subject">
				<h4 style="margin-left:25pt"><b>Subjects</b></h4>
				<!-- xsl:for-each select="subject"> -->
				<xsl:for-each select="subject">
					<xsl:sort select="." data-type="text" order="ascending"/>
					<div style="margin-left:50pt"><xsl:apply-templates/></div>
				</xsl:for-each>
			</xsl:if>
			<xsl:if test="geogname">
				<h4 style="margin-left:25pt"><b>Places</b></h4>
				<xsl:for-each select="geogname">
					<xsl:sort select="." data-type="text" order="ascending"/>
					<div style="margin-left:50pt"><xsl:apply-templates/></div>
				</xsl:for-each>
			</xsl:if>
			<xsl:if test="genreform">
				<h4 style="margin-left:25pt"><b>Genres and Forms</b></h4>
				<xsl:for-each select="genreform">
					<xsl:sort select="." data-type="text" order="ascending"/>
					<div style="margin-left:50pt"><xsl:apply-templates/></div>
				</xsl:for-each>
			</xsl:if>
			<xsl:if test="occupation | function">
				<h4 style="margin-left:25pt"><b>Occupations</b></h4>
				<xsl:for-each select="occupation | function">
					<xsl:sort select="." data-type="text" order="ascending"/>
					<div style="margin-left:50pt"><xsl:apply-templates/></div>
				</xsl:for-each>
			</xsl:if>
		</xsl:if>
	</xsl:template>


	<!-- ****************************************************************** -->
	<!-- Access and Use Restriction processing				-->
	<!-- Inclused processing of any NOTE child elements.			-->
	<!-- ****************************************************************** -->

	<xsl:template name="archdesc-restrict">
		<xsl:if test="string(archdesc/userestrict/*)
		or string(archdesc/accessrestrict/*)
		or string(archdesc/*/userestrict/*)
		or string(archdesc/*/accessrestrict/*)">
			<h3>
				<a name="restrictlink">
					<b>
						<xsl:text>Restrictions</xsl:text>
					</b>
				</a>
			</h3>
			<xsl:apply-templates select="archdesc/accessrestrict
				| archdesc/*/accessrestrict"/>
			<xsl:apply-templates select="archdesc/userestrict
				| archdesc/*/userestrict"/>
			<p>
				<a href="#">Return to the Table of Contents</a>
			</p>
			<hr></hr>
		</xsl:if>
	</xsl:template>

	<xsl:template match="archdesc/accessrestrict/head
	| archdesc/userestrict/head
	| archdesc/*/accessrestrict/head
	| archdesc/*/userestrict/head">
		<h4 style="margin-left: 25pt">
			<xsl:apply-templates/>
		</h4>
	</xsl:template>

	<xsl:template match="archdesc/accessrestrict/p
	| archdesc/userestrict/p
	| archdesc/*/accessrestrict/p
	| archdesc/*/userestrict/p
	| archdesc/accessrestrict/note/p
	| archdesc/userestrict/note/p
	| archdesc/*/accessrestrict/note/p
	| archdesc/*/userestrict/note/p">
		<p style="margin-left:50pt">
			<xsl:apply-templates/>
		</p>
	</xsl:template>



	<!-- ****************************************************************** -->
	<!-- Other Admin Info processing					-->
	<!-- Inclused processing of any other administrative information	-->
	<!-- elements and consolidates them into one block under a common	-->
	<!-- heading, "Administrative Information."  If child elements contain	-->
	<!-- a HEAD element it is retained and used as the section title.	-->
	<!-- ****************************************************************** -->
	 
	<xsl:template name="archdesc-admininfo">
		<xsl:if test="string(archdesc/admininfo/custodhist/*)
		or string(archdesc/altformavail/*)
		or string(archdesc/prefercite/*)
		or string(archdesc/acqinfo/*)
		or string(archdesc/processinfo/*)
		or string(archdesc/appraisal/*)
		or string(archdesc/accruals/*)
		or string(archdesc/*/custodhist/*)
		or string(archdesc/*/altformavail/*)
		or string(archdesc/*/prefercite/*)
		or string(archdesc/*/acqinfo/*)
		or string(archdesc/*/processinfo/*)
		or string(archdesc/*/appraisal/*)
		or string(archdesc/*/accruals/*)">
			<h3>
				<a name="adminlink">
					<xsl:text>Administrative Information</xsl:text>
				</a>
			</h3>
			<xsl:apply-templates select="archdesc/custodhist
				| archdesc/*/custodhist"/>
			<xsl:apply-templates select="archdesc/altformavail
				| archdesc/*/altformavail"/>
			<xsl:apply-templates select="archdesc/prefercite
				| archdesc/*/prefercite"/>
			<xsl:apply-templates select="archdesc/acqinfo
				| archdesc/*/acqinfo"/>
			<xsl:apply-templates select="archdesc/processinfo
				| archdesc/*/processinfo"/>
			<xsl:apply-templates select="archdesc/admininfo/appraisal
				| archdesc/*/appraisal"/>
			<xsl:apply-templates select="archdesc/admininfo/accruals
				| archdesc/*/accruals"/>

                        <!-- output information about the author(s) and date(s) of the finding aid -->
		        <h4 style="margin-left:25pt">
			   <b>Finding Aid Information</b>
		        </h4>
                        <p style="margin-left:50pt">
                           Created by: <xsl:apply-templates select="//eadheader/filedesc/titlestmt/author"/><br/>
                           Date: <xsl:apply-templates select="//eadheader/filedesc/publicationstmt/date"/><br/>
                           Revision history: <!-- <xsl:apply-templates select="//eadheader/revisiondesc/list/item"/> -->
						      <xsl:if test="//eadheader/revisiondesc/list/item">
                                 <xsl:apply-templates select="//eadheader/revisiondesc/list/item"/>
							  </xsl:if>
						      <xsl:if test="//eadheader/revisiondesc/change">
							     <xsl:apply-templates select="//eadheader/revisiondesc/change"/>
							  </xsl:if>
                        </p>
			<p>
				<a href="#">Return to the Table of Contents</a>
			</p>
			<hr></hr>
		</xsl:if>
	</xsl:template>

        <xsl:template match="//eadheader/revisiondesc/list/item">
	     <xsl:choose>
                  <xsl:when test="not(position()=last())">
                       <xsl:apply-templates/>; 
                  </xsl:when>
		  <xsl:otherwise>
                       <xsl:apply-templates/>
                  </xsl:otherwise>
             </xsl:choose>             
        </xsl:template>

        <xsl:template match="//eadheader/revisiondesc/change">
	        <xsl:choose>
                <xsl:when test="not(position()=last())">
                    <xsl:value-of select="date"/> - <xsl:value-of select="item"/>; 
                </xsl:when>
		        <xsl:otherwise>
                    <xsl:value-of select="date"/> - <xsl:value-of select="item"/>
                </xsl:otherwise>
            </xsl:choose>             
        </xsl:template>
	
	<xsl:template match="custodhist/head
		| archdesc/altformavail/head
		| archdesc/prefercite/head
		| archdesc/acqinfo/head
		| archdesc/processinfo/head
		| archdesc/appraisal/head
		| archdesc/accruals/head
		| archdesc/*/custodhist/head
		| archdesc/*/altformavail/head
		| archdesc/*/prefercite/head
		| archdesc/*/acqinfo/head
		| archdesc/*/processinfo/head
		| archdesc/*/appraisal/head
		| archdesc/*/accruals/head">
		<h4 style="margin-left:25pt">
			<a name="{generate-id()}">
				<b>
					<xsl:apply-templates/>
				</b>
			</a>
		</h4>
	</xsl:template>	
		
	<xsl:template match="custodhist/p
		| archdesc/altformavail/p
		| archdesc/prefercite/p
		| archdesc/acqinfo/p
		| archdesc/processinfo/p
		| archdesc/appraisal/p
		| archdesc/accruals/p
		| archdesc/*/custodhist/p
		| archdesc/*/altformavail/p
		| archdesc/*/prefercite/p
		| archdesc/*/acqinfo/p
		| archdesc/*/processinfo/p
		| archdesc/*/appraisal/p
		| archdesc/*/accruals/p
		| archdesc/custodhist/note/p
		| archdesc/altformavail/note/p
		| archdesc/prefercite/note/p
		| archdesc/acqinfo/note/p
		| archdesc/processinfo/note/p
		| archdesc/appraisal/note/p
		| archdesc/accruals/note/p
		| archdesc/*/custodhist/note/p
		| archdesc/*/altformavail/note/p
		| archdesc/*/prefercite/note/p
		| archdesc/*/acqinfo/note/p
		| archdesc/*/processinfo/note/p
		| archdesc/*/appraisal/note/p
		| archdesc/*/accruals/note/p">
		
		<p style="margin-left:50pt">
			<xsl:apply-templates/>
		</p>
	</xsl:template>


	<!-- ****************************************************************** -->
	<!-- Other helpful elements processing					-->
	<!-- Processes OTHERFINDAID, BIBLIOGRAPHY, INDEX, FILEPLAN, PHYSTECH,	-->
	<!-- ORIGINALSLOC elements, including any NOT or HEAD child elements.	-->
	<!-- ****************************************************************** -->
		
	<xsl:template match="archdesc/otherfindaid
		| archdesc/*/otherfindaid
		| archdesc/bibliography
		| archdesc/*/bibliography
		| archdesc/originalsloc
		| archdesc/phystech">
			<xsl:apply-templates/>
			<p>
				<a href="#">Return to the Table of Contents</a>
			</p>
			<hr></hr>
		</xsl:template>

	<xsl:template match="archdesc/otherfindaid/head
		| archdesc/*/otherfindaid/head">
		<h3>
		   <a name="otherfindaid"><b><xsl:apply-templates/></b></a>
		</h3>
        </xsl:template>
		
	<xsl:template match="archdesc/bibliography/head
		| archdesc/*/bibliography/head
		| archdesc/fileplan/head
		| archdesc/*/fileplan/head
		| archdesc/phystech/head
		| archdesc/originalsloc/head">
		<h3>
			<a name="{generate-id()}">
				<b>
					<xsl:apply-templates/>
				</b>
			</a>
		</h3>
	</xsl:template>

	<xsl:template match="archdesc/otherfindaid/p
		| archdesc/*/otherfindaid/p
		| archdesc/bibliography/p
		| archdesc/*/bibliography/p
		| archdesc/otherfindaid/note/p
		| archdesc/*/otherfindaid/note/p
		| archdesc/bibliography/note/p
		| archdesc/*/bibliography/note/p
		| archdesc/fileplan/p
		| archdesc/*/fileplan/p
		| archdesc/fileplan/note/p
		| archdesc/*/fileplan/note/p
		| archdesc/phystech/p
		| archdesc/phystech/note/p
		| archdesc/originalsloc/p
		| archdesc/originalsloc/note/p">
		<p style="margin-left:25pt">
			<xsl:apply-templates/>
		</p>
	</xsl:template>


	<xsl:template match="archdesc/index
		| archdesc/*/index">
			<table width="100%">
				<tr>
					<td width="5%"> </td>
					<td width="45%"> </td>
					<td width="50%"> </td>
				</tr>
				<tr>
					<td colspan="3">
                                        	<xsl:choose>
                                        		<xsl:when test="@id">
								<h3>
									<a id="{@id}">
									<b>
										<xsl:apply-templates select="head"/>
									</b>
									</a>
								</h3>
                                        		</xsl:when>
                                        		<xsl:otherwise>
								<h3>
									<a name="{generate-id(head)}">
									<b>
										<xsl:apply-templates select="head"/>
									</b>
									</a>
								</h3>
							</xsl:otherwise>
						</xsl:choose>
					</td>
				</tr>
				<xsl:for-each select="p | note/p">
					<tr>
						<td></td>
						<td colspan="2">
							<xsl:apply-templates/>
						</td>
					</tr>
				</xsl:for-each>

				<!--Processes each index entry.-->
				<xsl:for-each select="indexentry">

				<!--Sorts each entry term.-->
					<xsl:sort select="corpname | famname | function | genreform | geogname | name | occupation | persname | subject"/>
					<tr>
						<td></td>
						<td>
							<xsl:apply-templates select="corpname | famname | function | genreform | geogname | name | occupation | persname | subject"/>
						</td>
						<!--Supplies whitespace and punctuation if there is a pointer
						group with multiple entries.-->

						<xsl:choose>
							<xsl:when test="ptrgrp">
								<td>
									<xsl:for-each select="ptrgrp">
										<xsl:for-each select="ref | ptr">
											<a href="#{@target}">
												<xsl:apply-templates/>
											</a>
											<xsl:if test="following-sibling::ref or following-sibling::ptr">
												<xsl:text>, </xsl:text>
											</xsl:if>
										</xsl:for-each>
									</xsl:for-each>
								</td>
							</xsl:when>
							<!--If there is no pointer group, process each reference or pointer.-->
							<xsl:otherwise>
								<td>
									<xsl:for-each select="ref | ptr">
										<a href="#{@target}">
											<xsl:apply-templates/>
										</a>
									</xsl:for-each>
								</td>
							</xsl:otherwise>
						</xsl:choose>
					</tr>
					<!--Closes the indexentry.-->
				</xsl:for-each>
			</table>
			<p>
				<a href="#">Return to the Table of Contents</a>
			</p>
			<hr></hr>
	</xsl:template>

<!--Insert the address for the dsc stylesheet of your choice here.-->
	<xsl:include href="dsc6_gw_4-30-15.xsl"/>
</xsl:stylesheet>