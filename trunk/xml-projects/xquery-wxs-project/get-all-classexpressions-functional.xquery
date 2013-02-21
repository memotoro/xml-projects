(:
    <Author>
        <Name>Guillermo Antonio</Name>  
        <LastName>Toro Bayona</LastName>
        <ID_Student>8567391</ID_Student        
    </Author>
    <Course_Unit>
        <Course>COMP60411</Course>
    </Course_Unit>

    My XQuery for ClassExpression   
    Part 2: XPath with xquery function 
:)

(: Declaration of namespace for this xquery and functions :)
declare default element namespace "http://www.cs.manchester.ac.uk/pgt/COMP60411/el";
declare namespace ssd="http://www.cs.manchester.ac.uk/pgt/COMP60411/";

(: Declare variable for the document :)
declare variable $inputDocument := doc("el1.xml"); 

(: Declare function that receive a node an return boolean if it's a class expression :)
declare function ssd:classexpression($nodeElement as node()) as xs:boolean {
    (: Variable declaration:)
    let $validationClassExpression :=
        (: Conditionals :)
        if($nodeElement/name() = "atomic" or
            $nodeElement/name() = "conjunction" or
            $nodeElement/name() = "exists")
        then        
            true()        
        else
            false()
        (: Return result validation:)
        return 
            $validationClassExpression
};

(: XPath with function call:)
$inputDocument//*[ssd:classexpression(.)=true()]