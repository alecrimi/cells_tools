
folders_list={'AB-old','AB-young','LCP-old','LCP-young','BACE1-old','BACE1-young'}; %

%list = dir([folder '/*.tif']);

datapoints =  zeros(29*2, 5250  );     %58464  69564  5250

%sorting = {'default'};
sorting = {'max_proj'};

%For all sorting
for ss = 1 : length(sorting)
     alg = sorting{ss};
%{
    if( strcmp(alg,'max_proj'))
       datapoints =  zeros(length(list),  5250 );     %58464  69564
    else
       datapoints =  zeros(length(list),  58464 );     %58464  69564 
    end
%}

%For all channels
    for channel = 2 : 2
    count = 1;
      for ll = 1 : length(folders_list)
          ll
        %All Cases
        list = dir(strcat(folders_list{ll},'/treated'));
        for k = 3 : length(list) %Skiup empty folder
           

            if( strcmp(alg,'max_proj'))
                  datapoints(count,:) =  load_tiff_maxproj( strcat(folders_list{ll}, '/treated/' ,list(k).name,'/whole/cells_heatmap_15px.tif'),channel) ;
            else
                  datapoints(count,:) =  load_tiff( strcat(folders_list{ll}, '/treated/' ,list(k).name,'/whole/cells_heatmap_15px.tif'),channel) ;
            end
            count = count + 1;
        end
        
        %All Control
        list = dir(strcat(folders_list{ll},'/CTRL'));
        for k = 3 : length(list) %Skiup empty folder
           

            if( strcmp(alg,'max_proj'))
                  datapoints(count,:) =  load_tiff_maxproj( strcat(folders_list{ll}, '/CTRL/' ,list(k).name,'/whole/cells_heatmap_15px.tif'),channel) ;
            else
                  datapoints(count,:) =  load_tiff( strcat(folders_list{ll}, '/CTRL/' ,list(k).name,'/whole/cells_heatmap_15px.tif'),channel) ;
            end
            count = count + 1;
        end
        
        
      end
        %{
        %Center mean
        %Compute cov matrix
        covmat = cov(datapoints);
        %Eigendecomposition covmatrix
        [V,D] = eig(covmat);
        %Project using only the first 2 vector
        score = V(:,1:2)'*datapoints';
        figure
        hold on
        plot(score(1,1:3),score(2,1:3),'b*')
        plot(score(1,4:11),score(2,4:11),'g*')
        plot(score(1,12:16),score(2,12:16),'r*')
        plot(score(1,17:19),score(2,17:19),'y*')
        plot(score(1,20:23),score(2,20:23),'k*')
        plot(score(1,24:30),score(2,24:30),'m*')
        hold off
        box on
        xlabel('First component')
        ylabel('Second component')
        lgd = legend(list(1).name,list(2).name,list(3).name,list(4).name,list(5).name,list(6).name);
        saveas(gcf,['PCA_val_'  folder '_ch' num2str(channel) '_sorting' alg '.png'])
      %}
   
        score = tsne(datapoints,'Algorithm','exact','Distance','euclidean','Perplexity',5);
        score = score';
        figure
        hold on
        plot(score(1,1:3),score(2,1:3),'b*')
        plot(score(1,4:11),score(2,4:11),'g*')
        plot(score(1,12:15),score(2,12:15),'r*')
        plot(score(1,16:22),score(2,16:22),'c*')
        plot(score(1,23:26),score(2,23:26),'k*')
        plot(score(1,27:29),score(2,27:29),'m*')
        
        plot(score(1,30:35),score(2,1:3),'bo')
        plot(score(1,36:39),score(2,4:11),'go')
        plot(score(1,40:43),score(2,12:15),'ro')
        plot(score(1,44:49),score(2,16:22),'co')
        plot(score(1,50:53),score(2,23:26),'ko')
        plot(score(1,54:58),score(2,27:29),'mo')
        
        
        hold off
        box on
        xlabel('First component')
        ylabel('Second component')
        lgd = legend(folders_list{1},folders_list{2},folders_list{3},folders_list{4},folders_list{5},folders_list{6});
        saveas(gcf,['TNSE_val_mean_ch' num2str(channel) '_sorting' alg '.png'])
  
    end
end