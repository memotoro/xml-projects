<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema">

    <!--
       <Author>
           <Name>Guillermo Antonio</Name>  
           <LastName>Toro Bayona</LastName>
           <ID_Student>8567391</ID_Student        
       </Author>
       <Course_Unit>
           <Course>COMP60411</Course>
       </Course_Unit>
    
    My XSLT transformation for DTDx   
    This file contains the XSLT transformation to take a DTDx documents and create with 
    the information provided in these files, a WXS useful for validation.
    -->

    <!-- 
        Output method with XML value and Indentation. 
    -->
    <xsl:output method="xml" indent="yes"/>

    <!-- 
        Template for Root element 'dtdx'.        
    -->
    <xsl:template match="dtdx" name="rootRule">

        <!-- 
            Declare a new 'element' for 'xs:schema'.
            Create the 'xs:schema' element with its namespace and other attributes.
        -->
        <xsl:element name="xs:schema" namespace="http://www.w3.org/2001/XMLSchema">
            <xsl:attribute name="elementFormDefault">unqualified</xsl:attribute>

            <!-- 
                Apply templates for element, attlist or comment. 
            -->
            <xsl:apply-templates select="(element | attlist | comment)"/>
        </xsl:element>
    </xsl:template>

    <!-- 
        Template for 'element'.
    -->
    <xsl:template match="element" name="elementRule">

        <!-- 
            Create variables to get the name of the element and use it later in expressions.
        -->
        <xsl:variable name="elementName" select="@name"/>

        <!-- 
            Create element and attribute with element name.
        -->
        <xsl:element name="xs:element">
            <xsl:attribute name="name">
                <xsl:value-of select="$elementName"/>
            </xsl:attribute>

            <xsl:choose>

                <!-- 
                    Validate if the text hast 'empty', 'any' or 'mixed; elements as a children.                
                -->
                <xsl:when test="(empty | any | mixed)">

                    <!-- 
                        Create the complex Type element and add attributes depent of the template.
                    -->
                    <xsl:element name="xs:complexType">
                        <xsl:apply-templates select="empty | any | mixed"/>

                        <!-- 
                            Validation to look if the element has other declarations in the document
                            related with attributes.  
                        -->
                        <xsl:if test="/dtdx/attlist[@on = $elementName]">

                            <!--
                                Call the template for 'attlist' called 'attributeRules' 
                                and pass the element name as a parameter.
                            -->
                            <xsl:call-template name="attributeRule">
                                <xsl:with-param name="elementName" select="$elementName"/>
                            </xsl:call-template>
                        </xsl:if>

                    </xsl:element>
                </xsl:when>
                <xsl:otherwise>

                    <!-- 
                        Apply template for children elements.
                    -->
                    <xsl:element name="xs:complexType">

                        <!-- 
                           Always create the children elements inside a xs:sequence element.
                        -->
                        <xsl:element name="xs:sequence">
                            <xsl:apply-templates/>
                        </xsl:element>

                        <!--
                            Call the template for 'attlist' called 'attributeRules' 
                            and pass the element name as a parameter.
                        -->
                        <xsl:if test="/dtdx/attlist[@on = $elementName]">

                            <!--
                                Call the template for 'attlist' called 'attributeRules' 
                                and pass the element name as a parameter.
                            -->
                            <xsl:call-template name="attributeRule">
                                <xsl:with-param name="elementName" select="$elementName"/>
                            </xsl:call-template>
                        </xsl:if>
                    </xsl:element>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:element>
    </xsl:template>

    <!-- 
        Empty element.
    -->
    <xsl:template match="empty" name="emptyRule">
        <xsl:apply-templates/>
    </xsl:template>

    <!-- 
        Any element.
    -->
    <xsl:template match="any" name="anyRule">

        <!-- 
            Create and extension element with base attribute 'anyType'
        -->
        <xsl:element name="xs:sequence">
            <xsl:element name="xs:any" use-attribute-sets="starAttSet"> </xsl:element>
        </xsl:element>
    </xsl:template>


    <!-- 
        Element with mixed content.
    -->
    <xsl:template match="mixed" name="mixedRule">

        <!--
            Property for mixed content as true.
        -->
        <xsl:attribute name="mixed">
            <xsl:value-of select="'true'"/>
        </xsl:attribute>
    </xsl:template>

    <!-- 
        Attribute set for 'star' repetition.
    -->
    <xsl:attribute-set name="starAttSet">
        <xsl:attribute name="minOccurs">
            <xsl:value-of select="'0'"/>
        </xsl:attribute>
        <xsl:attribute name="maxOccurs">
            <xsl:value-of select="'unbounded'"/>
        </xsl:attribute>
    </xsl:attribute-set>

    <!-- 
        Attribute set for 'plus' repetition.
    -->
    <xsl:attribute-set name="plusAttSet">
        <xsl:attribute name="minOccurs">
            <xsl:value-of select="'1'"/>
        </xsl:attribute>
        <xsl:attribute name="maxOccurs">
            <xsl:value-of select="'unbounded'"/>
        </xsl:attribute>
    </xsl:attribute-set>

    <!-- 
        Attribute set for 'opt' repetition.
    -->
    <xsl:attribute-set name="optAttSet">
        <xsl:attribute name="minOccurs">
            <xsl:value-of select="'0'"/>
        </xsl:attribute>
        <xsl:attribute name="maxOccurs">
            <xsl:value-of select="'1'"/>
        </xsl:attribute>
    </xsl:attribute-set>

    <!-- 
        Template for 'ref' element.
    -->
    <xsl:template match="ref" name="refRules">

        <!-- 
            Create an element with 'ref' attribute.
        -->
        <xsl:choose>

            <!-- 
                Validate if the parent element is plus to apply the appropriate rules of occurrences. 
            -->
            <xsl:when test="local-name(parent::node()) = 'plus'">
                <xsl:element name="xs:element" use-attribute-sets="plusAttSet">
                    <xsl:attribute name="ref">
                        <xsl:value-of select="@to"/>
                    </xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>

            <!-- 
                Validate if the parent element is star to apply the appropriate rules of occurrences. 
            -->
            <xsl:when test="local-name(parent::node()) = 'star'">
                <xsl:element name="xs:element" use-attribute-sets="starAttSet">
                    <xsl:attribute name="ref">
                        <xsl:value-of select="@to"/>
                    </xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>

            <!-- 
                Validate if the parent element is plus to apply the appropriate rules of occurrences. 
            -->
            <xsl:when test="local-name(parent::node()) = 'opt'">
                <xsl:element name="xs:element" use-attribute-sets="optAttSet">
                    <xsl:attribute name="ref">
                        <xsl:value-of select="@to"/>
                    </xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>

            <!-- 
                Create an element with 'ref' properties.
            -->
            <xsl:otherwise>
                <xsl:element name="xs:element">
                    <xsl:attribute name="ref">
                        <xsl:value-of select="@to"/>
                    </xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- 
        Template for 'choice' element.
        Create 'xs:choice' element.
    -->
    <xsl:template match="choice" name="choiceRule">
        <xsl:choose>

            <!-- 
                Validate if the parent element is plus to apply the appropriate rules of occurrences. 
            -->
            <xsl:when test="local-name(parent::node()) = 'plus'">
                <xsl:element name="xs:choice" use-attribute-sets="plusAttSet">
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>

            <!-- 
                Validate if the parent element is star to apply the appropriate rules of occurrences. 
            -->
            <xsl:when test="local-name(parent::node()) = 'star'">
                <xsl:element name="xs:choice" use-attribute-sets="starAttSet">
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>

            <!-- 
                Validate if the parent element is opt to apply the appropriate rules of occurrences. 
            -->
            <xsl:when test="local-name(parent::node()) = 'opt'">
                <xsl:element name="xs:choice" use-attribute-sets="optAttSet">
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>

            <!-- 
                Create 'choice' element. 
            -->
            <xsl:otherwise>
                <xsl:element name="xs:choice">
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- 
        Template for 'seq' element.
        Create 'xs:sequence' element.
    -->
    <xsl:template match="seq" name="seqRule">
        <xsl:choose>

            <!-- 
                Validate if the parent element is plus to apply the appropriate rules of occurrences. 
            -->
            <xsl:when test="local-name(parent::node()) = 'plus'">
                <xsl:element name="xs:sequence" use-attribute-sets="plusAttSet">
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>

            <!-- 
                Validate if the parent element is star to apply the appropriate rules of occurrences. 
            -->
            <xsl:when test="local-name(parent::node()) = 'star'">
                <xsl:element name="xs:sequence" use-attribute-sets="starAttSet">
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>

            <!-- 
                Validate if the parent element is opt to apply the appropriate rules of occurrences. 
            -->
            <xsl:when test="local-name(parent::node()) = 'opt'">
                <xsl:element name="xs:sequence" use-attribute-sets="optAttSet">
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>

            <!-- 
                Create a 'sequence' element 
            -->
            <xsl:otherwise>
                <xsl:element name="xs:sequence">
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- 
        Template for 'attlist' element.
    -->
    <xsl:template match="attlist" name="attributeRule">

        <!-- 
            Parameter with the name of the element.
        -->
        <xsl:param name="elementName"/>

        <!-- 
            Call the template for 'attdef' only for the node selected with the name 
            received as a parameter.            
        -->
        <xsl:apply-templates select="/dtdx/attlist[@on = $elementName]/attdef"/>
    </xsl:template>

    <!-- 
        Template for 'attdef'
        Launch the template for string, tokenized, enumeration or  notation elements.            
    -->
    <xsl:template match="attdef" name="attributeDefRule">
        <xsl:apply-templates select="string | tokenized | enumeration | notation "/>
    </xsl:template>

    <!-- 
        Template for 'string' element. 
    -->
    <xsl:template match="string" name="stringRule">

        <!-- 
            Create an element with attribute type 'xs:string'. 
        -->
        <xsl:element name="xs:attribute">
            <xsl:attribute name="name">
                <xsl:value-of select="parent::node()/@name"/>
            </xsl:attribute>
            <xsl:attribute name="type">
                <xsl:value-of select="'xs:string'"/>
            </xsl:attribute>
            <xsl:apply-templates select="(../required | ../implied | ../default)"/>
        </xsl:element>
    </xsl:template>

    <!-- 
        Template for 'tokenized'. 
    -->
    <xsl:template match="tokenized" name="tokenizedRule">

        <!-- 
            Create an element with attribute type 'xs:' plus the type specified in the token value. 
        -->
        <xsl:element name="xs:attribute">
            <xsl:attribute name="name">
                <xsl:value-of select="parent::node()/@name"/>
            </xsl:attribute>
            <xsl:attribute name="type">
                <xsl:value-of select="concat('xs:',@type)"/>
            </xsl:attribute>
            <xsl:apply-templates select="(../required | ../implied | ../default)"/>
        </xsl:element>
    </xsl:template>

    <!-- 
        Template for 'enumeration'  
    -->
    <xsl:template match="enumeration" name="enumerationRule">

        <xsl:element name="xs:attribute">
            <xsl:attribute name="name">
                <xsl:value-of select="parent::node()/@name"/>
            </xsl:attribute>
            <xsl:apply-templates select="(../required | ../implied | ../default)"/>
            <!-- 
                Create an element with enumeration elements based on MTOKEN. 
            -->
            <xsl:element name="xs:simpleType">
                <xsl:element name="xs:restriction">
                    <xsl:attribute name="base">
                        <xsl:value-of select="'xs:NMTOKEN'"/>
                    </xsl:attribute>
                    <xsl:apply-templates select="nmtoken"/>
                </xsl:element>
            </xsl:element>
        </xsl:element>
    </xsl:template>

    <!-- 
        Template for 'notation' element.
    -->
    <xsl:template match="notation" name="notationRule">

        <xsl:element name="xs:attribute">
            <xsl:attribute name="name">
                <xsl:value-of select="parent::node()/@name"/>
            </xsl:attribute>
            <xsl:apply-templates select="(../required | ../implied | ../default)"/>
            <!-- 
                Create an element with enumeration elements based on MTOKEN. 
            -->
            <xsl:element name="xs:simpleType">
                <xsl:element name="xs:restriction">
                    <xsl:attribute name="base">
                        <xsl:value-of select="'xs:NMTOKEN'"/>
                    </xsl:attribute>
                    <xsl:apply-templates select="nmtoken"/>
                </xsl:element>
            </xsl:element>
        </xsl:element>
    </xsl:template>

    <!-- 
        Template for 'nmtoken' 
    -->
    <xsl:template match="nmtoken" name="nmtokenRule">

        <!-- 
            Create the enumeration list with different values read in the source tree. 
        -->
        <xsl:element name="xs:enumeration">
            <xsl:attribute name="value">
                <xsl:apply-templates select="@value"/>
            </xsl:attribute>
        </xsl:element>
    </xsl:template>

    <!-- 
        Template for 'required' element for attributes 
    -->
    <xsl:template match="required" name="requiredRule">
        <xsl:attribute name="use">
            <xsl:value-of select="'required'"/>
        </xsl:attribute>
    </xsl:template>

    <!-- 
        Template for 'implied' element for attributes 
    -->
    <xsl:template match="implied" name="impliedRule">
        <xsl:attribute name="use">
            <xsl:value-of select="'optional'"/>
        </xsl:attribute>
    </xsl:template>

    <!-- 
        Template for 'default' element for attributes 
    -->
    <xsl:template match="default" name="defaultRule">

        <xsl:choose>

            <!-- 
                If the value is fixed, create an attribute with fixed value. 
            -->
            <xsl:when test="(@fixed = 'true()')">

                <!-- 
                    Declare an attribute for fixed value. 
                -->
                <xsl:attribute name="fixed">
                    <xsl:value-of select="@value"/>
                </xsl:attribute>
            </xsl:when>

            <!-- 
                If the value is not fixed, create an attribute with default value. 
            -->
            <xsl:otherwise>
                
                <!-- 
                    Declare an attribute for default value. 
                -->
                <xsl:attribute name="default">
                    <xsl:value-of select="@value"/>
                </xsl:attribute>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>

    <!-- 
        Template for 'comment' element for attributes 
    -->
    <xsl:template match="comment" name="commentRule">
        <!-- 
            Create an element 'xs:annotation' to take the coments and store it in 
            annotation element for xs:schema.
        -->
        <xsl:element name="xs:annotation">
            <xsl:element name="xs:appinfo">
                <xsl:value-of select="'DefaultAppInfo'"/>
            </xsl:element>
            <xsl:element name="xs:documentation">

                <!-- 
                    Language english by default. 
                -->
                <xsl:attribute name="xml:lang">
                    <xsl:value-of select="'en'"/>
                </xsl:attribute>
                <xsl:value-of select="text()"/>
            </xsl:element>
        </xsl:element>
    </xsl:template>

</xsl:stylesheet>
