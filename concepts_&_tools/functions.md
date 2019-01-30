# Functions
Suppose we want to model the number of students at the university in order to investigate how many new classrooms need to be built in the coming years. We will need to predict how the number of students will change over time. Therefore, our main focus will be the number of students, which is represented as NoS. The number of students in 2000 is presented as NoS(2000). In 2001 some students graduated, others dropped out, and new students came to the university. To describe the number of students in 2001 we may have something like:

###`NoS(2001) = NoS(2000) – Graduated – Dropped out + Transfers + New students.*          (1)`

This relationship will be the same for each year. As such we can define a function for *NoS(t)*.

In more general term, most agent-based models describe how values of variables change during the iterations of the simulation. A *variable* is an attribute of a system that can change over time. With a system we refer to set of interacting or interdependent entities forming an integrated whole. With iterations we mean the execution of a set of instructions that are to be repeated.

Given a variable of interest *x*, which might refer to the population size, level of financial capital or the level of natural resources. Such a variable is called a [state variable](http://en.wikipedia.org/wiki/State_variable), and a dynamic model describes how the value of *x* changes over time. In the simulation models discussed in this course time is considered to be discrete. Hence, given a time step t for which *x(t)* is defined, we need to define *x(t+1)*. To define the relationship between the current and the future state of the system, we formulate a difference equation:

`x(t+1) = f(x(t))          (2)`

where *f()* is a function of variable *x*. More specifically, the function *f()* may consist of a number of [parameters](http://en.wikipedia.org/wiki/Parameter) *p*, which determine the shape of the function:

`x(t+1) = f(x(t), p)         (3)`

Examples of parameters are the growth or death rate of a species, interest rate, etc.
