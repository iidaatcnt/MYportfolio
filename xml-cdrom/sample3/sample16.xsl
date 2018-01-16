<?xml version="1.0" encoding="Shift_JIS"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/TR/WD-xsl" xml:lang="ja">
<xsl:template match="/">
<html lang="ja">
<head>
<title><xsl:value-of select="�S��/�薼" /></title>
</head>
<body><xsl:apply-templates select="�S��" /></body>
</html>
</xsl:template>
<xsl:template match="�S��">
	<xsl:for-each select="�}">
		<div>
		<span><xsl:value-of select="����" /></span>
		<img>
			<xsl:attribute name="src">
				<xsl:value-of select="�C���X�g" />
			</xsl:attribute>
			<xsl:attribute name="alt">
				<xsl:value-of select="����" />
			</xsl:attribute>
		</img>
		</div>
	</xsl:for-each>
</xsl:template>
</xsl:stylesheet>
