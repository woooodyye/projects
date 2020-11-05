%  need to global and local separation
% 
% stack_dir = "global/stack_2/";
% stack_1 = dir(fullfile(stack_dir,"*.jpg"));
% n = length(stack_1);
% 
% imgs = []
% for i  = 1:n
%     img = fullfile(stack_dir,stack_1(i).name);
%     imgs = cat(1,imgs,img);
% end
% function result = gl_sep(crf)
% range = 0:length(crf)-1;
% figure,
% hold on
% plot(crf(:,1),range,'--r','LineWidth',2);
% plot(crf(:,2),range,'-.g','LineWidth',2);
% plot(crf(:,3),range,'-.b','LineWidth',2);
% xlabel('Log-Exposure');
% ylabel('Image Intensity');
% title('Camera Response Function');
% grid on
% axis('tight')
% legend('R-component','G-component','B-component','Location','southeast')
% end

function [d,g] = gl_sep(img_stack)

    img_max = max(img_stack,[],3);
    
    img_min = min(img_stack,[],3);
    
    d = img_max - img_min;
    
    g = img_min;
end