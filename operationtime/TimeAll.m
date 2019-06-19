function T_all=TimeAll[A,B,C,D,W,V,t_turn,I]
%ABCD四点从左上角开始，逆时针命名，作业方向为上下
l_AD=sqrt((D(2)-A(2))^2+(D(1)-A(1))^2);
for i=1:I
    N(i)=fix(L_AD/W(i));
end