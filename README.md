Description
===========
Provides a syntax for using [guard pattern](https://en.wikipedia.org/wiki/Guard_(computer_science)) in R.

The package is currently very crude and experimental, with no checks etc. At the moment
it only prooves the concpt works for simple examples.

Basic Usage
===========

Defining a function with guards
-------------------------------
Functions are defined using .`%guarded%` notation. 

```R
div <-  .%guarded% function(x,y)
{
	(y!=0)
	{
		x/y	
	}
	(otherwise)
	{
		NA
	}
}

div(10,1)
#10
div(10,0)
#NA
```

`%guarded%` operator
---------------------
is implemented as a binary operator, which makes it possible to have a
function definition on the RHS without using brackets.

On the downside, there must also be a LHS component, which is ignored by the guard.
I find a dot to work good for that purpose, hence the .`%guarded%` notation in the
sample.


Defining guards
----------------
Guard is an boolean expression in parenthesis, followed by the expression to execute
if the guard expression evals to true.

```R
	(y!=0)
	{
		x/y	
	}
```

Both, the guard and function expression can be any valid R code, as long as the
syntax remains the same.


Otherwise
---------

To define a function in case none of the previous guards matched, use _otherwise_.

```R
	(otherwise)
	{
		NA
	}
```

_otherwise_ is defined simply as TRUE and will always execute if the execution point
reaches it.


Implementation
--------------
What guard does is it simply compiles the expression to if (...) else if (...) else
statement.

The above function becomes:

```R
div <-  .%guarded% function(x,y)
{
	if(y!=0)
	{
		x/y	
	} else {
		NA
	}
}
```


Performance
-----------
Performance will be exactly the same as if your code were using if statements.
Guard does not use dyanmic dispatch, but simply returns a compiled function.


Version 0.1.0
-------------
+ Proof of concept

Future
======
+ Test real world examples
