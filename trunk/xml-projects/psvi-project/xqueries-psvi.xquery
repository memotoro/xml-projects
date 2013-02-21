(:
    Query to retrieve different elements depends of the xsd associated in the xml.
:)
import schema default element namespace "http://www.cs.manchester.ac.uk/pgt/COMP60411/m4" at "wxs2.xsd";
declare namespace man="http://www.cs.manchester.ac.uk/pgt/COMP60411/m4";

(:
(validate {doc("xml-xsd.xml")})//element(*,generalType)
(validate {doc("xml-xsd.xml")})//element(*,aType)
(validate {doc("xml-xsd.xml")})//element(*,bType)
:)

(:
    Query to retrieve different elements depends of the dtd associated in the xml.
:)
(:
doc("xml-dtd.xml")/a/b[@c]
doc("xml-dtd.xml")/a/b[@d]
doc("xml-dtd.xml")/a/b[fn:string-length(@c)>0]
doc("xml-dtd.xml")/a/b[fn:string-length(@d)>0]
:)