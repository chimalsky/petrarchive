<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="1.0"
    xmlns:eg="http://www.tei-c.org/ns/Examples"
    xmlns:tei="http://www.tei-c.org/ns/1.0" 
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" 
    xmlns:exsl="http://exslt.org/common"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt"
    xmlns:fn="http://www.w3.org/2005/xpath-functions"
    extension-element-prefixes="exsl msxsl"
    xmlns="http://www.w3.org/1999/xhtml" 
    exclude-result-prefixes="xsl tei xd eg fn #default">
    
    <xsl:import href="teibp.xsl"/>
    <xsl:output method="html" encoding="utf-8" version="1.0" indent="yes" standalone="no" media-type="text/html" omit-xml-declaration="no" doctype-system="about:legacy-compat" /> 
    <xsl:param name="pbNote" select="''"/>
    
    <xsl:param name="jqueryUICSS" select="concat($filePrefix, '/js/jquery-ui/jquery-ui.min.css')"/>
    <xsl:param name="jqueryUI" select="concat($filePrefix,'/js/jquery-ui/jquery-ui.min.js')"/>
    <xsl:param name="jqueryMW" select="concat($filePrefix,'/js/jquery-mousewheel/mousewheel.min.js')"/>

    <xsl:param name="knockout" select="concat($filePrefix,'/js/knockout/knockout-3.4.2.js')"/>

    <!-- Bootstrap v4 requires tether -->
    <xsl:param name="tetherJS" select="concat($filePrefix,'/js/tether/tether.min.js')"/>
    <xsl:param name="bootstrapJS" select="concat($filePrefix,'/js/bootstrap/bootstrap.min.js')"/>


    <xsl:param name="bootstrapCSS" select="concat(
    $filePrefix, '/css/lib/bootstrap.min.css')"/>
    
    <xsl:param name="customCSS.norm" select="concat($filePrefix,'/css/custom_norm.css')"/>
    <xsl:param name="customCSS" select="concat($filePrefix,'/css/custom.css')"/>
    <xsl:param name="frameCSS" select="concat($filePrefix,'/css/frame.css')"/>

    <xsl:template name="stickyHeader">
      <xsl:variable name="header">
        <xsl:copy-of select="document('../sticky_header.html')"/>
      </xsl:variable>
      <xsl:copy-of select="$header"/>
    </xsl:template>

  <xd:doc>
    <xd:desc>
      <xd:p>TEI's head changed to tei-head to avoid conflicts with html/head.</xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:template match="tei:head">
    <tei-head>
      <xsl:call-template name="addID"/>
      <xsl:apply-templates select="@*|node()"/>
    </tei-head>
  </xsl:template>
    
    <xsl:template match="tei:g" priority="99">
      <xsl:variable name="charId" select="substring-after(@ref,'#')"/>
        <xsl:choose>
            <xsl:when test="//tei:char[@xml:id = $charId]/tei:mapping[@type = 'visual']">
              <xsl:value-of select="normalize-space(//tei:char[@xml:id = $charId]/tei:mapping[@type = 'visual'])"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="concat('[',normalize-space(//tei:char[@xml:id = $charId]/tei:charName),']')"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
  
    <xsl:template match="tei:cb[@n='1-of-2']">
        <xsl:variable name="mycb" select="."/>
        <div class="sestina_left" style="float:left;">
            <xsl:apply-templates select="ancestor::tei:lg[@type = 'sestina']//tei:l[preceding::tei:cb[@n = '1-of-2'] = $mycb and following::tei:cb[@n='2-of-2']]" mode="process"/>
        </div>
    </xsl:template>
    
    <xsl:template match="tei:cb[@n='2-of-2']">
        <xsl:variable name="mycb" select="."/>
        <div class="sestina_right" style="float:left; width:500px; margin-right:2em; margin-left:3em;">
            <xsl:apply-templates select="ancestor::tei:lg[@type = 'sestina']//tei:l[preceding::tei:cb[@n = '2-of-2'] = $mycb]" mode="process"/>
        </div>
    </xsl:template>
  
  <xsl:template match="tei:cb[@n='1-of-4']">
    <xsl:variable name="mycb" select="."/>
    <div class="sestina_left" style="float:left;">
      <xsl:apply-templates select="ancestor::tei:lg[@type = 'sestina']//tei:l[preceding::tei:cb[@n = '1-of-4'] = $mycb and following::tei:cb[@n='2-of-4']]" mode="process"/>
    </div>
  </xsl:template>
  
  <xsl:template match="tei:cb[@n='2-of-4']">
    <xsl:variable name="mycb" select="."/>
    <div class="sestina_right" style="float:left; width:500px; margin-right:2em; margin-left:3em;">
      <xsl:apply-templates select="ancestor::tei:lg[@type = 'sestina']//tei:l[preceding::tei:cb[@n = '2-of-4'] = $mycb and following::tei:cb[@n='3-of-4']]" mode="process"/>
    </div>
  </xsl:template>
  
  <xsl:template match="tei:cb[@n='3-of-4']">
    <xsl:variable name="mycb" select="."/>
    <div class="sestina_left" style="float:left;">
      <xsl:apply-templates select="ancestor::tei:lg[@type = 'sestina']//tei:l[preceding::tei:cb[@n = '3-of-4'] = $mycb and following::tei:cb[@n='4-of-4']]" mode="process"/>
    </div>
  </xsl:template>
  
  <xsl:template match="tei:cb[@n='4-of-4']">
    <xsl:variable name="mycb" select="."/>
    <div class="sestina_right" style="float:left; width:500px; margin-right:2em; margin-left:3em;">
      <xsl:apply-templates select="ancestor::tei:lg[@type = 'sestina']//tei:l[preceding::tei:cb[@n = '4-of-4'] = $mycb]" mode="process"/>
    </div>
  </xsl:template>
    
    <xsl:template match="tei:lg[@type = 'sestina']//tei:l[preceding::tei:cb]"/>
    <xsl:template match="tei:lg[@type = 'sestian']//tei:lg">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="tei:lg[@type = 'sestina']//tei:l[preceding::tei:cb]" mode="process">
      <xsl:if test="@n mod 5 = 0">
      <!-- sestina line numbers -->
      <span class="lno"><xsl:value-of select="@n"/></span>
      </xsl:if>
      
      <xsl:element name="{local-name()}">
        <xsl:call-template name="addID"/>
        <xsl:apply-templates select="@*|node()"/>
      </xsl:element>
    </xsl:template>

    <xsl:template match="tei:teiHeader//tei:title">
      <charta>
        <xsl:value-of select="normalize-space(substring-after(string(), ':'))"/>
      </charta>

      <title>
        <xsl:value-of select="normalize-space(substring-before(string(), ':'))"/>
      </title>
	  </xsl:template>
    
    <xsl:param name="htmlTitle">
        <xsl:value-of select="normalize-space(/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title[1])"/>        
    </xsl:param>
    
    <xsl:template name="htmlHead">
        <head>
            <!--
            <script type="text/javascript" src="//use.typekit.net/ctk5ksw.js"></script>
            <script type="text/javascript">try{Typekit.load();}catch(e){}</script>
            -->
             <!-- Required meta tags -->
            <meta charset="utf-8"/>
            <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"/>

            <link id="bootstrap" rel="stylesheet" type="text/css" href="{$bootstrapCSS}"/>
            <link id="jqueryuicss" rel="stylesheet" type="text/css" href="{$jqueryUICSS}"/>


            <link id="maincss" rel="stylesheet" type="text/css" href="{$teibpCSS}"/>

            <link id="customcss" rel="stylesheet" type="text/css" href="{$customCSS}"/>

            <link id="framecss" rel="stylesheet" type="text/css" href="{$frameCSS}"/>

           
            <xsl:call-template name="rendition2style"/>
            <title><xsl:value-of select="$htmlTitle"/><!-- don't leave empty. --></title>
            <xsl:if test="$includeAnalytics = true()">
                <xsl:call-template name="analytics"/>
            </xsl:if>

            <script src="https://use.fontawesome.com/57840704ee.js"></script>
            <!--
            <script type="text/javascript" src="{$jqueryJS}"></script>

            <script type="text/javascript" src="{$tetherJS}"></script>
            <script type="text/javascript" src="{$bootstrapJS}"></script>

            <script type="text/javascript" src="{$jqueryUI}"></script>
            <script type="text/javascript" src="{$jqueryMW}"></script>

            <script type="text/javascript" src="{$knockout}"></script>
            -->

            <script type="text/javascript" src="{$teibpJS}"><xsl:comment> </xsl:comment></script>

            <script type="text/javascript" src="../dist/js/poem.bundle.js"></script>

            <!--
            <script type="text/javascript" src="../js/utils/browser.js"><xsl:comment> </xsl:comment></script>

            <script type="text/javascript" src="../js/petrarchivedocument.js"><xsl:comment> </xsl:comment></script>


            <script type="text/javascript" src="../js/petrarchive.js"><xsl:comment> </xsl:comment></script>

            <script type="text/javascript" src="../js/frame.js"><xsl:comment> </xsl:comment></script>
            <script type="text/javascript" src="../js/navutil.js"><xsl:comment> </xsl:comment></script>
            <script type="text/javascript" src="../js/commentaryutil.js"><xsl:comment> </xsl:comment></script>

            <script type="text/javascript" src="../js/poem.js"><xsl:comment> </xsl:comment></script>
            -->
        </head>
    </xsl:template>
    
    <xsl:variable name="htmlFooter">
      <footer>© 2013-2018 H. Wayne Storey, John A. Walsh &amp; Isabella Magni. This document is part of the Petr<em>archive</em>.<br/>
        Team: H. Wayne Storey, John A. Walsh, Isabella Magni, Erica Hayes, Lino Mioni, and Abraham Kim. 

        <br />Past Contributors: Grace Thomas, Allison M. McCormack, and Laura Pence.<br/>
        <a rel="license" href="http://creativecommons.org/licenses/by/4.0/"><img alt="Creative Commons License" style="border-width:0" src="http://i.creativecommons.org/l/by/4.0/80x15.png" /></a>&#160;
        <a xmlns:cc="http://creativecommons.org/ns#" href="http://petrarchive.org" property="cc:attributionName" rel="cc:attributionURL"><span xmlns:dct="http://purl.org/dc/terms/" property="dct:title">Petr<i>archive</i></span></a> by <a href="http://www.indiana.edu/~frithome/faculty/italian/storey.shtml">H. Wayne Storey</a> and <a href="http://johnwalsh.name/">John A. Walsh</a> is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by/4.0/">Creative Commons Attribution 4.0 International License</a>.<br/>
        Funding and support provided by the <a href="http://neh.gov/">National Endowment for the Humanities</a> and <a href="http://www.indiana.edu/">Indiana University-Bloomington</a>.<br/>
        Powered by <a href="{$teibpHome}">TEI Boilerplate</a>.
      </footer>

    </xsl:variable>
  
<xd:doc><xd:desc>These lines get line numbers. Canzone is not regular.</xd:desc></xd:doc>
  
  <!-- alternate for 7vv:
        tei:lg[@type = 'canzone_7vv']//tei:l[@n = '5']|
    tei:lg[@type = 'canzone_7vv']//tei:l[@n = '10']|
    tei:lg[@type = 'canzone_7vv']//tei:l[@n = '15']|
    tei:lg[@type = 'canzone_7vv']//tei:l[@n = '21']|
    tei:lg[@type = 'canzone_7vv']//tei:l[@n = '26']|
    tei:lg[@type = 'canzone_7vv']//tei:l[@n = '31']|
    tei:lg[@type = 'canzone_7vv']//tei:l[@n = '35']|
    tei:lg[@type = 'canzone_7vv']//tei:l[@n = '40']|
    tei:lg[@type = 'canzone_7vv']//tei:l[@n = '45']|
    tei:lg[@type = 'canzone_7vv']//tei:l[@n = '49']|
    tei:lg[@type = 'canzone_7vv']//tei:l[@n = '56']|
    tei:lg[@type = 'canzone_7vv']//tei:l[@n = '61']|
    tei:lg[@type = 'canzone_7vv']//tei:l[@n = '66']|
    tei:lg[@type = 'canzone_7vv']//tei:l[@n = '70']|
    tei:lg[@type = 'canzone_7vv']//tei:l[@n = '74']|
   -->
  <!-- alternate for 14vv:
    
    tei:lg[@type = 'canzone_14vv']//tei:l[@n = '5']|
    tei:lg[@type = 'canzone_14vv']//tei:l[@n = '10']|
    tei:lg[@type = 'canzone_14vv']//tei:l[@n = '15']|
    tei:lg[@type = 'canzone_14vv']//tei:l[@n = '21']|
    tei:lg[@type = 'canzone_14vv']//tei:l[@n = '26']|
    tei:lg[@type = 'canzone_14vv']//tei:l[@n = '31']|
    tei:lg[@type = 'canzone_14vv']//tei:l[@n = '35']|
    tei:lg[@type = 'canzone_14vv']//tei:l[@n = '40']|
    tei:lg[@type = 'canzone_14vv']//tei:l[@n = '45']|
    tei:lg[@type = 'canzone_14vv']//tei:l[@n = '49']|
    tei:lg[@type = 'canzone_14vv']//tei:l[@n = '56']|
    tei:lg[@type = 'canzone_14vv']//tei:l[@n = '61']|
    tei:lg[@type = 'canzone_14vv']//tei:l[@n = '66']|
    tei:lg[@type = 'canzone_14vv']//tei:l[@n = '70']|
    tei:lg[@type = 'canzone_14vv']//tei:l[@n = '74']|
    
    -->
  
    <!-- alternate for 20vv:
       tei:lg[@type = 'canzone_20vv']//tei:l[@n mod 5 = 0 and @n mod 10 != 0]|
    -->
  
  <xsl:template match="tei:lg[@type = 'madrigal']//tei:l[@n = '4']|
    tei:lg[@type = 'madrigal']//tei:l[@n = '7']|
    tei:lg[@type = 'ballata_mezzana']//tei:l[@n = '3']|
    tei:lg[@type = 'ballata_mezzana']//tei:l[@n = '8']|
    tei:lg[@type = 'ballata_grande']//tei:l[@n = '5']|
    tei:lg[@type = 'ballata_grande']//tei:l[@n = '9']|
    tei:lg[@type = 'sonnet']//tei:l[@n = '5']|
    tei:lg[@type = 'sonnet']//tei:l[@n = '9']|
    
    tei:lg[@type = 'canzone_7vv']//tei:l[@n mod 7 = 0]|
    
    tei:lg[@type = 'canzone_10vv']//tei:l[@n mod 5 = 0]|
    
    tei:lg[@type = 'canzone_14vv']//tei:l[@n mod 7 = 0]|
    
   
    
    
    tei:lg[@type = 'canzone_15vv']//tei:l[@n = '5']|
    tei:lg[@type = 'canzone_15vv']//tei:l[@n = '15']|
    tei:lg[@type = 'canzone_15vv']//tei:l[@n = '20']|
    tei:lg[@type = 'canzone_15vv']//tei:l[@n = '30']|
    tei:lg[@type = 'canzone_15vv']//tei:l[@n = '35']|
    tei:lg[@type = 'canzone_15vv']//tei:l[@n = '45']|
    tei:lg[@type = 'canzone_15vv']//tei:l[@n = '50']|
    tei:lg[@type = 'canzone_15vv']//tei:l[@n = '60']|
    tei:lg[@type = 'canzone_15vv']//tei:l[@n = '65']|
    tei:lg[@type = 'canzone_15vv']//tei:l[@n = '75']|
    tei:lg[@type = 'canzone_15vv']//tei:l[@n = '80']|
    tei:lg[@type = 'canzone_15vv']//tei:l[@n = '90']|
    tei:lg[@type = 'canzone_15vv']//tei:l[@n = '95']|
    tei:lg[@type = 'canzone_15vv']//tei:l[@n = '105']|
    tei:lg[@type = 'canzone_15vv']//tei:l[@n = '110']|
    tei:lg[@type = 'canzone_15vv']//tei:l[@n = '120']|
    tei:lg[@type = 'canzone_15vv']//tei:l[@n = '125']|
    tei:lg[@type = 'canzone_15vv']//tei:l[@n = '135']|
    tei:lg[@type = 'canzone_15vv']//tei:l[@n = '140']|
    tei:lg[@type = 'canzone_15vv']//tei:l[@n = '150']|
    tei:lg[@type = 'canzone_15vv']//tei:l[@n = '155']|
    
    
    tei:lg[@type = 'canzone_16vv']//tei:l[@n = '5']|
    tei:lg[@type = 'canzone_16vv']//tei:l[@n = '9']|
    tei:lg[@type = 'canzone_16vv']//tei:l[@n = '15']|
    tei:lg[@type = 'canzone_16vv']//tei:l[@n = '19']|
    tei:lg[@type = 'canzone_16vv']//tei:l[@n = '25']|
    tei:lg[@type = 'canzone_16vv']//tei:l[@n = '29']|
    tei:lg[@type = 'canzone_16vv']//tei:l[@n = '35']|
    tei:lg[@type = 'canzone_16vv']//tei:l[@n = '39']|
    tei:lg[@type = 'canzone_16vv']//tei:l[@n = '45']|
    tei:lg[@type = 'canzone_16vv']//tei:l[@n = '49']|
    tei:lg[@type = 'canzone_16vv']//tei:l[@n = '55']|
    tei:lg[@type = 'canzone_16vv']//tei:l[@n = '59']|
    tei:lg[@type = 'canzone_16vv']//tei:l[@n = '65']|
    tei:lg[@type = 'canzone_16vv']//tei:l[@n = '69']|
    tei:lg[@type = 'canzone_16vv']//tei:l[@n = '75']|
    tei:lg[@type = 'canzone_16vv']//tei:l[@n = '79']|
    tei:lg[@type = 'canzone_16vv']//tei:l[@n = '85']|
    tei:lg[@type = 'canzone_16vv']//tei:l[@n = '89']|
    tei:lg[@type = 'canzone_16vv']//tei:l[@n = '95']|
    tei:lg[@type = 'canzone_16vv']//tei:l[@n = '99']|
    tei:lg[@type = 'canzone_16vv']//tei:l[@n = '105']|
    tei:lg[@type = 'canzone_16vv']//tei:l[@n = '109']|
    tei:lg[@type = 'canzone_16vv']//tei:l[@n = '115']|
    tei:lg[@type = 'canzone_16vv']//tei:l[@n = '119']|
    
    tei:lg[@type = 'canzone_20vv']//tei:l[@n = '5']|
    tei:lg[@type = 'canzone_20vv']//tei:l[@n = '9']|
    tei:lg[@type = 'canzone_20vv']//tei:l[@n = '15']|
    tei:lg[@type = 'canzone_20vv']//tei:l[@n = '21']|
    tei:lg[@type = 'canzone_20vv']//tei:l[@n = '25']|
    tei:lg[@type = 'canzone_20vv']//tei:l[@n = '31']|
    tei:lg[@type = 'canzone_20vv']//tei:l[@n = '35']|
    tei:lg[@type = 'canzone_20vv']//tei:l[@n = '41']|
    tei:lg[@type = 'canzone_20vv']//tei:l[@n = '45']|
    tei:lg[@type = 'canzone_20vv']//tei:l[@n = '51']|
    tei:lg[@type = 'canzone_20vv']//tei:l[@n = '55']|
    tei:lg[@type = 'canzone_20vv']//tei:l[@n = '61']|
    tei:lg[@type = 'canzone_20vv']//tei:l[@n = '65']|
    tei:lg[@type = 'canzone_20vv']//tei:l[@n = '71']|
    tei:lg[@type = 'canzone_20vv']//tei:l[@n = '75']|
    tei:lg[@type = 'canzone_20vv']//tei:l[@n = '81']|
    tei:lg[@type = 'canzone_20vv']//tei:l[@n = '85']|
    tei:lg[@type = 'canzone_20vv']//tei:l[@n = '91']|
    tei:lg[@type = 'canzone_20vv']//tei:l[@n = '95']|
    tei:lg[@type = 'canzone_20vv']//tei:l[@n = '101']|
    tei:lg[@type = 'canzone_20vv']//tei:l[@n = '105']|
    tei:lg[@type = 'canzone_20vv']//tei:l[@n = '111']|
    tei:lg[@type = 'canzone_20vv']//tei:l[@n = '115']|
    tei:lg[@type = 'canzone_20vv']//tei:l[@n = '121']|
    tei:lg[@type = 'canzone_20vv']//tei:l[@n = '125']|
    tei:lg[@type = 'canzone_20vv']//tei:l[@n = '131']|
    tei:lg[@type = 'canzone_20vv']//tei:l[@n = '135']|
    tei:lg[@type = 'canzone_20vv']//tei:l[@n = '141']|
    tei:lg[@type = 'canzone_20vv']//tei:l[@n = '145']|
    tei:lg[@type = 'canzone_20vv']//tei:l[@n = '151']|
    tei:lg[@type = 'canzone_20vv']//tei:l[@n = '155']|
    tei:lg[@type = 'canzone_20vv']//tei:l[@n = '161']|
    tei:lg[@type = 'canzone_20vv']//tei:l[@n = '165']">
        <span class="lno"><xsl:value-of select="@n"/></span>
            <xsl:element name="{local-name()}">
                <xsl:call-template name="addID"/>
                <xsl:apply-templates select="@*|node()"/>
            </xsl:element>
    </xsl:template>
  
  <xsl:template match="tei:lg[@xml:id = 'rvf360']//tei:l[@n = '1']|
    tei:lg[@xml:id = 'rvf360']//tei:l[@n = '4']|
    tei:lg[@xml:id = 'rvf360']//tei:l[@n = '7']|
    tei:lg[@xml:id = 'rvf360']//tei:l[@n = '10']|
    tei:lg[@xml:id = 'rvf360']//tei:l[@n = '13']|
    tei:lg[@xml:id = 'rvf360']//tei:l[@n = '16']|
    tei:lg[@xml:id = 'rvf360']//tei:l[@n = '19']|
    tei:lg[@xml:id = 'rvf360']//tei:l[@n = '22']|
    tei:lg[@xml:id = 'rvf360']//tei:l[@n = '25']|
    tei:lg[@xml:id = 'rvf360']//tei:l[@n = '28']|
    tei:lg[@xml:id = 'rvf360']//tei:l[@n = '31']|
    tei:lg[@xml:id = 'rvf360']//tei:l[@n = '34']|
    tei:lg[@xml:id = 'rvf360']//tei:l[@n = '37']|
    tei:lg[@xml:id = 'rvf360']//tei:l[@n = '40']|
    tei:lg[@xml:id = 'rvf360']//tei:l[@n = '43']|
    tei:lg[@xml:id = 'rvf360']//tei:l[@n = '46']|
    tei:lg[@xml:id = 'rvf360']//tei:l[@n = '49']|
    tei:lg[@xml:id = 'rvf360']//tei:l[@n = '52']|
    tei:lg[@xml:id = 'rvf360']//tei:l[@n = '55']|
    tei:lg[@xml:id = 'rvf360']//tei:l[@n = '58']|
    tei:lg[@xml:id = 'rvf360']//tei:l[@n = '61']|
    tei:lg[@xml:id = 'rvf360']//tei:l[@n = '64']|
    tei:lg[@xml:id = 'rvf360']//tei:l[@n = '67']|
    tei:lg[@xml:id = 'rvf360']//tei:l[@n = '70']|
    tei:lg[@xml:id = 'rvf360']//tei:l[@n = '73']|
    tei:lg[@xml:id = 'rvf360']//tei:l[@n = '76']|
    tei:lg[@xml:id = 'rvf360']//tei:l[@n = '79']|
    tei:lg[@xml:id = 'rvf360']//tei:l[@n = '82']|
    tei:lg[@xml:id = 'rvf360']//tei:l[@n = '85']|
    tei:lg[@xml:id = 'rvf360']//tei:l[@n = '88']|
    tei:lg[@xml:id = 'rvf360']//tei:l[@n = '91']|
    tei:lg[@xml:id = 'rvf360']//tei:l[@n = '94']|
    tei:lg[@xml:id = 'rvf360']//tei:l[@n = '97']|
    tei:lg[@xml:id = 'rvf360']//tei:l[@n = '100']|
    tei:lg[@xml:id = 'rvf360']//tei:l[@n = '103']|
    tei:lg[@xml:id = 'rvf360']//tei:l[@n = '106']|
    tei:lg[@xml:id = 'rvf360']//tei:l[@n = '109']|
    tei:lg[@xml:id = 'rvf360']//tei:l[@n = '112']|
    tei:lg[@xml:id = 'rvf360']//tei:l[@n = '115']|
    tei:lg[@xml:id = 'rvf360']//tei:l[@n = '118']|
    tei:lg[@xml:id = 'rvf360']//tei:l[@n = '121']|
    tei:lg[@xml:id = 'rvf360']//tei:l[@n = '124']|
    tei:lg[@xml:id = 'rvf360']//tei:l[@n = '127']|
    tei:lg[@xml:id = 'rvf360']//tei:l[@n = '130']|
    tei:lg[@xml:id = 'rvf360']//tei:l[@n = '133']|
    tei:lg[@xml:id = 'rvf360']//tei:l[@n = '136']|
    tei:lg[@xml:id = 'rvf360']//tei:l[@n = '139']|
    tei:lg[@xml:id = 'rvf360']//tei:l[@n = '142']|
    tei:lg[@xml:id = 'rvf360']//tei:l[@n = '145']|
    tei:lg[@xml:id = 'rvf360']//tei:l[@n = '148']|
    tei:lg[@xml:id = 'rvf360']//tei:l[@n = '151']|
    tei:lg[@xml:id = 'rvf360']//tei:l[@n = '154']|
    tei:lg[@xml:id = 'rvf360']//tei:l[@n = '157']" priority="80">
    <!-- Isabella: continue with line numbers above. -->
    <span class="lno"><xsl:value-of select="@n"/></span>
  <xsl:element name="{local-name()}">
    <xsl:call-template name="addID"/>
    <xsl:apply-templates select="@*|node()"/>
  </xsl:element>
  </xsl:template>
  
  <xsl:template match="tei:lg[@type = 'canzone_15vv']//tei:l[@n = '5']|
    tei:lg[@type = 'canzone_15vv']//tei:l[@n = '15']|
    tei:lg[@type = 'canzone_15vv']//tei:l[@n = '20']|
    tei:lg[@type = 'canzone_15vv']//tei:l[@n = '30']|
    tei:lg[@type = 'canzone_15vv']//tei:l[@n = '35']|
    tei:lg[@type = 'canzone_15vv']//tei:l[@n = '45']|
    tei:lg[@type = 'canzone_15vv']//tei:l[@n = '50']|
    tei:lg[@type = 'canzone_15vv']//tei:l[@n = '60']|
    tei:lg[@type = 'canzone_15vv']//tei:l[@n = '65']|
    tei:lg[@type = 'canzone_15vv']//tei:l[@n = '75']|
    tei:lg[@type = 'canzone_15vv']//tei:l[@n = '80']|
    tei:lg[@type = 'canzone_15vv']//tei:l[@n = '90']|
    tei:lg[@type = 'canzone_15vv']//tei:l[@n = '95']|
    tei:lg[@type = 'canzone_15vv']//tei:l[@n = '105']|
    tei:lg[@type = 'canzone_15vv']//tei:l[@n = '110']|
    tei:lg[@type = 'canzone_15vv']//tei:l[@n = '120']|
    tei:lg[@type = 'canzone_15vv']//tei:l[@n = '125']|
    tei:lg[@type = 'canzone_15vv']//tei:l[@n = '135']|
    tei:lg[@type = 'canzone_15vv']//tei:l[@n = '140']|
    tei:lg[@type = 'canzone_15vv']//tei:l[@n = '150']|
    tei:lg[@type = 'canzone_15vv']//tei:l[@n = '155']" mode="rvf360v">
    <span class="lno"><xsl:value-of select="@n"/></span>
    <xsl:element name="{local-name()}">
      <xsl:call-template name="addID"/>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="tei:lg[@xml:id[starts-with(.,'rvf')]]">
    <xsl:call-template name="poemNumber" /> 
    
    <xsl:element name="{local-name()}">
      <xsl:call-template name="addID"/>
      
      <xsl:apply-templates select="@*|node()" />
    </xsl:element>
  </xsl:template>
 
  <xsl:template name="poemNumber">
    <span class="poem-number">
      <xsl:attribute name="number">
        <xsl:value-of select="@n"/>
      </xsl:attribute>

      <xsl:value-of select="@n"></xsl:value-of>
     
      <xsl:if test="//tei:back/tei:div[@type = 'commentary']/@corresp = concat('#',@xml:id)">
        <button class="commentary-activate" id="{@xml:id}">
            <i class="fa fa-commenting-o"></i>
        </button>
      </xsl:if>
    </span>
  </xsl:template>

  <xsl:template match="tei:pb[@facs]">
    <xsl:param name="pn">
        <xsl:number count="//tei:pb" level="any"/>    
    </xsl:param>
    <xsl:choose>
    <xsl:when test="$displayPageBreaks = true()">
        <span class="-teibp-pb">
            <xsl:call-template name="addID"/>
            <xsl:call-template name="pb-handler">
                <xsl:with-param name="n" select="@n"/>
                <xsl:with-param name="facs" select="@facs"/>
                <xsl:with-param name="id">
                    <xsl:choose>
                    <xsl:when test="@xml:id">
                        <xsl:value-of select="@xml:id"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="generate-id()"/>
                    </xsl:otherwise>
                    </xsl:choose>
                </xsl:with-param>
            </xsl:call-template>
        </span>
    </xsl:when>
        <xsl:otherwise>
            <xsl:copy>
                <xsl:apply-templates select="@*|node()"/>
            </xsl:copy>
        </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
    
  
  <xsl:template match="*" mode="rvf360v"> 
    <xsl:element name="{local-name()}">
      <xsl:call-template name="addID"/>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="//tei:lg[@xml:id = 'rvf360v']//tei:l[@sameAs]" priority="99">
    <xsl:param name="sameAs" select="substring-after(@sameAs,'#')"/>
    <xsl:apply-templates select="//*[@xml:id = $sameAs]" mode="rvf360v"/>
  </xsl:template>
  
    <xsl:template match="*[@sameAs]">
        <xsl:param name="sameAs" select="substring-after(@sameAs,'#')"/>
        <xsl:apply-templates select="//*[@xml:id = $sameAs]"/>
    </xsl:template>
  
  <xsl:template name="pb-handler">
    <xsl:param name="n"/>
    <xsl:param name="facs"/>
    <xsl:param name="id"/>
    
    <div class="-teibp-pageNum align-items-center">
      <span class="-teibp-pbNote"><xsl:value-of select="$pbNote"/></span>
      
      <i class="fa fa-pagelines"></i> 
      <xsl:value-of select="@n"/> 
      <i class="fa fa-pagelines"></i>
    </div>

    <span class="-teibp-pbFacs hide">
      <a class="gallery-facs" rel="prettyPhoto[gallery1]">
        <img alt="{$altTextPbFacs}" class="-teibp-thumbnail">
          <xsl:attribute name="src">
            <xsl:value-of select="@facs"/>
          </xsl:attribute>
        </img>
      </a>
    </span>
  </xsl:template>


  
  
  
  <xsl:template match="tei:ab[@type = 'blockSubst']">
    <xsl:variable name="maniculeId" select="concat(@xml:id,'Trigger')"/>
    <div id="{$maniculeId}" class="manicule-palimpsest-trigger">
      <xsl:attribute name="onclick">
        <!-- <xsl:value-of select="concat('showHide(&quot;',$maniculeId,'&quot;,&quot;',tei:subst/tei:del/tei:lg/@xml:id, '&quot;,&quot;',tei:subst/tei:add/tei:lg/@xml:id,'&quot;)'"/> -->
        <xsl:value-of select="'JavaScript:PT.showHide('"/>
        <xsl:value-of select="$apos"/>
        <xsl:value-of select="$maniculeId"/>
        <xsl:value-of select="concat($apos,',',$apos)"/>
        <xsl:value-of select="normalize-space(tei:subst/tei:del/tei:lg/@xml:id)"/>
        <xsl:value-of select="concat($apos,',',$apos)"/>
        <xsl:value-of select="normalize-space(tei:subst/tei:add/tei:lg/@xml:id)"/>
        <xsl:value-of select="concat($apos,')')"/>
      </xsl:attribute>  
      <xsl:value-of select="'&#x261C;'"/>
    </div>
      <xsl:element name="{local-name()}">
        <xsl:call-template name="addID"/>
        <xsl:apply-templates select="@*|node()"/>
      </xsl:element>
  </xsl:template>

  <xsl:template name="getCommentaryTitle">
    <xsl:param name="type"/>

    <xsl:choose>
        <xsl:when test="$type = 'introduction'">
          <xsl:value-of select="'Introduction'"/>
        </xsl:when>
        <xsl:when test="$type = 'prosody'">
          <xsl:value-of select="'Prosodic features'"/>
        </xsl:when>
        <xsl:when test="$type = 'syntax'">
          <xsl:value-of select="'Syntactic features'"/>
        </xsl:when>
        <xsl:when test="$type = 'genesis'">
          <xsl:value-of select="'Historical genesis'"/>
        </xsl:when>
        <xsl:when test="$type = 'diplomatics'">
          <xsl:value-of select="'Physical collocation and diplomatic conditions'"/>
        </xsl:when>
        <xsl:when test="$type = 'variants'">
          <xsl:value-of select="'Significant variants from the tradition'"/>
        </xsl:when>
        <xsl:when test="$type = 'language'">
          <xsl:value-of select="'Language notes'"/>
        </xsl:when>
        <xsl:when test="$type = 'thematics'">
          <xsl:value-of select="'Thematic notes'"/>
        </xsl:when>
        <xsl:when test="$type = 'translation'">
          <xsl:value-of select="'Translation'"/>
        </xsl:when>
    </xsl:choose>
  </xsl:template>
  
  
 
  <xsl:template name="commentaryNav">
    <xsl:param name="rvfTarget"/>
      <ul class="">
        <li class=''>
          <a class="active" href="{concat('#',$rvfTarget,'_introduction')}">
            Introduction &amp; prosody
          </a>
        </li>
        
        <li class="">
          <a href="{concat('#',$rvfTarget,'_genesis')}">
            Genesis &amp; diplomatic condition
          </a>
        </li>
        
        <li class="">
          <a href="{concat('#',$rvfTarget,'_syntax')}">
            Syntax, variants, &amp; language
          </a>
        </li>
       
        
        <li class="">
          <a href="{concat('#',$rvfTarget,'_thematics')}">
            Thematics
          </a>
        </li>
        
        <li class="">
          <a href="{concat('#',$rvfTarget,'_translation')}">
            Translation
          </a>
        </li>
      </ul>
    
  </xsl:template>

  <xsl:template match="tei:div[@type= 'commentary']/tei:note|tei:div[@type= 'commentary']/tei:div[@type= 'translation']" mode="commentary">
      <section type="{@type}">
        <h1>
        <xsl:call-template name="getCommentaryTitle">
          <xsl:with-param name="type" select="@type" />
        </xsl:call-template>
        </h1>
        <xsl:apply-templates select="."/>
      </section>
  </xsl:template>
  
  <xsl:template match="tei:div[@type = 'commentary']">
    <div class="commentary" id="{substring-after(concat(@corresp, '-commentary'), '#')}">
      <xsl:variable name="rvfTarget" select="substring-after(@corresp,'#')"/>
      <xsl:variable name="rvfNum" select="//tei:lg[@xml:id = $rvfTarget]/@n"/>
      
      <header class="row no-gutters justify-content-start">
        <div class="col col-md-auto">
          <h1>
            Commentary: <cite>Rvf</cite> <xsl:value-of select="' '"/><xsl:value-of select="$rvfNum"/>
          </h1>
        </div>

        <div class="col hidden-md-up text-right">
          <button class="close">
            <i class="fa fa-window-close-o"></i>
          </button>
        </div>
        
        <nav class="commentary col-md-auto">  
          <xsl:call-template name="commentaryNav">
            <xsl:with-param name="rvfTarget" select="$rvfTarget"/>
          </xsl:call-template>
        </nav>

        <div class="col-auto hidden-sm-down text-right">
          <button class="close">
            <i class="fa fa-window-close-o"></i>
          </button>
        </div>
      </header>
      
      <main>
        <!-- commentary body -->
        <section id="{concat($rvfTarget,'_introduction')}">
          <xsl:apply-templates select="tei:note[@type='introduction']" mode="commentary"/>
          <xsl:apply-templates select="tei:note[@type='prosody']" mode="commentary"/>
        </section>
        <section id="{concat($rvfTarget,'_genesis')}">
          <xsl:apply-templates select="tei:note[@type='genesis']" mode="commentary"/>
          <xsl:apply-templates select="tei:note[@type='diplomatics']" mode="commentary"/>
        </section>
        <section id="{concat($rvfTarget,'_syntax')}">
          <xsl:apply-templates select="tei:note[@type='syntax']" mode="commentary"/>
          <xsl:apply-templates select="tei:note[@type='variants']" mode="commentary"/>
          <xsl:apply-templates select="tei:note[@type='language']" mode="commentary"/>
        </section>
        <section id="{concat($rvfTarget,'_thematics')}">
          <xsl:apply-templates select="tei:note[@type='thematics']" mode="commentary"/>
        </section>
        <section id="{concat($rvfTarget,'_translation')}">
          <xsl:apply-templates select="tei:note[@type='translation']" mode="commentary"/>
        </section>
      </main>
    </div>
  </xsl:template>

  
    
</xsl:stylesheet>
