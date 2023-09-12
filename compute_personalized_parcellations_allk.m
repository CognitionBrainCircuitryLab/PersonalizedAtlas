function compute_personalized_parcellations_allk(subj)

%% load subject files 
mat=matfile([subj '/' subj '_connectome.mat']);

%% make folder to save out to, if needed 
if ~exist([subj, '/Parcellations'], 'dir')
       mkdir([subj, '/Parcellations'])
end

%% compute personalized parcellations for defining rs-fROIs 
distance='cosine';

%% compute all k from 2 to 200

for k_count=2:200
    
    k_num=k_count;
    k=num2str(k_num);
    
    save_path=[subj '/Parcellations/subj_' subj '_k' k '.mat'];
    
    if isfile(save_path)
        disp(['Personalized k = ' k  ' parcellation  for ' subj ' already exists'])
    else
        disp(['Calculating k = ' k ' ...' ])

% load group centroids
load(['GroupCentroids/group_centroids_k' k '.mat']);

% compute personalized solution using k-nearest neighbor 
%i_cls = kmeans(cortex,k_num,'Distance',distance,'Display','iter','MaxIter',1,'Start',C); 
tic
i_cls = kmeans(mat.cortex,k_num,'Distance',distance,'Display','iter','MaxIter',1,'Start',C); 
toc %took 4.2 min

% smooth 
i_cls_smooth = smooth_parcellation(i_cls,k_num);
  %% save

 save(save_path,'i_cls_smooth','-v7.3');
    end 
end
end
