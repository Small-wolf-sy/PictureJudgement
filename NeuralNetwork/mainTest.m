% load('training1.mat');
row=200;
col=150;
%% 将测试的数据集转变为神经网络形式
M=mean(TestData,3);

m=size(TestData,3);

%求图像散布矩阵Gt（总体散布矩阵）
Gt=zeros(col,col);
for i = 1 : m
    temp = TestData(:,:,i)-M;
    Gt =  Gt + temp'*temp;
end
Gt=Gt/m;
d = 20;
[V,~] = eigs(Gt,d);%求特征值和特征向量
%ＰＣＡ空间投影图像
V = orth(V); %求V的标准正交基
ProjectedImages = zeros(row,d);
%得到新的训练数据
ConvertTestData=zeros(row*d,m);
parfor i = 1 : m
    ProjectedImages(:,:,i) = TestData(:,:,i)*V;
    ConvertTestData(:,i)=reshape(ProjectedImages(:,:,i),[row*d,1])';
end
ConvertTestData=premnmx(ConvertTestData);
%构造输出矩阵
class=5;%一共五种评分
output=zeros(m,class);
for i=1:1:m
    output(i,TestResult(i))=1;
end
%% 仿真运算
Y = sim( net , ConvertTestData );
%统计识别正确率

%output为相应的m*5，因此y也要为m*5
Y=Y';%得到m*5个结果
hitNum = 0 ;
for i=1:1:m
    [~ , Index] = max( Y( i ,  : ) ) ;
    if output(i,Index)==1
        hitNum = hitNum + 1 ;
    end
end
sprintf('识别率是 %3.3f%%',100 * hitNum / m )


