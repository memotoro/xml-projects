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
    Part 1: Pure XPath 
:)

(: Declaration of namespace for this xquery and functions :)
declare default element namespace "http://www.cs.manchester.ac.uk/pgt/COMP60411/el";

(: XPath to retrieve all the elements that are part of ClassExpression :)
doc("el1.xml")/ dltheory/ (equivalent//* | subsumes//* | instance-of// (* except constant) )
