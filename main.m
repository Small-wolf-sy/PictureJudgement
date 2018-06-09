%% 读取结果并存储
grades=xlsread('grades.xlsx');
grades=grades(:,2);%第一行为索引，第二行为结果
%% 读取图片并存储
TrainDatabasePath = uigetdir('.\datas\allpicture', 'Select training database path' );
img=cell(1,500);
graImg=cell(1,500);
for i=1:1:500
    index=int2str(i);
    str = strcat(TrainDatabasePath,'\SCUT-FBP-',index,'.jpg');
    img{i}=imread(str);
    img{i}=imresize(img{i},[800,600]);
    graImg{i}=rgb2gray(img{i});
    subplot(1,2,1),imshow(img{i});
    title(grades(i),'fontsize',10);
    subplot(1,2,2),imshow(graImg{i});
    title(grades(i),'fontsize',10);
end
%% 
