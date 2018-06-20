rp = randperm(400);
row=200;
col=150;
for i = 1:length(rp)
    % Display
    index=int2str(rp(i));
    str = strcat(TrainDatabasePath,'\SCUT-FBP-',index,'.jpg');
    img=imread(str);
    
    img=imread(str);
    img=imresize(img,[row,col]);
    
    subplot(1,1,1),imshow(img);
    
    datas=ConvertTrainingData(:,rp(i));
    
    Y = sim( net , datas );
    [~ , Index] = max( Y) ;
    title(Index,'fontsize',10);
    s = input('Paused - press enter to continue, q to exit:','s');
    if s == 'q'
        break
    end
end