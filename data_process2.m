function [out1,out2]=data_process2(varargin)

fid=fopen(varargin{1});

C = textscan(fid, '%*s %*s %n %n %n %n');

for i=1:100
  z=((i-1)*100+1);
       %[tree #, Mean Generations , %Converged avg?, %Mean Runtime]
   M(i,:)=[C{1}(z), mean(C{2}(z:z+99)),mean(C{3}(z:z+99)), mean(C{4}(z:z+99))];
end;

out1=M;

out2=[mean(M(:,2)),mean(M(:,3)),mean(M(:,4))];

fclose(fid);