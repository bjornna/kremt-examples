<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:o="http://schemas.openehr.org/v1" version="1.0">
	<xsl:output method="xml" encoding="UTF-8" indent="yes" />
	<xsl:template match="*[@xsi:type = 'SECTION']">
		<section>
			<xsl:call-template name="parseParamName">
				<xsl:with-param name="value" select="." />
			</xsl:call-template>
			<xsl:apply-templates />
		</section>
	</xsl:template>
	<xsl:template match="*[@xsi:type = 'OBSERVATION' or @xsi:type = 'EVALUATION'  or @xsi:type  = 'INSTRUCTION' or @xsi:type = 'ACTION' or @xsi:type = 'ADMIN_ENTRY']">
		<xsl:variable name="nodeId">
			<xsl:value-of select="./o:archetype_details/o:archetype_id/o:value" />
		</xsl:variable>
		<xsl:variable name="rmType">
			<xsl:value-of select="./@xsi:type"></xsl:value-of>
		</xsl:variable>
		<xsl:variable name="elementName">
			<!--
				<xsl:value-of select="./o:name/o:value" />
					
			-->
			<xsl:value-of select="./o:archetype_details/o:archetype_id/o:value" />

		</xsl:variable>


		<xsl:element name="{translate($elementName,'.', '_')}">
			<xsl:attribute name="nodeId">
				<xsl:value-of select="$nodeId" />
			</xsl:attribute>
			<xsl:attribute name="rmType">
				<xsl:value-of select="$rmType" />
			</xsl:attribute>

			<xsl:apply-templates />
		</xsl:element>
	</xsl:template>
	<xsl:template match="o:ism_transition">
		<!-- 
NOT USED 
		<p>
			<xsl:value-of select="o:current_state/o:value"/>
			<xsl:text>:</xsl:text>
			<xsl:value-of select="o:careflow_step/o:value"/>
		</p>
-->
	</xsl:template>
	<xsl:template match="o:events[@xsi:type = 'POINT_EVENT']">
		<!-- Point Event : Origin show time -->
		<!--

        <div class="row">
            <div class="col-md-3">
                Point event
            </div>
            <div class="col-md-9">
                <xsl:apply-templates select="./o:time" mode="datetime"/>
            </div>
        </div>
        -->
		<xsl:apply-templates />
	</xsl:template>
	<xsl:template match="o:origin">
		<origin>
			<xsl:value-of select="./o:value" />
		</origin>

		<xsl:apply-templates />
	</xsl:template>
	<xsl:template match="*[@xsi:type= 'CLUSTER']">
		<!--
			<xsl:variable name="pos" select="count(ancestor::o:items[@xsi:type = 'CLUSTER'])" />
		-->
		<xsl:variable name="nodeId">
			<xsl:value-of select="@archetype_node_id" />
		</xsl:variable>
		<xsl:variable name="rmName">
			<xsl:value-of select="./o:name/o:value" />

		</xsl:variable>

		<xsl:element name="{translate($nodeId,'.', '_')}">
			<xsl:attribute name="rmType">
				<xsl:value-of select="'CLUSTER'" />
			</xsl:attribute>
			<xsl:attribute name="rmName">
				<xsl:value-of select="$rmName" />
			</xsl:attribute>
			<xsl:apply-templates />
		</xsl:element>
	</xsl:template>
	<xsl:template match="*[@xsi:type = 'ELEMENT']">
		<xsl:variable name="nodeId">
			<xsl:value-of select="@archetype_node_id" />
		</xsl:variable>
		<xsl:variable name="rmName">
			<xsl:value-of select="./o:name/o:value" />
		</xsl:variable>
		<xsl:element name="{translate($nodeId,'.', '_')}">
			<xsl:attribute name="rmName">
				<xsl:value-of select="$rmName"></xsl:value-of>

			</xsl:attribute>
			<xsl:attribute name="rmType">
				<xsl:value-of select="'ELEMENT'" />
			</xsl:attribute>
			<xsl:copy-of select="./o:value" />
		</xsl:element>


	</xsl:template>

	<xsl:template match="o:value" mode="date">
		<xsl:call-template name="parseDate">
			<xsl:with-param name="dateTimeValue" select="o:value" />
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="o:value" mode="datetime">
		<xsl:call-template name="parseDateTime">
			<xsl:with-param name="dateTimeValue" select="o:value" />
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="o:context">
		<xsl:call-template name="parseDateTime">
			<xsl:with-param name="dateTimeValue">
				<xsl:value-of select="o:start_time/o:value" />
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="o:time" mode="datetime">
		<xsl:call-template name="parseDateTime">
			<xsl:with-param name="dateTimeValue" select="o:value" />
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="o:expiry_time" mode="datetime">
		<xsl:call-template name="parseDateTime">
			<xsl:with-param name="dateTimeValue" select="o:value" />
		</xsl:call-template>
	</xsl:template>
	<xsl:template name="parseDate">
		<xsl:param name="dateTimeValue" />
		<xsl:variable name="dt" select="$dateTimeValue" />
		<xsl:variable name="year" select="substring($dt,1,4)" />
		<xsl:variable name="month" select="substring($dt,6,2)" />
		<xsl:variable name="day" select="substring($dt,9,2)" />
		<xsl:value-of select="concat($day,'.',$month,'.',$year)" />
	</xsl:template>
	<xsl:template name="parseDateTime">
		<xsl:param name="dateTimeValue" />
		<xsl:variable name="dt" select="$dateTimeValue" />
		<xsl:variable name="year" select="substring($dt,1,4)" />
		<xsl:variable name="month" select="substring($dt,6,2)" />
		<xsl:variable name="day" select="substring($dt,9,2)" />
		<xsl:variable name="hour" select="substring($dt,12,2)" />
		<xsl:variable name="minute" select="substring($dt,15,2)" />
		<xsl:value-of select="concat($day,'.',$month,'.',$year, ' ',  $hour,':',$minute)" />
	</xsl:template>
	<!-- Override of default transformation for text nodes and attributes -->
	<xsl:template match="text() | @*" />
	<xsl:template name="paramNameToAttribute">
		<xsl:param name="value" />
		<xsl:variable name="paramName" select="$value/o:name/o:value" />
		<xsl:attribute name="name">
			<xsl:choose>
				<xsl:when test="string-length(substring-before($paramName,'_'))&gt;0">
					<xsl:value-of select="substring-before($paramName,'_')" />
				</xsl:when>
				<xsl:when test="string-length(substring-before($paramName,'#'))&gt;0">
					<xsl:value-of select="substring-before($paramName,'#')" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$paramName" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
	</xsl:template>
	<xsl:template name="parseParamName">
		<xsl:param name="value" />
		<xsl:variable name="paramName" select="$value/o:name/o:value" />
		<xsl:choose>
			<xsl:when test="string-length(substring-before($paramName,'_'))&gt;0">
				<xsl:value-of select="substring-before($paramName,'_')" />
			</xsl:when>
			<xsl:when test="string-length(substring-before($paramName,'#'))&gt;0">
				<xsl:value-of select="substring-before($paramName,'#')" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$paramName" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="/">
		<openehr_document>
		<metadata>
			<xsl:attribute name="name">
				<xsl:value-of select="o:composition/o:name/o:value" />
			</xsl:attribute>
			<xsl:attribute name="time">
				<xsl:apply-templates select="o:composition/o:context" />
			</xsl:attribute>
			<xsl:attribute name="documentId">
			<xsl:value-of select="o:composition/o:uid/o:value"/>
			</xsl:attribute>
			<xsl:attribute name="templateId">
			<xsl:value-of select="o:composition/o:archetype_details/o:template_id/o:value"/>
			</xsl:attribute>
			</metadata>
			<xsl:apply-templates select="o:composition/o:content" />
		</openehr_document>
	</xsl:template>
</xsl:stylesheet>
