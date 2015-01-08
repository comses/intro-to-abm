# Programs
In this course we will learn how to develop computer programs to simulate social phenomena. In this chapter we introduce some basic concepts of programming. A computer program consists of data and algorithms. Data refer to quantitative information of the problem, while an algorithm is a set of ordered steps to solve a problem. In fact, a program is like a recipe. Let’s look at a recipe to prepare a [Reuben sandwich](http://en.wikibooks.org/wiki/Cookbook:Reuben_Sandwich).

 ![Reuben](https://raw.githubusercontent.com/comses/intro-to-abm/master/assets/images/CH_3_Fig_2_Reuben.png)<br>*Figure 2. Reuben sandwich.*

*Ingredients*
*  ½ pound (225g) sliced corned beef
*  ¼ cup (60ml) drained sauerkraut
*  2 tablespoons chopped sweet onion
*  2 tablespoons creamy Russian dressing
*  2 slices rye bread
*  1-3 slices Swiss cheese
*  chopped parsley
*  1 tablespoon butter

*Procedure*
*  Combine the sauerkraut, onion, and parsley
*  Spread the dressing on two slices bread
*  Pile layers of corned beef, cheese, and sauerkraut mixture on one slice
*  Add second slice of bread
*  Butter the outside of the bread
*  Grill until lightly browned, roughly 5 minutes

The ingredients are like the input data for a program, while the procedure is the algorithm to make a Reuben sandwich given the input data. Additional data are used in the algorithm, such as 5 minutes in step 6 of the procedure, which is like a parameter value in a program.
Although a recipe is like a program, different persons may generate different variations of the sandwich. With a computer program the instructions have to be clear enough so that each computer will produce exactly the same results. There is no room for different interpretations. In practice this can make computer programming a time-consuming and frustrating experience, since you will get error messages or wrong results if you don’t give the right commands.

##Example of Algorithms: Sorting
Suppose you have the following list of numbers:


<dl>
<dd>
4 2 1 3<br>
</dl>

You are asked to develop an algorithm that sorts this list of numbers from small to large. This algorithm should also be potentially applied to any other list of numbers. What would such an algorithm be?
A simple algorithm would be the so-called [bubble sort](http://en.wikipedia.org/wiki/Bubble_sort). This algorithm steps repeatedly through the list to be sorted comparing two items at a time, swapping them if they are in the wrong order. This process is repeated until a pass through the list does not lead to any more swaps. The list is then sorted.

<dl>
<dd>**2 4** 1 3  swap<br>
2 **1 4** 3  swap<br>
2 1 **3 4**  swap<br>

<dd>**1 2** 3 4  swap<br>
1 **2 3** 4<br>
1 2 **3 4**<br>

<dd>**1 2** 3 4<br>
1 **2 3** 4<br>
1 2 **3 4**
</dl>


Bubble sort is a simple but very inefficient algorithm since it takes many repeats to go through the list to get it sorted. The duration of the algorithm grows exponentially with the length of the list.
Another sorting algorithm invented by [John von Neumann](http://en.wikipedia.org/wiki/John_von_Neumann), which is much more efficient, is [merge sort](http://en.wikipedia.org/wiki/Merge_sort). It is based on the observation that short lists can be sorted quickly, and one may split up the list into smaller units, and then merge the smaller lists into a bigger list.

Thus for a list larger then 1 unit, divide up the list in two sub lists. Sort each sub list recursively by merge sort. As a consequence we first split a list into very small sub lists and then aggregate this up in steps to the original size of the list.

<dl>
<dd>4 2&nbsp;&nbsp;&nbsp;&nbsp;1 3<br>
**2 4**&nbsp;&nbsp;&nbsp;&nbsp;1 3<br>
2 4&nbsp;&nbsp;&nbsp;&nbsp;**1 3**<br>
</dl>
Now it compares the first of both lists.
<dl>
<dd>**2** 4&nbsp;&nbsp;&nbsp;**1** 3&nbsp;&nbsp; &#8594;1 2<br>
**2** 4&nbsp;&nbsp;&nbsp;1 **3**&nbsp;&nbsp;&nbsp;&#8594;1 2 3<br>
2 **4**&nbsp;&nbsp;&nbsp;1 **3**&nbsp;&nbsp;&nbsp;&#8594;1 2 3 4<br>
</dd>
The computer had to do 9 comparisons with the bubble sort and only 5 with the Neumann algorithm. For larger lists the efficiency of Neumann’s algorithm will become more prominent.
