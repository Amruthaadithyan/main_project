%Database reader
clc
close all;
clear all;

srcFiles =dir('RETINAL IMAGES');
for j = 3 : length(srcFiles)   %count strts from 3 because initial two values are error(. , ..)     disp(srcFiles(j).name);
   
%     type=str2num(srcFiles(j).name);
     type=num2str(srcFiles(j).name);
    classfolder = strcat('RETINAL IMAGES/',srcFiles(j).name);
    
    imagefiles =dir(classfolder);
    for i = 3 : length(imagefiles)
        filename=strcat(strcat(classfolder,'/'),imagefiles(i).name);
        disp(filename);
        Retinal_Img=imread(filename);
        Retinal_Img=imresize(Retinal_Img,[300 300]);      
        imshow(Retinal_Img);
        
        pause(2);
    end
end
