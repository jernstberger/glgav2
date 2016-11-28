%Jon M. Ernstberger
%jernstberger@lagrange.edu
%objFcn.m
%11/20/2016
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%The intent of this objective functional is to take a population of labelings, rank 
%them, and see if any of them are to be considered "graceful".
%
%
%	Inputs
%		1.  string of file name or adjacency matrix
%		2.  population to be tested.
%
%	Outputs
%		1.  rank
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function varargout=objFcn(varargin)

%load graph from file if the first input is the string name
A=varargin{1}.A;
edge_list=varargin{1}.edge_list;
NumEdges=A(1,2);

%Take as the second input argument the 
%population that is to be passed into the GA
pop=varargin{2};

%determine the size of the population
m2=varargin{1}.popsize;

%takes the difference of the two matrices above--forms the matrix of labels then
%sorts that matrix down each row.
Edge_label=sort(abs(pop(:,edge_list(:,1))-pop(:,edge_list(:,2))),2);

%Create a matrix of comparison for the sorted version.
Compare=repmat(1:NumEdges,m2,1);
 
%Compute the fitness of individual potential solutions.
%Then output that value.
varargout{1}=(sum(Edge_label==Compare,2))/NumEdges;