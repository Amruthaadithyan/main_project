%database reader
clc
close all;
clear all;


[FileName,PathName]=uigetfile('*.jpg;*.bmp;*.png','INPUT RETINAL IMAGE ');
Retinal_Img = imread([PathName,FileName]);
Retinal_Img=imresize(Retinal_Img,[300 300]);
imshow(Retinal_Img);
figure;
Struct_Elmts = strel('disk',6);
eqimg=histeq(Retinal_Img(:,:,2));

imshow(eqimg);
figure;
Top_Hat_Transform = imtophat(eqimg,Struct_Elmts);
Top_Hat_Transform = histeq(Top_Hat_Transform);


bw=im2bw(Top_Hat_Transform,.9);

bwComplement = imcomplement(bw);



Bottom_Hat_Transform = imbothat(eqimg,Struct_Elmts);
Bottom_Hat_Transform = histeq(Bottom_Hat_Transform);


bw=im2bw(Bottom_Hat_Transform,.9);


bwComplement = imcomplement(bw);



Top_Bottom_Hat_Transform=imsubtract(Top_Hat_Transform,Bottom_Hat_Transform);
Output_Img = Top_Bottom_Hat_Transform;
Top_Bottom_Hat_Transform = histeq(Top_Bottom_Hat_Transform);

bw=im2bw(Top_Bottom_Hat_Transform,.9);
imshow(bw);
figure;
%
% FEATURE EXTRACTION

% Lumiance feature: The clearness of the retinal image is the standard for cataract
% classification, so the lumiance is selected as a feature for classification. This
% feature is extracted from the image which has been wiped off personal message.
% Then the image is converted to a binary image and the threshold is 0.6. The lumiance
% feature is how much the white pixel share in the image.
New_Img = im2bw(Top_Bottom_Hat_Transform,0.6);

White_Index = find(New_Img==1);
Luminance = length(White_Index);

% Gray co-occurrence matrix: Gray cooccurrence matrix is selected to do the job of feature
% extraction. This matrix provides the gloal message of the image. For example, angular
% second moment feature is a mesure of homogenity of the image, and contrast is a measure
% of constrast of the image. From the gray occurrence matrix, we extract 24 features from
% the degree of 0, 45, 90, and 135 angular second moment, correlation, entropy, contrast,
% inverse difference moment and sum of squares. Image after pre-processing is transformed
% from 256 gray levels to 8 levels. It computes much quicker than the image before
% transformed. Then these features in gray co-occurrence matrix are extracted.
offsets = [0 1; -1 1;-1 0;-1 -1];
glcm = graycomatrix(Top_Bottom_Hat_Transform,'Offset',offsets,'NumLevels',8);
Angle_0   = glcm(:,:,1); Angle_0   = Angle_0(:)  ; Angle_0   = Angle_0(1:24)  ; Angle_0   = Angle_0'  ;
Angle_45  = glcm(:,:,2); Angle_45  = Angle_45(:) ; Angle_45  = Angle_45(1:24) ; Angle_45  = Angle_45' ;
Angle_90  = glcm(:,:,3); Angle_90  = Angle_90(:) ; Angle_90  = Angle_90(1:24) ; Angle_90  = Angle_90' ;
Angle_135 = glcm(:,:,4); Angle_135 = Angle_135(:); Angle_135 = Angle_135(1:24); Angle_135 = Angle_135';
stats = graycoprops(glcm);
Contrast    = stats.Contrast   ;
Correlation = stats.Correlation;
Energy      = stats.Energy     ;
Homogeneity = stats.Homogeneity;
E = entropy(Top_Bottom_Hat_Transform);
FMatrix = [Luminance,Angle_0,Angle_45,Angle_90,Angle_135,Contrast,Correlation,Energy,Homogeneity,E];
X=[];
X=double(FMatrix(:,:));
load normalsevereSVM.mat
type=svmclassify(svmStruct1,X)


