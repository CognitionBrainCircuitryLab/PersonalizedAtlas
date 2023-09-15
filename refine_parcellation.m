function [i_cls_final] = refine_parcellation(i_cls,k_num)

% final
i_cls_final=i_cls; %just make the correct size

fid=fopen('OtherFiles/HCP_CIFTI_INDS.txt');
tmp=textscan(fid,'%f %f %s');
fclose(fid);
indsStart=tmp{1};
indsEnd=tmp{1}+tmp{2};
structure=tmp{3};

%% LEFT
groi=gifti('OtherFiles/100206.L.atlasroi.32k_fs_LR.shape.gii');
ciftiinds=find(groi.cdata);
medial_wall_inds=find(~groi.cdata);
ciftiindsL=find(groi.cdata);

g=gifti('OtherFiles/100206.L.inflated.32k_fs_LR.surf.gii');
facesL=g.faces;
verticesL=g.vertices;

%connL=zeros(size(verticesL,1),size(fc,2));
connL=zeros(size(verticesL,1),1); %to delete?
%connL(ciftiinds,:)=fc(indsStart(1)+1:indsEnd(1),:);
connL(ciftiinds,1)=i_cls(indsStart(1)+1:indsEnd(1));

%specify original data as preLeft
preleft=connL(:,1);

%% left final
  left_all=repmat(preleft,1,k_num);

 for iParc=1:k_num
    %disp(iParc)
parcinds=find(left_all(:,iParc)==iParc); %vertex inds of iParc
parcfaces=ismember(facesL,parcinds); %tf of which vertices within each face are in iParc


parcfaceborder=facesL(sum(parcfaces,2)==1,:); %face data of borders of iParc
parcvertexborders=parcfaceborder(parcfaces(sum(parcfaces,2)==1,:)); % individual vertices in borders of iParc

left_all(parcvertexborders,iParc)=0; %erode

parcinds=find(left_all(:,iParc)==iParc); %vertex inds of iParc
parcfaces=ismember(facesL,parcinds); %tf of which vertices within each face are in iParc
parcfaceborder=facesL(sum(parcfaces,2)==1,:); %face data of borders of iParc

left_all(parcfaceborder(:),iParc)=iParc; %dilate

n_inds(iParc)=length(find(left_all(:,iParc)==iParc));  
 end

 %sort from smallest to largest
[parcelSize,parcelIndex]=sort(n_inds);

%fill in from smallest to largest
final_left=repelem(0,32492);
final_left=transpose(final_left);
for iParc=parcelIndex
    final_left(final_left==0 & left_all(:,iParc)==iParc)=left_all(final_left==0 & left_all(:,iParc)==iParc,iParc);
end

%recalculate smallest to largest
[parcelSize,parcelIndex]=sort(n_inds);

%zero out medial wall

final_left(medial_wall_inds)=0;
 
 missing=find(~final_left);
 
 %dilate until there are no holes (other than medial wall)
 
while length(missing) > length(medial_wall_inds)
    %disp(length(missing));
    for iParc=parcelIndex
    parcinds=find(final_left==iParc); %vertex inds of iParc
    parcfaces=ismember(facesL,parcinds); %tf of which vertices within each face are in iParc
    parcfaceborder=facesL(sum(parcfaces,2)==1|sum(parcfaces,2)==2,:); %face data of borders of iParc
    final_left(intersect(missing,parcfaceborder(:)))=iParc; %dilate


    
    final_left(medial_wall_inds)=0;
    missing=find(~final_left);
    end
end

 i_cls_final(indsStart(1)+1:indsEnd(1))=final_left(ciftiindsL);

 %% RIGHT
groi=gifti('OtherFiles/100206.R.atlasroi.32k_fs_LR.shape.gii');
ciftiinds=find(groi.cdata);
ciftiindsR=find(groi.cdata);

medial_wall_inds=find(~groi.cdata);
g=gifti('OtherFiles/100206.R.inflated.32k_fs_LR.surf.gii');
facesR=g.faces;
verticesR=g.vertices;

%connR=zeros(size(verticesR,1),size(fc,2));
connR=zeros(size(verticesR,1),1); % to delete?
%connR(ciftiinds,:)=fc(indsStart(2)+1:indsEnd(2),:);
connR(ciftiinds,1)=i_cls(indsStart(2)+1:indsEnd(2));

preright=connR(:,1);

%% right final
  right_all=repmat(preright,1,k_num);

 for iParc=1:k_num
    %disp(iParc)
parcinds=find(right_all(:,iParc)==iParc); %vertex inds of iParc
parcfaces=ismember(facesR,parcinds); %tf of which vertices within each face are in iParc


parcfaceborder=facesR(sum(parcfaces,2)==1,:); %face data of borders of iParc
parcvertexborders=parcfaceborder(parcfaces(sum(parcfaces,2)==1,:)); % individual vertices in borders of iParc

right_all(parcvertexborders,iParc)=0; %erode

parcinds=find(right_all(:,iParc)==iParc); %vertex inds of iParc
parcfaces=ismember(facesR,parcinds); %tf of which vertices within each face are in iParc
parcfaceborder=facesR(sum(parcfaces,2)==1,:); %face data of borders of iParc

right_all(parcfaceborder(:),iParc)=iParc; %dilate

n_inds(iParc)=length(find(right_all(:,iParc)==iParc));  
 end
 
 %sort from smallest to largest
[parcelSize,parcelIndex]=sort(n_inds);

%fill in from smallest to largest
final_right=repelem(0,32492);
final_right=transpose(final_right);
for iParc=parcelIndex
    final_right(final_right==0 & right_all(:,iParc)==iParc)=right_all(final_right==0 & right_all(:,iParc)==iParc,iParc);
end

%recalculate smallest to largest
[parcelSize,parcelIndex]=sort(n_inds);

%zero out medial wall

final_right(medial_wall_inds)=0;
 
 missing=find(~final_right);
 
 %dilate until there are no holes (other than medial wall)
 
while length(missing) > length(medial_wall_inds)
    %disp(length(missing));
    for iParc=parcelIndex
    parcinds=find(final_right==iParc); %vertex inds of iParc
    parcfaces=ismember(facesR,parcinds); %tf of which vertices within each face are in iParc
    parcfaceborder=facesR(sum(parcfaces,2)==1|sum(parcfaces,2)==2,:); %face data of borders of iParc
    final_right(intersect(missing,parcfaceborder(:)))=iParc; %dilate


    
    final_right(medial_wall_inds)=0;
    missing=find(~final_right);
    end
end

 i_cls_final(indsStart(2)+1:indsEnd(2))=final_right(ciftiindsR);
end 
 %return i_cls_final