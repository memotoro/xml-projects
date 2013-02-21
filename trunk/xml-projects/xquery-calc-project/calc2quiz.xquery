import schema default element namespace "" at "flashcardhtml.xsd";
import schema namespace q="http://www.cs.manchester.ac.uk/pgt/COMP60411/examples/quiz" at "quiz.xsd";

(:
    <Author>
        <Name>Guillermo Antonio</Name>  
        <LastName>Toro Bayona</LastName>
        <ID_Student>8567391</ID_Student        
    </Author>
    <Course_Unit>
        <Course>COMP60411</Course>
    </Course_Unit>

    My XQuery for Calculation   
    This file contains the xquery functions to calculate the expression result and show the expression
    in a readable form.
:)

(: Function to receive an expression and convert it in a String :)
declare function local:expr2humanReadable($expr) {

    (: For every node in the first level of the expression received :)
    for $exprNode in $expr/* 
    
        (: Variable declaration :)        
        let $expressionDescription :=
        
            (: Validate if the local name is plus :)
            if( $exprNode/name() = "plus" ) then (
            
                (: Sequence of nodes retrieved by recursion. :)
                let $sequenceReceived := local:expr2humanReadable($exprNode)
                (:  
                    Concat the results. 
                    Take two arguments due to the restriction in the Schema that 2 max and min occurrences for expressions. 
                :)
                return
                    (: Validate the size of the sequence to operate :)
                    if( fn:count($sequenceReceived) = 2 ) then (                 
                        fn:concat("(", $sequenceReceived[1], " + ", $sequenceReceived[2], ") ")
                    )
                    else ()
            )    
            
            (: Validate if the local name is times :)                    
            else if( $exprNode/name() = "times" ) then (
            
                (: Sequence of nodes retrieved by recursion. :)
                let $sequenceReceived := local:expr2humanReadable($exprNode)
                (:  
                    Concat the results. 
                    Take two arguments due to the restriction in the Schema that 2 max and min occurrences for expressions. 
                :)
                return
                    (: Validate the size of the sequence to operate :)
                    if( fn:count($sequenceReceived) = 2 ) then (                 
                        fn:concat("(", $sequenceReceived[1], " * ", $sequenceReceived[2], ") ")
                    )
                    else ()
            )    
            
            (: Validate if the local name is minus :)                    
            else if( $exprNode/name() = "minus" ) then (
                
                (: Sequence of nodes retrieved by recursion. :)
                let $sequenceReceived := local:expr2humanReadable($exprNode)
                (:  
                    Concat the results. 
                    Take two arguments due to the restriction in the Schema that 2 max and min occurrences for expressions. 
                :)
                return
                    (: Validate the size of the sequence to operate :)
                    if( fn:count($sequenceReceived) = 2 ) then (                 
                        fn:concat("(", $sequenceReceived[1], " - ", $sequenceReceived[2], ") ")
                    )
                    else ()
            )
                
            (: Validate if the local name is dividedBy :)                    
            else if($exprNode/name() = "dividedBy") then (
                
                (: Sequence of nodes retrieved by recursion. :)
                let $sequenceReceived := local:expr2humanReadable($exprNode)
                (:  
                    Concat the results. 
                    Take two arguments due to the restriction in the Schema that 2 max and min occurrences for expressions. 
                :)
                return
                    (: Validate the size of the sequence to operate :)
                    if( fn:count($sequenceReceived) = 2 ) then  (               
                        fn:concat("(", $sequenceReceived[1], " / ", $sequenceReceived[2], ") ")
                    )
                    else ()            
            ) 
            
            (: Validate if the local name is number. This point is the control of the recursion function. :)
            else if( $exprNode/name() = "number" ) then (
                
                (: Return the text value of the node :)                
                $exprNode/text()                    
            )
            
            else ()
            
    (: Return the result :)                   
    return $expressionDescription 
};

(: Function to calculate the value of an expression :)
declare function local:answerFor($expr) {

    (: For every node in the first level of the expression received :)
    for $exprNode in $expr/* 
    
        (: Variable declaration :)        
        let $expressionResult :=
            
            (: Validate if the local name is plus :)
            if( $exprNode/name() = "plus" ) then (
            
                (: Sequence of operands retrieved by recursion. :)
                let $operandsSequence := local:answerFor($exprNode)
                (:  
                    Calculate with operands received. 
                    Take two arguments due to the restriction in the Schema that 2 max and min occurrences for expressions.
                    First, convert in numbers and then apply the appropriate operator.
                :)  
                return 
                    (: Validate the size of the sequence to operate :)
                    if( fn:count($operandsSequence) = 2 ) then (   
                        ( fn:number($operandsSequence[1]) + fn:number($operandsSequence[2]) )
                    )
                    else () 
            )
            
            (: Validate if the local name is times :)
            else if( $exprNode/name() = "times" ) then (
            
                (: Sequence of operands retrieved by recursion. :)
                let $operandsSequence := local:answerFor($exprNode)
                (:  
                    Calculate with operands received. 
                    Take two arguments due to the restriction in the Schema that 2 max and min occurrences for expressions.
                    First, convert in numbers and then apply the appropriate operator.
                :)
                return 
                    (: Validate the size of the sequence to operate :)
                    if( fn:count($operandsSequence) = 2 ) then (   
                        ( fn:number($operandsSequence[1]) * fn:number($operandsSequence[2]) )
                    )
                    else () 
            )
            
            (: Validate if the local name is minus :)                    
            else if( $exprNode/name() = "minus" ) then (
                
                (: Sequence of operands retrieved by recursion. :)
                let $operandsSequence := local:answerFor($exprNode)
                (:  
                    Calculate with operands received. 
                    Take two arguments due to the restriction in the Schema that 2 max and min occurrences for expressions.
                    First, convert in numbers and then apply the appropriate operator.
                :)                
                return 
                    (: Validate the size of the sequence to operate :)
                    if( fn:count($operandsSequence) = 2 ) then (   
                        ( fn:number($operandsSequence[1]) - fn:number($operandsSequence[2]) )
                    )
                    else () 
            )
            
            (: Validate if the local name is dividedBy :)                    
            else if( $exprNode/name() = "dividedBy" ) then (
                
                (: Sequence of operands retrieved by recursion. :)                
                let $operandsSequence := local:answerFor($exprNode)
                (:  
                    Calculate with operands received. 
                    Take two arguments due to the restriction in the Schema that 2 max and min occurrences for expressions.
                    First, convert in numbers and then apply the appropriate operator.
                :)                
                return 
                    (: Validate the size of the sequence to operate :)
                    if( fn:count($operandsSequence) = 2 ) then (   
                        ( fn:number($operandsSequence[1]) div fn:number($operandsSequence[2]) )
                    )
                    else () 
            )
            
            (: Validate if the local name is number. This point is the control of the recursion function. :)                    
            else if( $exprNode/name() = "number" ) then (
                
                (: Return the value as a number :)
                fn:number($exprNode/text())                       
            )
            else ()
            
    (: Return the result :) 
    return $expressionResult
};

validate{<html>
    <head>
        <title>{/*/q:title/text()}</title>
        <script type="text/javascript" src="miniformvalidator.js"></script>
    </head>
    <body>
        <h1>{/*/q:title/text()}</h1>
        <form>
            <ol>{let $exprs := /*/q:expr, 
                     $count := count($exprs)
                 for $i in (1 to $count)
                 let $expr := $exprs[$i]
                 let $id := concat("q", $i)
                 return <li>{local:expr2humanReadable($expr)}=
                <input type="text" id="{$id}" data-answer="{local:answerFor($expr)}" size="8" /><span><input
                        type="button" onclick="check(document.getElementById('{$id}'))"
                        value="Check answer" /></span>
                </li>}
            </ol>
        </form>

    </body>
</html>}