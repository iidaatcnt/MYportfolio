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
				<h1><xsl:value-of select="���o��" /></h1>
			<xsl:for-each select="�i��">
				<p><xsl:value-of /></p>
			</xsl:for-each>
		</xsl:template>
</xsl:stylesheet>
