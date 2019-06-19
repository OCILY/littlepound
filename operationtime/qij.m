function q=qij(i,j,s)%i是最小区块内工作顺序号，j是单农机工作区块号，s是跳过条带数，q是单农机条带号
if i==1
    q=(2*s+1)*(j-1)+1;
elseif mod(i,2)==0
    q=qij(i-1,j,s)+s+1;
else
    q=qij(i-1,j,s)-s;
end