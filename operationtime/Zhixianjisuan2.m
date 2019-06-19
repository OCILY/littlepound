clc
clear
%四点UTM坐标,单位为m
A=[463038.86,4454621.79];
B=[463037.22,4454330.48];
C=[463446.38,4454281.11];
D=[463462.55,4454578.43];
I=3;%工序数
r=3;%转弯半径，等于掉头区宽度
v=7;%作业速度，km/h
W=[1.5,2.5,2.5];%每个工序的幅宽
M=[3,6,5];%每个工序的农机数
S=3;%最优跳过条带数
BL=2*S+1;%区块条带数
B1=ProjPoint(B,A,D);
B2=B-B1+A;
Bnew=LineFocus(B,C,A,B2);
Dnew=ProjPoint(C,A,D);
l_ADnew=length(A,Dnew);
figure
plot ([A(1),B(1),C(1),D(1),A(1)],[A(2),B(2),C(2),D(2),A(2)])%原地块
hold on
plot ([A(1),Bnew(1),C(1),Dnew(1),A(1)],[A(2),Bnew(2),C(2),Dnew(2),A(2)])%新梯形地块
N=ones(I);
N_all=0;
for i=1:I%i是工序号
    N(i)=fix(l_ADnew/W(i)); %每个工序的条带数
    N_all=N_all+N(i);%总条带数
end
StripInfo=zeros();
for i=1:I%i是工序号
    figure
    plot ([A(1),Bnew(1),C(1),Dnew(1),A(1)],[A(2),Bnew(2),C(2),Dnew(2),A(2)])%新梯形地块
    axis equal
    hold on
    a0=A;
    b0=Bnew;
    StripInfo=zeros(N(i),24);
    NB=fix(N(i)/BL);%基本区块数
    K=fix(NB/M(i));%农机最小作业区块数
    U=mod(NB,M(i))+1;%剩余区块数(含特殊区块)
    for j=1:N(i)%j是条带号
        a00=(b0-a0)*(r/length(a0,b0))+a0;
        b00=(a0-b0)*(r/length(a0,b0))+b0;
        c00=(Dnew-A)*(W(i)/l_ADnew)+b00;
        d00=(Dnew-A)*(W(i)/l_ADnew)+a00;
        ad00=(d00-a00)/2+a00;%a00、d00的中点，条带起终点
        bc00=(c00-b00)/2+b00;%b00、c00的中点，条带起终点
        d0=(Dnew-A)*(W(i)/l_ADnew)*j+A;
        c0=LineFocus(d0,Bnew-A+d0,B,C);
        lab=length(a00,b00);%每个条带作业长度，m
        area=lab*W(i);
        %条带序号，幅宽、作业长度，作业面积，条带顶点坐标（4个坐标=8个数据），作业区顶点坐标（4个坐标=8个数据），起终点坐标（2个坐标=4个数据）
        StripInfo(j,:)=[j,W(i),lab,area,a0(1),a0(2),b0(1),b0(2),c0(1),c0(2),d0(1),d0(2),a00(1),a00(2),b00(1),b00(2),c00(1),c00(2),d00(1),d00(2),ad00(1),ad00(2),bc00(1),bc00(2)];
        
        nBL=ceil(j/BL);%每个条带的区块号
        if nBL>NB
            nN=mod(N(i),BL);%nN为该区块的条带数
        else
            nN=BL;
        end
        nBLin=j-(nBL-1)*BL;%每个条带在区块内的编号
        if nBLin<=ceil(nN/2)
            Nub=2*nBLin-1;%Nub为区块内部的条带顺序号
        else
            Nub=[nBLin-ceil(nN/2)]*2;
        end
        if ceil(nBL/(K+1))<=U  %ntra为农机号,iBL为区块顺序号
            ntra=ceil(nBL/(K+1));
            iBL=mod(nBL,K+1);
        else
            ntra=ceil((nBL-U*(K+1))/K)+U;
            iBL=mod(nBL-U*(K+1),K);
        end
        nus=Nub+BL*(iBL-1);%nus为条带顺序号
        switch ntra
            case {1}
                sss='c';
            case {2}
                sss='m';
            case {3}
                sss='y';
            case {4}
                sss='r';
            case {5}
                sss='g';
            case {6}
                sss='b';
        end
        switch mod(nus,2)
            case {1}
                dot='k^';
            case {0}
                dot='kv';
        end
        
        plot([a0(1),b0(1)],[a0(2),b0(2)],'k--')
        plot([a00(1),b00(1),c00(1),d00(1),a00(1)],[a00(2),b00(2),c00(2),d00(2),a00(2)],sss)
        plot([ad00(1),bc00(1)],[ad00(2),bc00(2)],dot,'linewidth',2)
        hold on
                       
        a0=d0;
        b0=c0;
    end

    eval(['StripInfo',num2str(i),'=','StripInfo;']);
end
function l=length(A,B)
l=sqrt((B(2)-A(2))^2+(B(1)-A(1))^2);
end