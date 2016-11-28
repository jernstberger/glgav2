close all;
clear all;

format long g


%Types of graphs
type ={'k','c', 'p', 't', 'w','r','kmn','cr','h','gp'};%s--we have omitted stars
%k-complete
%c-cycles
%p - path
%t- random tree
%w-wheel
%r- random normal caterpillar
%kmn- complete bipartite graph
%cr- crown
%h - helm
%gp - generalized Petersen graph


%Struct encoded with sizes of graph types (as fields).
n=struct('c',[8,10,15,20,25,30,40,50],'p',[5,10,20,25, 27,28,30,40,50],'t',[20,25,28,30,35,40,50,60,70,80,90,100],'k',[5,8,10,15,16,20,24,30],...
	  'w',[7,8,10,15,20,30],'r',[5,8,10,15,30,45],'kmn',[5,5;5,10;5,20;10,20],'cr',[5,8,10,15,20,30],...
	  'h',[5,8,10,20,30],'gp',[5,2;6,3;7,3;8,4;9,4;10,5]);

	
%set the initial population size at 1000
input.popsize=1000;

%keep the best half.
input.elitism=.5*input.popsize;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Do you want more or less screen output. If more, set equal to 'verbose',
%	if less, 'silent'.
input.screenoutput='verbose';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

time_array=zeros(100,1);

input.restart='on';
input.restart_Iter='2000';

%chooses graph type
for j=4:4%length(type)
      %Determine which graph size to be studied
      index1=length(getfield(n,type{j}));
      for k=4:4%index1
	
	  a_ray=getfield(n,type{j});
	  if strcmp(type{j},'kmn') | strcmp(type{j},'gp')
		graph=[type{j},'_(',num2str(a_ray(k,1)),',',num2str(a_ray(k,2)),')'];
	  else	
		graph=[type{j},'_',num2str(a_ray(k))];
	  end;
		
	  input.graph=graph;
	
      %Set default numbers of generations for GA.  
	  input.generations=3e6;
       if strcmp(type{j},'k')
			input.generations=5e3;
	   elseif strcmp(type{j},'c') & (mod(n.c(k),4)~=0) & (mod(n.c(k),4)~=3)
			input.generations=5e3;	
	   elseif strcmp(type{j},'c') & k==7
			input.generations=1e7;
	   end;


	%Open a date-referenced data file
	s=[graph,date,'glga_data.txt'];
	fid=fopen(s,'w');


	
	%For each graph type and size, how many times would you like to trial a solution? 
	solns_trials=1;
	for i=1:solns_trials
	  a_ray=getfield(n,type{j});
	  if strcmp(type{j},'kmn') | strcmp(type{j},'gp')
		A=perl('rg.pl','-t',type{j},'-n',num2str(a_ray(k,1)),'-m',num2str(a_ray(k,2)));
      else	
		A=perl('rg.pl','-t',type{j},'-n',num2str(a_ray(k)));
	  end;

	  %Export char A to a matrix with format given
	  A=sscanf(A,'%f');

	  %Reshape the matrix from a column to a matrix of appropriate dimension
	  A=transpose(reshape(A,2,length(A)/2));
		
	  input.A=A;
	  input.edge_list=A(2:end,:);
		

    	%How many times would you like to test the same graph
		graph_test_no=1;  
	  	for m=1:graph_test_no
	    	%Keep track of time
	    	time_array(i)=cputime;
  
		    %Call the GA routine for graceful labels
		    [solution,generations,converge]=glga(input);

	    	%How much time has elapsed
	    	time_array(i)=cputime-time_array(i);
	    
		    %Basic strings for output
		    fprintf(fid,'%s\t %s\t %i\t %g\t %i\t %1.9e\n',graph,'GA',i,generations,converge,time_array(i));
			fprintf('%s\t %s\t %i\t %g\t %i\t %g\n',graph,'GA',i,generations,converge,time_array(i));
	    
		end;
      end;
  end;
end;

fclose(fid);