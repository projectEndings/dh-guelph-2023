<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    exclude-result-prefixes="#all"
    xmlns:xh="http://www.w3.org/1999/xhtml"
    xmlns="http://www.w3.org/1999/xhtml"
    xpath-default-namespace="http://www.w3.org/1999/xhtml"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:jt="https://github.com/joeytakeda"
    version="3.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> May 4, 2023</xd:p>
            <xd:p><xd:b>Author:</xd:b> takeda</xd:p>
            <xd:p></xd:p>
        </xd:desc>
    </xd:doc>
    
    <xsl:include href="original_module.xsl"/>
    <xsl:include href="tei_module.xsl"/>
    
    <xsl:param name="pd" select="substring-before(static-base-uri(),'/xsl/')"/>
    
    <xsl:strip-space elements="*"/>
    
    <xsl:variable name="template" select="document($pd || '/site/base.html?strip-space=yes')" as="document-node()"/>
    <xsl:variable name="data" select="collection( $pd || '/data?select=*.xml')" as="document-node()+"/>   
    <xsl:variable name="odd" select="document( $pd || '/sch/dh-guelph-2023.odd')"/>
    
    <xd:doc>
        <xd:desc>Driver Template</xd:desc>
    </xd:doc>
    <xsl:template name="main">
        <xsl:for-each select="$data">
            <xsl:call-template name="makeOriginalXml"/>
            <xsl:call-template name="makeHTML"/>
        </xsl:for-each>
    </xsl:template>
    
    
    <xsl:template name="makeHTML">
        <xsl:apply-templates select="$template" mode="html">
            <xsl:with-param name="doc" select="." tunnel="yes"/>
        </xsl:apply-templates>
    </xsl:template>
    
    <xsl:mode name="html" on-no-match="shallow-copy"/>
    
    <xsl:template match="html" mode="html">
        <xsl:param name="doc" tunnel="yes"/>
        <xsl:variable name="id" select="$doc//tei:TEI/@xml:id"/>
        <xsl:result-document indent="yes" href="{$pd}/public/{$id}.html" method="xhtml" html-version="5.0">
            <xsl:message select="'Creating ' || current-output-uri()"/>
            <xsl:copy>
                <xsl:apply-templates select="@*|node()" mode="#current">
                    <xsl:with-param name="id" select="$id" tunnel="yes"/>
                </xsl:apply-templates>
            </xsl:copy>
        </xsl:result-document>
    </xsl:template>
    
    <xsl:template match="html/@id" mode="html">
        <xsl:param name="id" tunnel="yes"/>
        <xsl:attribute name="id" select="$id"/>
    </xsl:template>
    
    <xsl:template match="head/title" mode="html">
        <xsl:param name="doc" tunnel="yes"/>
        <xsl:copy>
            <xsl:value-of select="jt:getTitle($doc)"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="nav" mode="html">
        <xsl:param name="doc" tunnel="yes"/>
        <xsl:copy>
            <xsl:for-each select="$data">
                <xsl:sort order="ascending">
                    <xsl:variable name="id" select="//tei:TEI/@xml:id"/>
                    <xsl:choose>
                        <xsl:when test="$id = 'index'">
                            <xsl:sequence select="0"/>
                        </xsl:when>
                        <xsl:when test="$id = 'resources'">
                            <xsl:sequence select="99"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:sequence select="replace($id,'[^\d]','') => xs:integer()"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:sort>
                <xsl:variable name="id" select="//tei:TEI/@xml:id" as="xs:string"/>
                <a href="{$id}.html">
                    <xsl:if test="$doc//tei:TEI/@xml:id = $id">
                        <xsl:attribute name="aria-current" select="'page'"/>
                    </xsl:if>
                    <xsl:value-of select="jt:getTitle(.)"/>
                </a>
            </xsl:for-each>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="main/hgroup/h1" mode="html">
        <xsl:param name="doc" tunnel="yes"/>
        <xsl:copy>
            <xsl:sequence select="jt:getTitle($doc)"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="main/hgroup/h2" mode="html">
        <xsl:param name="doc" tunnel="yes"/>
        <xsl:where-populated>
            <xsl:copy>
                <xsl:sequence select="jt:getDay($doc)"/>
            </xsl:copy>
        </xsl:where-populated>
    </xsl:template>
    
    <xsl:template match="main/article" mode="html">
        <xsl:param name="doc" tunnel="yes"/>
        <xsl:copy>
            <xsl:apply-templates select="$doc" mode="tei"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="time[@id='build-time']" mode="html">
        <xsl:copy>
            <xsl:value-of select="current-dateTime()"/>
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>