<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    exclude-result-prefixes="#all"
    xmlns:xh="http://www.w3.org/1999/xhtml"
    xmlns="http://www.w3.org/1999/xhtml"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:jt="https://github.com/joeytakeda"
    version="3.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> May 5, 2023</xd:p>
            <xd:p><xd:b>Author:</xd:b> takeda</xd:p>
            <xd:p></xd:p>
        </xd:desc>
    </xd:doc>
    
    <xsl:mode name="tei" on-no-match="text-only-copy"/>
    
    <xsl:template match="/ | TEI | text" mode="tei">
        <xsl:apply-templates mode="#current"/>
    </xsl:template>
    
    <xsl:template match="teiHeader" mode="tei"/>
    
    <xsl:template match="body" mode="tei">
        <xsl:apply-templates mode="#current"/>
    </xsl:template>
    
    <!--This is already handled-->
    <xsl:template match="listEvent/event" priority="2" mode="tei">
        <xsl:apply-templates mode="#current"/>
    </xsl:template>
    
    <xsl:template match="listEvent/event/label" priority="2" mode="tei"/>

    <xsl:template match="event[event]" mode="tei">
        <section id="{ancestor::TEI/@xml:id || '_' || @type}">
            <xsl:apply-templates select="label" mode="#current"/>
            <div class="schedule">
                <xsl:apply-templates select="event" mode="#current"/>
            </div>
            <xsl:apply-templates select="linkGrp" mode="#current"/>
        </section>
    </xsl:template>
    
    <xsl:template match="event[event]/label" mode="tei">
        <h3><xsl:value-of select="jt:capitalize(../@type)"/>: <xsl:apply-templates mode="#current"/></h3>
    </xsl:template>
    
    
    <xsl:template match="event[@start and @end]/label" mode="tei">
        <div>
            <span class="label"><xsl:value-of select="."/></span>
        </div>
    </xsl:template>
    
    <xsl:template match="event[@start and @end]" mode="tei">
        <div>
            <h4>
                <xsl:apply-templates select="@start | @end" mode="#current"/>
            </h4>
            <xsl:apply-templates mode="#current"/>
        </div>
    </xsl:template>
    
    <xsl:template match="event/@start | event/@end" mode="tei">
        <time datetime="{.}"><xsl:value-of select="."/></time>
    </xsl:template>
    
    <xsl:template match="ab" mode="tei">
        <xsl:apply-templates mode="#current"/>
    </xsl:template>
    
    
    <xsl:template match="p" mode="tei">
        <p>
            <xsl:apply-templates mode="#current"/>
        </p>
    </xsl:template>
    
    <xsl:template match="list" mode="tei">
        <div role="list">
            <xsl:apply-templates mode="#current"/>
        </div>
    </xsl:template>
    
    <xsl:template match="item" mode="tei">
        <div role="listitem">
            <xsl:apply-templates mode="#current"/>
        </div>
    </xsl:template>
    
    <xsl:template match="ref" mode="tei">
        <a>
            <xsl:apply-templates select="@*|node()" mode="#current"/>
        </a>
    </xsl:template>
    
    <xsl:template match="ref/@target" mode="tei">
        <xsl:attribute name="href" select="."/>
    </xsl:template>
    
    <xsl:template match="ref/@type" mode="tei">
        <xsl:attribute name="data-type" select="."/>
    </xsl:template>
    
    
    <xsl:template match="linkGrp" mode="tei"> 
        <details open="open">
            <summary>Further Reading</summary>
            <div class="bibliography" role="list">
                <xsl:apply-templates mode="#current"/>
            </div>
        </details>
    </xsl:template>
    
  
    
    <xsl:template match="linkGrp/ptr" mode="tei">
        <xsl:variable name="ID" select="substring-after(@target,'bibl:')"/>
        <xsl:variable name="bibl" select="$data//bibl[@xml:id = $ID]"/>
        <xsl:apply-templates select="$bibl" mode="#current"/>
    </xsl:template>
    
    <xsl:template match="ptr" mode="tei">
        <a href="{@target}"><xsl:value-of select="@target"/></a>
    </xsl:template>
    
    <xsl:template match="listBibl" mode="tei">
        <section class="bibliography" role="list">
            <xsl:apply-templates mode="#current"/>
        </section>
    </xsl:template>
    
    <xsl:template match="listBibl/head" mode="tei">
        <h3>
            <xsl:apply-templates mode="#current"/>
        </h3>
    </xsl:template>
    
    <xsl:template match="bibl" mode="tei">
        <p class="bibl" role="listitem" id="{@xml:id}">
            <xsl:apply-templates mode="#current"/>
        </p>
    </xsl:template>
    
    <xsl:template match="bibl/title" mode="tei">
        <span class="title title-{@level}">
            <xsl:apply-templates mode="#current"/>
        </span>
    </xsl:template>
    
    <xsl:template match="bibl/text()" mode="tei">
        <xsl:choose>
            <xsl:when test="not(preceding-sibling::node()[1]/self::title)">
                <xsl:next-match/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:analyze-string select="." regex="^[\.,]">
                    <xsl:matching-substring>
                        <span class="pcterm"><xsl:value-of select="."/></span>
                    </xsl:matching-substring>
                    <xsl:non-matching-substring>
                        <xsl:value-of select="."/>
                    </xsl:non-matching-substring>
                </xsl:analyze-string>
            </xsl:otherwise>
        </xsl:choose>
        
    </xsl:template>
    
    <xsl:function name="jt:getTitle" as="item()*">
        <xsl:param name="doc" as="document-node()"/>
        <xsl:sequence select="string($doc//titleStmt/title[1])"/>
    </xsl:function>
    
    <xsl:function name="jt:capitalize" as="xs:string">
        <xsl:param name="str" as="xs:string"/>
        <xsl:value-of select="upper-case(substring($str, 1, 1)) || substring($str, 2)"/>
    </xsl:function>
    
    <xsl:function name="jt:getDay" as="item()*">
        <xsl:param name="doc" as="document-node()"/>
        <xsl:variable name="event" 
            select="$doc//listEvent/event[@when]" as="element(event)?"/>
        <xsl:if test="$event">
            <xsl:sequence select="format-date($event/@when, '[MNn] [D01]')"/>
        </xsl:if>
    </xsl:function>
    
</xsl:stylesheet>