<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:o="http://schemas.openehr.org/v1" version="1.0">
	<xsl:output method="xml" indent="yes"/>
	<xsl:template match="*[@xsi:type = 'SECTION']">
		<section>
			<xsl:call-template name="parseParamName">
				<xsl:with-param name="value" select="."/>
			</xsl:call-template>
			<xsl:apply-templates/>
		</section>
	</xsl:template>
	<xsl:template match="*[@xsi:type = 'OBSERVATION' or @xsi:type = 'EVALUATION'  or @xsi:type  = 'INSTRUCTION' or @xsi:type = 'ACTION' or @xsi:type = 'ADMIN_ENTRY']">
		<xsl:variable name="archetypeId">
			<xsl:value-of select="./o:archetype_details/o:archetype_id/o:value"/>
		</xsl:variable>
		<xsl:variable name="elementName">
<xsl:value-of select="./o:name/o:value"	/>
		</xsl:variable>
		<xsl:element name="{translate($elementName,'  ', '')}">
		<xsl:attribute name="nodeId">
		<xsl:value-of select="$archetypeId"/>
		</xsl:attribute>
		
			<xsl:apply-templates/>
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
		<xsl:apply-templates/>
	</xsl:template>
	<xsl:template match="o:origin">
		<origin>
<xsl:value-of select="./o:value"		/>
		</origin>

		<xsl:apply-templates/>
	</xsl:template>
	<xsl:template match="*[@xsi:type= 'CLUSTER']">
        <xsl:variable name="pos" select="count(ancestor::o:items[@xsi:type = 'CLUSTER'])"/>
        <xsl:variable name="nodeId">
<xsl:value-of select="@archetype_node_id"        />
        </xsl:variable>
        <xsl:variable name="elementName">
<xsl:value-of select="./o:name/o:value"	/>
		</xsl:variable>
<!--    
<xsl:element name="CLUSTER">
-->
             <xsl:element name="CLUSTER_{translate($nodeId,'.', '_')}"> 
<xsl:attribute name="rmType">
<xsl:value-of select="'CLUSTER'"/>
</xsl:attribute>        

						<xsl:apply-templates/>
        </xsl:element>

	</xsl:template>
	<xsl:template match="*[@xsi:type = 'ELEMENT']">
	<xsl:variable name="nodeId">
<xsl:value-of select="@archetype_node_id"        />
        </xsl:variable>
        <xsl:element name="ELEMENT_{translate($nodeId,'.', '_')}"> 
        		<xsl:choose>
					<xsl:when test="o:value/@xsi:type = 'DV_QUANTITY'">
						<xsl:value-of select="o:value/o:magnitude"/>
						<xsl:value-of select="' '"/>
						<xsl:value-of select="o:value/o:units"/>
					</xsl:when>
					<xsl:when test="o:value/@xsi:type = 'DV_TEXT'">
						<xsl:value-of select="o:value"/>
					</xsl:when>
					<xsl:when test="o:value/@xsi:type = 'DV_CODED_TEXT'">
						<xsl:value-of select="o:value/o:value"/>
					</xsl:when>
					<xsl:when test="o:value/@xsi:type = 'DV_BOOLEAN'">
						<xsl:apply-templates select="o:value" mode="boolean"/>
					</xsl:when>
					<xsl:when test="o:value/@xsi:type = 'DV_DATE'">
						<xsl:apply-templates select="o:value" mode="date"/>
					</xsl:when>
					<xsl:when test="o:value/@xsi:type = 'DV_DATE_TIME'">
						<xsl:apply-templates select="o:value" mode="datetime"/>
					</xsl:when>
					<xsl:when test="o:value/@xsi:type = 'DV_PROPORTION'">
						<!-- http://openehr.org/releases/1.0.2/architecture/rm/data_types_im.pdf -->
						<xsl:variable name="kind" select="o:value/o:type"/>
						<xsl:choose>
							<xsl:when test="$kind = 1">
								<xsl:value-of select="o:value/o:numerator"/>
								<xsl:value-of select="'%'"/>
							</xsl:when>
							<xsl:when test="$kind = 2">
								<xsl:value-of select="o:value/o:numerator"/>
								<xsl:value-of select="'%'"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="o:value/o:numerator"/>
								<xsl:value-of select="'/'"/>
								<xsl:value-of select="o:value/o:denominator"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:when test="o:value/@xsi:type = 'DV_ORDINAL'">
						<xsl:comment>
							<xsl:value-of select="o:value/o:value"/>
						</xsl:comment>
						<xsl:value-of select="o:value/o:symbol/o:value"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="o:value"/>
					</xsl:otherwise>
				</xsl:choose>
        </xsl:element>
		
		
	</xsl:template>
	<xsl:template match="o:value" mode="boolean">
		<xsl:choose>
			<xsl:when test="o:value = 'true'">
				<span class="glyphicon glyphicon-check" aria-hidden="true"/>
			</xsl:when>
			<xsl:when test="o:value = 'false' ">
				<span class="glyphicon glyphicon-unchecked" aria-hidden="true"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:comment>Ingen boolean</xsl:comment>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="o:value" mode="date">
		<xsl:call-template name="parseDate">
			<xsl:with-param name="dateTimeValue" select="o:value"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="o:value" mode="datetime">
		<xsl:call-template name="parseDateTime">
			<xsl:with-param name="dateTimeValue" select="o:value"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="o:context">
		<xsl:call-template name="parseDateTime">
			<xsl:with-param name="dateTimeValue">
				<xsl:value-of select="o:start_time/o:value"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="o:time" mode="datetime">
		<xsl:call-template name="parseDateTime">
			<xsl:with-param name="dateTimeValue" select="o:value"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="o:expiry_time" mode="datetime">
		<xsl:call-template name="parseDateTime">
			<xsl:with-param name="dateTimeValue" select="o:value"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template name="parseDate">
		<xsl:param name="dateTimeValue"/>
		<xsl:variable name="dt" select="$dateTimeValue"/>
		<xsl:variable name="year" select="substring($dt,1,4)"/>
		<xsl:variable name="month" select="substring($dt,6,2)"/>
		<xsl:variable name="day" select="substring($dt,9,2)"/>
		<xsl:value-of select="concat($day,'.',$month,'.',$year)"/>
	</xsl:template>
	<xsl:template name="parseDateTime">
		<xsl:param name="dateTimeValue"/>
		<xsl:variable name="dt" select="$dateTimeValue"/>
		<xsl:variable name="year" select="substring($dt,1,4)"/>
		<xsl:variable name="month" select="substring($dt,6,2)"/>
		<xsl:variable name="day" select="substring($dt,9,2)"/>
		<xsl:variable name="hour" select="substring($dt,12,2)"/>
		<xsl:variable name="minute" select="substring($dt,15,2)"/>
		<xsl:value-of select="concat($day,'.',$month,'.',$year, ' ',  $hour,':',$minute)"/>
	</xsl:template>
	<!-- Override of default transformation for text nodes and attributes -->
	<xsl:template match="text() | @*"/>
	<xsl:template name="paramNameToAttribute">
		<xsl:param name="value"/>
		<xsl:variable name="paramName" select="$value/o:name/o:value"/>
		<xsl:attribute name="name"><xsl:choose><xsl:when test="string-length(substring-before($paramName,'_'))&gt;0"><xsl:value-of select="substring-before($paramName,'_')"/></xsl:when><xsl:when test="string-length(substring-before($paramName,'#'))&gt;0"><xsl:value-of select="substring-before($paramName,'#')"/></xsl:when><xsl:otherwise><xsl:value-of select="$paramName"/></xsl:otherwise></xsl:choose></xsl:attribute>
	</xsl:template>
	<xsl:template name="parseParamName">
		<xsl:param name="value"/>
		<xsl:variable name="paramName" select="$value/o:name/o:value"/>
		<xsl:choose>
			<xsl:when test="string-length(substring-before($paramName,'_'))&gt;0">
				<xsl:value-of select="substring-before($paramName,'_')"/>
			</xsl:when>
			<xsl:when test="string-length(substring-before($paramName,'#'))&gt;0">
				<xsl:value-of select="substring-before($paramName,'#')"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$paramName"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="/">
		<message>
			<xsl:attribute name="name"><xsl:value-of select="o:composition/o:name/o:value"/></xsl:attribute>
			<xsl:attribute name="time"><xsl:apply-templates select="o:composition/o:context"/></xsl:attribute>
			<xsl:apply-templates select="o:composition/o:content"/>
		</message>
	</xsl:template>
</xsl:stylesheet>
