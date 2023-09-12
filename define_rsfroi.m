function define_rsfroi(subj,wb_path)

if ~exist([subj, '/rsfROIs'], 'dir')
       mkdir([subj, '/rsfROIs'])
end
    
load('group_klist.mat');
load('contrasts.mat')
load('top_networks.mat')

for count=1:length(klist)
    k_num=klist(count);
    k=num2str(k_num);
    contrast=contrasts(count);
    
    top_network=top_networks(count);

    parcellation_path=[subj '/Parcellations/subj_' subj '_k' k '.mat'];

    parcellation=load(parcellation_path);

    parcellation=parcellation.i_cls_smooth;

    network_mask=zeros(91282,1);
    network_mask(1:length(parcellation))=single(parcellation==top_network);

    ss_path=['SearchSpaces/' char(contrast) '_SS.dscalar.nii'];
    ss = ciftiopen(ss_path,wb_path);
    ss=ss.cdata;
    
    rs_fROI=network_mask;
    
    rs_fROI(find(ss ~= 1))=0;
    
    if sum(rs_fROI)==0
        rs_fROI=ss;
    end

    save_path=[subj '/rsfROIs/' subj '_' char(contrast) 'rsfROI.mat'];
    save(save_path,'rs_fROI')
    
    data_path=save_path;
    cifti_path=[subj '/rsfROIs/' subj '_' char(contrast) 'rsfROI.dscalar.nii'];
    create_cifti(data_path,cifti_path,wb_path);



end 