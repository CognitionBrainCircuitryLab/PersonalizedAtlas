function compute_personalized_parcellations_k7(subj,wb_path)

%% load subject files 
mat=load([subj '/' subj '_connectome.mat']);
warning('off','stats:kmeans:FailedToConverge');
%% make folder to save out to, if needed 
if ~exist([subj, '/Parcellations'], 'dir')
       mkdir([subj, '/Parcellations'])
end

%% compute personalized parcellations for defining rs-fROIs 
distance='cosine';

%% compute k=7 personalized parcellation

    
    k_num=7;
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
i_cls = kmeans(mat.cortex,k_num,'Distance',distance,'MaxIter',1,'Start',C);
toc %took 5.17 min

% final 
i_cls_final = refine_parcellation(i_cls,k_num);
  %% save

 save(save_path,'i_cls_final','-v7.3');
    end 

    data_path=save_path;
    cifti_path=[subj '/Parcellations/' subj '_k7.dscalar.nii'];
    create_cifti(data_path,cifti_path,wb_path);

warning('on','stats:kmeans:FailedToConverge');
end
