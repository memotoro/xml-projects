(:
    <Author>
        <Name>Guillermo Antonio</Name>  
        <LastName>Toro Bayona</LastName>
        <ID_Student>8567391</ID_Student        
    </Author>
    <Course_Unit>
        <Course>COMP60411</Course>
    </Course_Unit>

    My XQuery for Axioms   
    Part 2: XPath with xquery function 
:)

(: Declaration of namespace for this xquery and functions :)
declare default element namespace "http://www.cs.manchester.ac.uk/pgt/COMP60411/el";
declare namespace ssd="http://www.cs.manchester.ac.uk/pgt/COMP60411/";

(: Declare variable for the document :)
declare variable $inputDocument := doc("el1.xml"); 

(: Declare a function that receive a node an response boolean if it's an axiom :)
declare function ssd:axiom ($nodeElement as node()) as xs:boolean {
    (: Conditional :)
    let $validationAxiom := 
        if ( $nodeElement/name() = "equivalent" or
                $nodeElement/name() = "subsumes" or 
                $nodeElement/name() = "instance-of" or
                $nodeElement/name() = "related-to")
        then    
            true() 
        else 
            false()
        (: Return the validation result :)        
        return 
            $validationAxiom
};


(: XPath with function call :)
$inputDocument//*[ssd:axiom(.)=true()]