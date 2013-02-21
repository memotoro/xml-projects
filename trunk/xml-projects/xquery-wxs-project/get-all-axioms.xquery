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
    Part 1: Pure XPath 
:)

(: Declaration of namespace for this xquery and functions :)
declare default element namespace "http://www.cs.manchester.ac.uk/pgt/COMP60411/el";

(: XPath to retrieve all the elements that are part of Axioms :)
doc("el1.xml")/dltheory/( instance-of | subsumes | equivalent | related-to )