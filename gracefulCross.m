%Jon M. Ernstberger
%jernstberger@lagrange.edu
%11/20/2016
%gracefulCross.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%This algorithm is to provide a crossover for the genetic algorithm programmed for the graceful
%tree labeling problem.
%
%	Inputs
%		1.  Population
%		2.  number of gene swaps (default is two, max is number of gene in each member).  
%		    should be less than the total number of genes/2.
%
%	Outputs
%		1.  The only output (currently) is the population that has recently altered by
%		    the experience of crossover.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function varargout=gracefulCross(varargin)

Pop=varargin{1};
[~,n]=size(Pop);
num_swaps=varargin{2}; %number of swaps to perform

%Exchange entire columns in the population matrix
%Determine the order in which they should be switched.
indices=randperm(n,2*num_swaps);
switching_order=indices(randperm(2*num_swaps,2*num_swaps));
Pop(:,indices)=Pop(:,switching_order);

%Output the fully swapped population.
varargout{1}=Pop;