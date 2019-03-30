library(lisp)
#' Defines a function with guards
#'
#' is an  operator which is used to define functions with guard statements
#'
#' Guard is an boolean expression in parenthesis, followed by the expression to execute
#' if the guard expression evals to true.
#' (y!=0)
#' {
#'	  x/y
#' }
#'
#' Both, the guard and function expression can be any valid R code, as long as the
#' syntax remains the same.
#'
#' Internally, guard simply compiles the function body to a  if (...) else if (...) else
#' statement.
#'
#' @return A compiled, guarded function
#' @examples
#' fib <- .%guarded% function(x){
#' 	(x<=1)
#' 	{
#' 		x
#' 	}
#' 	(otherwise)
#' 	{
#' 		Recall(x-1) + Recall(x-2)
#' 	}
#' }
`%guarded%` <- function(lhs,e)
{
	body <- deparse(substitute(e))
	se <- parse(text=paste(body[2:(length(body)-1)],collapse = "\n"))
	stmt <- paste0("{",.guard(se),"}")
	fn <- parse(text=paste(body[1],stmt,body[length(body)],sep="\n"))
	fn <- compiler::cmpfun(eval(fn))
	fn
}


.guard <- function(se,level=0){
	if(length(se)==0) return("")
	stmt <- ""
	if(level>0)
		stmt <- " else "
	stmt <- paste(stmt,
				  "if",
				  deparse(car(se)),
				  paste(deparse(car(cdr(se))),collapse = "\n"))

	paste0(stmt,.guard(cdr(cdr(se)),level+1))
}

#' Otherwise guard
#'
#' Use as the last guard statement (if required)
#' @examples
#' (otherwise)
#' {
#'    NA
#' }
otherwise <- T