<?xml version="1.0" encoding="Shift_JIS"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/TR/WD-xsl" xml:lang="ja">
<xsl:template match="/">
<html lang="ja">
<head>
<title><xsl:value-of select="�S��/�薼" /></title>
</head>
<body><xsl:apply-templates select="�S��/�{��" /></body>
</html>
</xsl:template>
<xsl:template match="�S��/�{��">
	<xsl:for-each select="�����N">
		<xsl:element name="a">
		<xsl:attribute name="href">
			<xsl:value-of select="�����N��/@url" />
		</xsl:attribute>
			<xsl:value-of select="�����N��" /><br />
		</xsl:element>
	</xsl:for-each>
</xsl:template>
</xsl:stylesheet>
