<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    exclude-result-prefixes="#all"
    xmlns:xh="http://www.w3.org/1999/xhtml"
    xmlns="http://www.tei-c.org/ns/1.0"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    version="3.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> May 4, 2023</xd:p>
            <xd:p><xd:b>Author:</xd:b> takeda</xd:p>
            <xd:p></xd:p>
        </xd:desc>
    </xd:doc>

    <xsl:mode name="original" on-no-match="shallow-copy"/>
    
    <xsl:template name="makeOriginalXml">
        <xsl:result-document href="{$pd}/public/xml/{//TEI/@xml:id}.xml">
            <xsl:message select="'Creating ' || current-output-uri()"/>
            <xsl:apply-templates select="." mode="original"/>
        </xsl:result-document>
    </xsl:template>
    
    
   
    
    <xd:doc>
        <xd:desc>Resolve any imports via @copyOf</xd:desc>
    </xd:doc>
    <xsl:template match="*[@copyOf]" mode="original">
        <xsl:variable name="tokens" select="tokenize(@copyOf,'#')"/>
        <xsl:variable name="doc" select="$tokens[1]"/>
        <xsl:variable name="id" select="$tokens[2]"/>
        <xsl:copy>
            <xsl:apply-templates select="document($doc)//*[@xml:id = $id]/node()" mode="#current"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="@start" mode="original">
        <xsl:attribute name="from-iso" select="."/>
    </xsl:template>
    
    <xsl:template match="@end" mode="original">
        <xsl:attribute name="to-iso" select="."/>
    </xsl:template>
    
    
    
</xsl:stylesheet>