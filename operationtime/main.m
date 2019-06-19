clc
clear
%�ĵ�UTM����,��λΪm
A=[463038.86,4454621.79];
B=[463037.22,4454330.48];
C=[463446.38,4454281.11];
D=[463462.55,4454578.43];
I=3;%������
r=3;%ת��뾶�����ڵ�ͷ�����
v=[4.8,5,7.2];%��ҵ�ٶȣ�km/h
W=[1.5,2.5,2.5];%ÿ������ķ���
M=[3,6,5];%ÿ�������ũ����
S=3;%��������������
BL=2*S+1;%����������
B1=ProjPoint(B,A,D);
B2=B-B1+A;
Bnew=LineFocus(B,C,A,B2);
Dnew=ProjPoint(C,A,D);
l_ADnew=Linelength(A,Dnew);
figure
plot ([A(1),B(1),C(1),D(1),A(1)],[A(2),B(2),C(2),D(2),A(2)])%ԭ�ؿ�
hold on
plot ([A(1),Bnew(1),C(1),Dnew(1),A(1)],[A(2),Bnew(2),C(2),Dnew(2),A(2)])%�����εؿ�
N=ones(I);
N_all=0;
for i=1:I%i�ǹ����
    N(i)=fix(l_ADnew/W(i)); %ÿ�������������
    N_all=N_all+N(i);%��������
end
StripInfo=zeros();
for i=1:I%i�ǹ����
    figure
    plot ([A(1),Bnew(1),C(1),Dnew(1),A(1)],[A(2),Bnew(2),C(2),Dnew(2),A(2)])%�����εؿ�
    axis equal
    hold on
    a0=A;
    b0=Bnew;
    StripInfo=zeros(N(i),24);
    NB=fix(N(i)/BL);%����������
    K=fix(NB/M(i));%ũ����С��ҵ������
    U=mod(NB,M(i));%ʣ��������(������������)
    for j=1:N(i)%j��������
        a00=(b0-a0)*(r/Linelength(a0,b0))+a0;
        b00=(a0-b0)*(r/Linelength(a0,b0))+b0;
        c00=(Dnew-A)*(W(i)/l_ADnew)+b00;
        d00=(Dnew-A)*(W(i)/l_ADnew)+a00;
        ad00=(d00-a00)/2+a00;%a00��d00���е㣬�������յ�
        bc00=(c00-b00)/2+b00;%b00��c00���е㣬�������յ�
        d0=(Dnew-A)*(W(i)/l_ADnew)*j+A;
        c0=LineFocus(d0,Bnew-A+d0,B,C);
        lab=Linelength(a00,b00);%ÿ��������ҵ���ȣ�m
        area=lab*W(i);
        %������ţ�������ҵ���ȣ���ҵ����������������꣨4������=8�����ݣ�����ҵ���������꣨4������=8�����ݣ������յ����꣨2������=4�����ݣ�
        StripInfo(j,:)=[j,W(i),lab,area,a0(1),a0(2),b0(1),b0(2),c0(1),c0(2),d0(1),d0(2),a00(1),a00(2),b00(1),b00(2),c00(1),c00(2),d00(1),d00(2),ad00(1),ad00(2),bc00(1),bc00(2)];     
        plot([a0(1),b0(1)],[a0(2),b0(2)],'k--')
        plot([a00(1),b00(1),c00(1),d00(1),a00(1)],[a00(2),b00(2),c00(2),d00(2),a00(2)],'b')
        hold on               
        a0=d0;
        b0=c0;
    end
    eval(['StripInfo',num2str(i),'=','StripInfo;']);
    figure
    plot ([A(1),Bnew(1),C(1),Dnew(1),A(1)],[A(2),Bnew(2),C(2),Dnew(2),A(2)])%�����εؿ�
    axis equal
    hold on
    bkk=0;
    for mm=1:M(i)%mmΪ�ù���ũ����
        if mm<=U %kkΪ��ũ����ҵ������
            kk=K+1;
        else
            kk=K;
        end
        row=zeros(1,kk*BL);
        for jj=1:kk
            for ii=1:BL
                row((jj-1)*BL+ii)=qij(ii,jj,S)+bkk*BL;
            end
        end
        bkk=bkk+kk;
        if N(i)-NB*BL~=0
            By=N(i)-NB*BL;%ʣ��������
            sy=fix((By-1)/2);%ʣ������������
            rowy=zeros(1,By);
            for mos=1:By-1
                rowy(mos)=qij(mos,1,sy)+NB*BL;
            end
            if mod(By,2)==0
                rowy(By)=N(i);
            else
                rowy(By)=qij(By,1,sy)+NB*BL;
            end
        else
            rowy=[];
        end
        if mm==M(i)
            rowb=zeros(1,length(row)+length(rowy));
            rowb(1:length(row))=row;
            rowb(length(row)+1:end)=rowy;
        else
            rowb=row;
        end
        eval(['row',num2str(i),num2str(mm),'=','rowb;']);
        t_all{i,mm}=TimeSingleTractor(rowb,StripInfo,v(i));
        switch mm
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
        for tdsxh=1:length(rowb)%tdsxhΪ����˳��� 
            td=rowb(tdsxh);
            if mod(tdsxh,2)==0
                Dot_x=[StripInfo(td,21),(StripInfo(td,21)+StripInfo(td,23))/2,StripInfo(td,23)];
                Dot_y=[StripInfo(td,22),(StripInfo(td,22)+StripInfo(td,24))/2,StripInfo(td,24)];
                dot=[sss,'v-'];
            else
                Dot_x=[StripInfo(td,23),(StripInfo(td,21)+StripInfo(td,23))/2,StripInfo(td,21)];
                Dot_y=[StripInfo(td,24),(StripInfo(td,22)+StripInfo(td,24))/2,StripInfo(td,22)];
                dot=[sss,'^-'];
            end
            plot(Dot_x,Dot_y,dot)
            axis equal
            hold on
        end         
    end   
end

function l=Linelength(A,B)
l=sqrt((B(2)-A(2))^2+(B(1)-A(1))^2);
end
function t=TimeSingleTractor(row,StripInfo,v)%����ÿ��ũ���Ĺ���ʱ��
t=0;
for i=1:length(row)
    if i==1
        s_m=0;
    else
        s_m=abs(row(i)-row(i-1));%��������֮��
    end
    switch s_m
        case {0}
            ts=0;
        case {1}
            ts=36;
        case {2}
            ts=33;
        case {3}
            ts=37;
        case {4}
            ts=28;
        case {5}
            ts=40;
        case {6}
            ts=47;
    end
    tw=StripInfo(i,3)/(v/3.6);
    t=t+tw+ts;    
end
end