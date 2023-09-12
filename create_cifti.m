function make_cifti(cls_path,save_path,wb_path)
%input cls path w .mat file, and save_path with .dscalar.nii
%wb_path='/usr/local/connectome-workbench/1.3.2/bin_rh_linux64/wb_command';
load(cls_path);

%addpath ~/matlab/gifti-master

cifti = ciftiopen('OtherFiles/cifti_temp.dscalar.nii',wb_path);

if exist('i_cls')==1
cifti.cdata(1:91282)=zeros(91282,1);
cifti.cdata(1:length(i_cls))=single(i_cls);
end

if exist('cls')==1
cifti.cdata(1:91282)=zeros(91282,1);
cifti.cdata(1:length(cls))=single(cls);
end

if exist('i_cls_smooth_retest')==1
cifti.cdata(1:91282)=zeros(91282,1);
cifti.cdata(1:length(i_cls_smooth_retest))=single(i_cls_smooth_retest);
end

if exist('i_cls_smooth')==1
cifti.cdata(1:91282)=zeros(91282,1);
cifti.cdata(1:length(i_cls_smooth))=single(i_cls_smooth);
end

if exist('k_mask')==1
cifti.cdata(1:91282)=zeros(91282,1);
cifti.cdata(1:length(k_mask))=single(k_mask);
end

if exist('match_mask')==1
cifti.cdata(1:91282)=zeros(91282,1);
cifti.cdata(1:length(match_mask))=single(match_mask);
end

if exist('group_mask')==1
cifti.cdata(1:91282)=zeros(91282,1);
cifti.cdata(1:length(group_mask))=single(group_mask);
end

if exist('rs_fROI')==1
cifti.cdata(1:91282)=zeros(91282,1);
cifti.cdata(1:length(rs_fROI))=single(rs_fROI);
end


ciftisavereset(cifti,save_path,wb_path);
