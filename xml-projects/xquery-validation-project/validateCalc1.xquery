declare namespace ssd="http://www.cs.manchester.ac.uk/pgt/COMP60411/";

(:
    <Author>
        <Name>Guillermo Antonio</Name>  
        <LastName>Toro Bayona</LastName>
        <ID_Student>8567391</ID_Student        
    </Author>
    <Course_Unit>
        <Course>COMP60411</Course>
    </Course_Unit>

    My Xquery Validation Constratins   
    This file contains the xquery functions to validate the structure of calc1
    with xquery functions and xpath expressions.
:)

(:
    Declare function to validate the node
:)
declare function ssd:isValid($node) {

    (:
        Validate distinct values for node structure.
    :)
    let $validateResponse := fn:distinct-values(ssd:validateNodeStructure($node))
        return
        
        (:
            Validate node structure as true()
        :)
        if( (fn:count($validateResponse) = 1) and
            (fn:data($validateResponse) = fn:true()) ) then
            fn:true()
        else (
            fn:false()
        )  
};

(:
    Declare function to validate the node structure.
:)
declare function ssd:validateNodeStructure($node) {
    let $validationResponse :=
    
    (:
        Loop for every children in the node 
    :)
    for $childNode in $node/*
        return
        
        (:
            Validate it is node 'expression'
        :)
        if( fn:local-name($childNode) = 'expression' ) then (
        
            (:
                Validate number of children, text nodes nad attributes
            :)
            if( ssd:validateChildrenNumber($childNode, 1, 'eq') and            
                ssd:validateTextNodes($childNode) and                                
                ssd:validateAttributeNumber($childNode, 0)) then (
                
                (:
                    Recursion function
                :)
                ssd:validateNodeStructure($childNode)
            )else(
                fn:false()
            )
        )
        
        (:
            Validate it is node 'plus' or 'times'
        :)        
        else if( fn:local-name($childNode) = 'plus' or fn:local-name($childNode) = 'times' ) then (
            
            (:
                Validate number of children, text nodes nad attributes
            :)
            if( ssd:validateChildrenNumber($childNode, 2, 'gt') and            
                ssd:validateTextNodes($childNode) and                                
                ssd:validateAttributeNumber($childNode, 0)) then (
                
                (:
                    Recursion function
                :)
                ssd:validateNodeStructure($childNode)
            )else(
                fn:false()
            )
        ) 
        
        (:
            Validate it is node 'minus'
        :)
        else if( fn:local-name($childNode) = 'minus' ) then (
            
            (:
                Validate number of children, text nodes nad attributes
            :)
            if( ssd:validateChildrenNumber($childNode, 2, 'eq') and            
                ssd:validateTextNodes($childNode) and                                
                ssd:validateAttributeNumber($childNode, 0)) then (
                
                (:
                    Recursion function
                :)
                ssd:validateNodeStructure($childNode)
            )else(
                fn:false()
            )
        ) 
        
        (:
            Validate 'int' node
        :)
        else if( fn:local-name($childNode) = 'int' ) then (
        
            (:
                Validate number of children, text nodes nad attributes
            :)
            if( ssd:validateChildrenNumber($childNode, 0, 'eq') and            
                fn:empty($childNode/text()) and                                
                ssd:validateAttributeNumber($childNode, 1) and
                fn:local-name($childNode/attribute()) = 'value') then (
                    
                    (:
                        Validate with regular expression numbers in the value.
                    :)
                    if( fn:matches(fn:data($childNode/@value),'^[0-9]+$') ) then (
                        fn:true()
                    ) else (
                        fn:false()
                    )                
            ) else (
                fn:false()
            )           
        ) else (
            fn:false()
        )

    (:
        Return validation
    :)
    return 
        $validationResponse
};

(:
    Declare function to validate text nodes    
:)
declare function ssd:validateTextNodes($node as node()) as xs:boolean{

    (:
        Call the distinct values for validate text content function.
    :)
    let $validationContent := fn:distinct-values(ssd:validateTextNodeContent($node))
    return
    
        (:
            Validate the size of the variable and result true().
        :)
        if( fn:count($validationContent) = 1
            and fn:data($validationContent) = true() ) then (
            fn:true()
        ) else (
            fn:false()
        )
};

(:
    Declare function to validate text nodes
:)
declare function ssd:validateTextNodeContent($node as node()) {

    (:
        Loop for every text node
    :)
    for $textNode in $node/text()
    
    (:
        Declare a variable to normalized content without whitespaces
    :)
    
    let $data := fn:normalize-space($textNode)
    
    (:
        Validate the size of the data node.
    :)
    let $validation :=        
        if( fn:string-length($data) = 0 ) then
            fn:true()
        else(
            fn:false()
        )
        
    (:
        Return validation
    :)
    return $validation
};

(: 
    Declare function to validate the number of children in one node. 
:)
declare function ssd:validateChildrenNumber($node as node(), $numberOfChildren as xs:integer, $operator as xs:string) as xs:boolean{
    
    (:
        Validate the operator to apply. Equal operator
    :)
    if($operator = 'eq') then (
        
        (:
            Compare the number of children
        :)
        if( fn:count($node/*) = $numberOfChildren ) then
            fn:true()
        else
            fn:false()
    )
    
    (:
        Validate the operator to apply. Equal greater than.
    :)
    else if($operator = 'gt') then (
        
        (:
            Compare the number of children
        :)
        if( fn:count($node/*) >= $numberOfChildren ) then
            fn:true()
        else
            fn:false()
    )else (
        fn:false()
    )
};

(: 
    Declare function to validate attribute number for elements. 
:)
declare function ssd:validateAttributeNumber($node, $numberOfAttributes) as xs:boolean{
    
    (: 
        Validate the number of attributes for the specific node. 
    :)
    if( fn:count($node/attribute()) = $numberOfAttributes ) then
        fn:true()
    else
        fn:false()
};

(: 
    Declare function to validate Calc1 
:)
declare function ssd:validWrtCalc1($node) {
    if (ssd:isValid($node))
    then "valid"
    else "invalid"            
};

(: Declare variable that refers to a document to be validated. :)
declare variable $doc := fn:doc("documentToValidate.xml");

ssd:validWrtCalc1($doc)