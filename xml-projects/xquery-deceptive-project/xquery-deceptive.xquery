(:
    <Author>
        <Name>Guillermo Antonio</Name>  
        <LastName>Toro Bayona</LastName>
        <ID_Student>8567391</ID_Student        
    </Author>
    <Course_Unit>
        <Course>COMP60411</Course>
    </Course_Unit>

    My XQuery for Deceptive Detection   
    This file contains the xquery functions to analyze a XML document and detect if it is Deceptive. 
:)

(: Declaration of namespace for this xquery and functions :)
declare default element namespace "http://www.cs.manchester.ac.uk/pgt/COMP60411/";
declare namespace man="http://www.cs.manchester.ac.uk/pgt/COMP60411/";

(: Declare a function to get the prefix in the document :)
declare function man:getPrefixesWithURIs($inputDocumentToAnalyze as document-node()) as element()* {
    (: Loop for every node in the document :)    
    for $node in $inputDocumentToAnalyze//*
        (: Get the prefixes in the scope without 'xml' prefix and order by prefix :)
        for $prefix in fn:in-scope-prefixes($node)
            where not($prefix = "xml")
            order by $prefix     
        (: Create new XML report with the prefiex and URIs for elements :)
        return 
            <man:report prefix="{$prefix}" uri="{fn:namespace-uri-for-prefix($prefix, $node)}"/>
};

(: Declare a function that receives and input document to analyze and look for problems :)
declare function man:lookForDeceptiveProblems($inputDocumentToAnalyze as document-node()) as element()*{
    (: Declare variable for input document with prefixes :)
    let $docWithPrefixesList := man:getPrefixesWithURIs($inputDocumentToAnalyze)
    (: Loop to traverse the document :)
    for $node1 in $docWithPrefixesList
        (: Loop to traverse the document :)
        for $node2 in $docWithPrefixesList
            (: Constraint for the same prefix and different URI :)
            where ( ($node1/@prefix=$node2/@prefix) and not($node1/@uri=$node2/@uri) )
        (: Create an XML report with problems about deceptive with prefix and URIs in problems :)        
        return               
        <man:problems>
            <man:prefix value="{$node2/@prefix}"/>
            <man:uris>
                <man:uri value="{$node1/@uri}"/>
                <man:uri value="{$node2/@uri}"/>
            </man:uris>
        </man:problems>
};

(: Declare function that receives a document to analyze and return a string with the analysis :)
declare function man:validateDeceptive($inputDocumentToAnalyze as document-node()) as xs:string {
    (: Count the elements in validateResponse :)
    let $nodesCount := count(man:lookForDeceptiveProblems($inputDocumentToAnalyze))
        return
            (: Validation if the response has elements with problems :)
            if ($nodesCount > 0) then
                "YES - it's Deceptive!"
            else 
                ()
};

(: Declaring variable for input document :)
declare variable $inputDocument as document-node() external;

(: Call the function :)
man:validateDeceptive($inputDocument) 