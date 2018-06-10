%% 读取结果并存储
grades=xlsread('grades.xlsx');
grades=grades(:,2);%第一行为索引，第二行为结果
%% 读取图片并存储
TrainDatabasePath = uigetdir('.\datas\allpicture', 'Select training database path' );
img=cell(1,500);
% graImg=cell(1,500);
row=200;
col=150;
graImg=zeros(row,col,500);
parfor i=1:1:500
    index=int2str(i);
    str = strcat(TrainDatabasePath,'\SCUT-FBP-',index,'.jpg');
    img{i}=imread(str);
    img{i}=imresize(img{i},[row,col]);
    graImg(:,:,i)=im2double(rgb2gray(img{i}));
%     subplot(1,2,1),imshow(img{i});
%     title(grades(i),'fontsize',10);
%     subplot(1,2,2),imshow(graImg(:,:,i));
%     title(grades(i),'fontsize',10);
end


m=400;

%划分出训练集和测试集,并将评分规整为整数
TrainingData=graImg(:,:,1:m);
TrainingResult=round(grades(1:m));

TestData=graImg(:,:,m+1:500);
TestResult=round(grades(m+1:500));


% save 'datas2.mat';
% % 读取数据
% clear all;clc;
% load('datas.mat');

%% 利用PCA把训练的数据处理完毕
M=mean(TrainingData,3);


%求图像散布矩阵Gt（总体散布矩阵）
Gt=zeros(col,col);
for i = 1 : m
    temp = TrainingData(:,:,i)-M;
    Gt =  Gt + temp'*temp;
end
Gt=Gt/m;
d = 25;
[V,~] = eigs(Gt,d);%求特征值和特征向量
%ＰＣＡ空间投影图像
V = orth(V); %求V的标准正交基
ProjectedImages = zeros(row,d);
%得到新的训练数据
ConvertTrainingData=zeros(row*d,m);
parfor i = 1 : m
    ProjectedImages(:,:,i) = TrainingData(:,:,i)*V;
    ConvertTrainingData(:,i)=reshape(ProjectedImages(:,:,i),[row*d,1])';
end

ConvertTrainingData=premnmx(ConvertTrainingData);

%% 根据得到的数据，以及相应的结果，进行神经网络处理

%构造输出矩阵
class=10;%一共五种评分
output=zeros(m,class);
for i=1:1:m
    output(i,TrainingResult(i))=1;
end
%创建神经网络
net = newff( minmax(ConvertTrainingData) , [d 10] , { 'logsig' 'purelin' } , 'traingdx' ) ;

%设置训练参数
net.trainparam.show = 50 ;
net.trainparam.epochs = 5000 ;
net.trainparam.goal = 0.0001 ;
net.trainParam.lr = 0.2 ;

%开始训练
%    The matrix format is as follows:
%      X  - RxQ matrix
%      Y  - UxQ matrix.
%    Where:
%      Q  = number of samples
%      R  = number of elements in the network's input
%      U  = number of elements in the network's output
net = train( net, ConvertTrainingData  , output' ) ;

save 'training.mat';

