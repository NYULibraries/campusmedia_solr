<?xml version='1.0' encoding='UTF-8'?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output
    method="xml"
    indent="yes"
    encoding="utf-8"/>


<xsl:template match="/">
<xsl:element name="rooms">
<xsl:attribute name="count">
<xsl:value-of select="count(//result/doc)" />
</xsl:attribute>
 <xsl:apply-templates select="//result/doc" />
</xsl:element>
</xsl:template>

<xsl:template match="result/doc">
<xsl:element name="room">
<xsl:attribute name="id">
<xsl:value-of select="str[@name='guid']" />
</xsl:attribute>

<xsl:element name="title">
<xsl:value-of select="str[@name='dc.title']" />
</xsl:element>

<xsl:element name="image">
<xsl:value-of select="arr[@name='dc.coverage.spatial']" />
</xsl:element>

<xsl:element name="source">
<xsl:value-of select="arr[@name='dc.source']" />
</xsl:element>

<xsl:element name="audience">
<xsl:value-of select="arr[@name='dc.audience']" />
</xsl:element>

<xsl:for-each select="./arr[@name='dc.instructionalMethod']/str">
<xsl:element name="instructionalMethod">
<xsl:value-of select="." />
</xsl:element>
</xsl:for-each>

<xsl:for-each select="./arr[@name='dc.hasPart']/str">
<xsl:element name="hasPart">
<xsl:value-of select="." />
</xsl:element>
</xsl:for-each>

<xsl:for-each select="./arr[@name='dc.hasPart']/str">

<xsl:for-each select="document(concat('SOLR_URL_REPLACE?fq=dc.type:equipment&amp;fq=guid:',.))//result/doc/arr[@name='dc.format']/str">
<xsl:if test="not(.='') and . and not(preceding::node() = .)">

<xsl:element name="category">
<xsl:value-of select="." />
</xsl:element>
</xsl:if>
</xsl:for-each>

</xsl:for-each>


</xsl:element>
</xsl:template>

</xsl:stylesheet>
