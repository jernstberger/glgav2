%  Jon M. Ernstberger
%  LaGrange College
% jernstberger@lagrange.edu
%  11/20/2016
%  glga.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
%  Input-A struct that contains (or does not) the fields
%      a.  'filename'-contains the string name of the .m-file that contains the 
%		adjacency matrix. This must be specified.
%      b.  'popsize'-number of 'solutions' to the GA. (Default is 10 times the 
%		size of the adjacency matrix.)
%      c.  'elitism'- number of elite population members. (Default is the size 
%		of the adjacency matrix.)
%      d.  'generations'-number of allowable generations (Default is 100 times 
%		the size of the adjacency matrix.)
%      e.  'screenoutput'-type of screen output. verbose, silent, or normal.  
%		(Default is normal)
%      f.  'restart'-Restart the genetic algorithm according to the value in 
%		'restart_Iter'.  Either 'on' or 'off'.  If 'on', the value 
%		'restart_Iter' is referenced.
%	g.  'restart_Iter'-Number of iterations at which the population is
%		reinitialized.  The default is round(generations/3);
%	h.  'store_generations'-either 0 (no) or 1 (yes).  Default is 0.
%      
%  Ouput.  There are two outputs currently.
%      a.  Solution-the output here is the (in order of sort) first solution that 
%		produces a grace labeling for the adjacency matrix specified in 
%		the filename field of the input struct.
%      b.  Number of generations-a simple output that relates the number of generations
%		required to produce the graceful labeling of the specified tree.
%	c.  Converge flag.  Does the iteration converge?  1 for yes and 0 for no.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function varargout=glga(varargin)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin==1
  if isstruct(varargin{1})
    A=varargin{1}.A; NumVertices=A(1,1);NumEdges=A(1,2);
    
    if isfield(varargin{1},'popsize') PopSize=varargin{1}.popsize;else PopSize=50*NumVertices;end;
    if isfield(varargin{1},'elitism') elitism=varargin{1}.elitism; else elitism=NumVertices;end;
    if isfield(varargin{1},'generations') maxGenerations=varargin{1}.generations; else maxGenerations=10000*NumVertices;end;
    if isfield(varargin{1},'screenoutput') toScreen=varargin{1}.screenoutput;  else toScreen='normal';end;
    if isfield(varargin{1},'restart') restart=varargin{1}.restart;else restart='off';end;
    if isfield(varargin{1},'restart_Iter')restart_Iter=varargin{1}.restart_Iter;else restart_Iter=maxGenerations;end;
  else
    error('First input is not the necessary struct with specified data fields.  Please read the comments for this program.');
  end;
elseif nargin>1
    warning('Extra input values are ignored.');
else
  error('There are no input values to glga.  Reread the comments and examples to run this code correctly.');
end;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Set status as not converged.
converge=0;

%Set initial generation count.
generations=1;

%Initialize Population
population(:,:,1)=createPop(PopSize,NumVertices,NumEdges);

if strcmp(toScreen,'normal') | strcmp(toScreen,'verbose')
  disp(sprintf('\nGenerations\t Best Member\t\t Average Member')); 
end;
  
while generations<=maxGenerations & converge==0
    
  %evaluate objective functional
  rank=objFcn(varargin{1},population);
 
  %couple together the population matrix and its scores
  rankSorted=[rank,population];

  %sort solutions from best to worst
  rankSorted=sortrowsj(rankSorted,1);
  rankSorted=rankSorted(end:-1:1,:);

  if strcmp(toScreen,'verbose')
    if mod(generations,1000)==0
      if mod(generations,10000)==0
        disp(sprintf('\nGenerations\t Best Member\t\t Average Member')); 
      end;
      disp(sprintf('%g\t\t %1.6e\t\t %1.6e',generations,rankSorted(1,1),mean(rankSorted(:,1))));
    end;
  end;

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %if a  solution is found
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  if max(rankSorted(:,1))==1
    converge=1;    
    if strcmp(toScreen,'verbose')
       disp(sprintf('The solution was obtained after %4g generations.',generations));
    end;
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %but if one is not found
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  else 
    %separate all solutions from score keeping
    population=rankSorted(:,2:end);

    %Keep the chosen quantity for elitism purposes
    Elite_few=population(1:elitism,:);

    if generations==restart_Iter & strcmp(restart,'on')
	   %restart the iteration
	     population((elitism+1):end,:)=createPop(PopSize-elitism,NumVertices,NumEdges);
    else
      %perform elitism and mutation/crosover
      population((elitism+1):end,:)=gracefulCross(Elite_few,2);
    end;

    %increase interation count
    generations=generations+1;
  end;
end;
 
varargout{1}=population(1,:);
varargout{2}=generations;
varargout{3}=converge;