function q=qij(i,j,s)%i����С�����ڹ���˳��ţ�j�ǵ�ũ����������ţ�s��������������q�ǵ�ũ��������
if i==1
    q=(2*s+1)*(j-1)+1;
elseif mod(i,2)==0
    q=qij(i-1,j,s)+s+1;
else
    q=qij(i-1,j,s)-s;
end