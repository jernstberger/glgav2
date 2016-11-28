# glgav2
This is the second version of a set of codes for performing the genetic algorithm on an edge list.  Here are the files:

1.  ga_graphtest1.m - Why it is named this is because it is a huge script that is intended to run tons of trials on a variety of graphs.
2.  rg.pl - This is the Perl script written by A. Perkins at Mississippi State University to generate the edge list.
3.  glga.m - This is the primary piece of code that performs the genetic algorithm.
4.  createPop.m - This creates the population given the specifications of the graph.
5.  gracefulCross.m - This performs the crossover/mutation operations required to mimic GA behaviors.
6.  objFcn.m - This is the objective or "fitness" functional.  It tests the values of the population members.
7.  sortrowsj.m - This is a modified version of the sortrows.m function in MATLAB.  It uses MATLAB's built in SORT rather than a standard C algorithm for speed.
8.  data_process2.m - This is an out-of-date script for processing the results of the files that are produced by the GLGA.
