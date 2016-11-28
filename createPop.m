%Jon M. Ernstberger
%jernstberger@lagrange.edu
%createPop.m
%11/20/2016
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Creates an initial population to be used in the genetic algorithm approach to determine graceful labelings.
%
%	Inputs
%		1.  number of members of the population
%		2.  size of each member
%		3.  range of population genes
%
%	Outputs:
%		1.  The only current output is the newly created population.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function varargout=createPop(varargin)

PopNumber=varargin{1};
MemberSize=varargin{2};
Range=varargin{3};

%Create a matrix of zeros with a subset of the full population size (rows) x one number for each vertex.
InitialPopulation=zeros(PopNumber,MemberSize);

%Since randperm creates a permutation of size Membersize from 0 to NumVertices.
for i=1:PopNumber/2
  InitialPopulation(i,:)=randperm(Range+1,MemberSize)-1;
end;

%Duplicate the top half, only flip it (end:-1:1)
InitialPopulation(PopNumber/2+1:end,:)=InitialPopulation(1:PopNumber/2,end:-1:1);

%Pass out the initial population
varargout{1}=InitialPopulation;