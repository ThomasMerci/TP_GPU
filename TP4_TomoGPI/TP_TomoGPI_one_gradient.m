clear all;close all;
N=128;
P=128;
rep_name=['Projections_',num2str(P),'/'];
iter = Iter3D(rep_name); % Create a class instance

iter.save_file=1;
iter.save_volume=2;
iter.fc=1.0;%frequence de coupure pour filtre de rétroporjection filtrée

f_real=CreateVolumeReal(iter);
g_real=getSinoReal(iter);

f_estimated=CreateVolumeInit(iter);
normdJProjReg=CreateVolumeInit(iter);

[g_real,rsb_in]=addNoise(iter,g_real);
file_name=sprintf('%s/P_ER_GPU_NOISE_%2.1fdB.s',iter.workdirectory,rsb_in);
fid = fopen(file_name, 'wb');
fwrite(fid,g_real ,'float');
fclose(fid);

%temp=zeros(size(f_real));%doLaplacian(iter,f_real,temp);%figure(2);imagesc(temp(:,:,N/2));title('laplacien df');colorbar;colormap(gray);drawnow;%figure(3);imagesc(f_real(:,:,N/2));title('f_real');colorbar;colormap(gray);drawnow;

% disp('****************************')
% disp('Descente de gradient... ')
% disp('****************************')

f_estimated_n=f_estimated;
for num_iter_gradient_n=1:1:getGradientIterationNb(iter)
    fprintf("iter = %d\n",num_iter_gradient_n);
    iter.num_iter=num_iter_gradient_n;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % CALCUL DES J et dJ
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %g=H*f
    g_estimated=doProjection(iter,f_estimated_n);%figure(4);imagesc(g_estimated(:,:,N/2));title('g_estimated');colorbar;colormap(gray);drawnow;
    dg=g_real-g_estimated;%figure(5);imagesc(g_real(:,:,N/2));title('g_real');colorbar;colormap(gray);drawnow;%figure(6);imagesc(dg(:,:,N/2));title('dg');colorbar;colormap(gray);drawnow;
    
    %df=Ht*(g-Hf)
    df=doBackprojection(iter,dg);%figure(7);imagesc(df(:,:,N/2));title('df');colorbar;colormap(gray);drawnow;
    
    %dJ=-2*Ht*(g-Hf)
    dJ_MC=-2*df;
    dJ=dJ_MC;
    
    %dJ+=Dt*D*f  avec D laplacien
    %J_reg=0;
    %ApplyLaplacianRegularization_to_dJ(iter,f_estimated_n,dJ,getLambda(iter),J_reg,normdJProjReg,getGradientIterationNb(iter),getOptimalStepIterationNb(iter));
    %dJ_reg=zeros(size(dJ)); temp=zeros(size(dJ));%doLaplacian(iter,f_estimated_n,temp);%doLaplacian(iter,temp,dJ_reg);clear temp;
    %dJ=dJ+2*dJ_reg;
    %dJ_reg=dJ-dJ_MC;figure(8);imagesc(dJ_reg(:,:,N/2));title('dJ reg');colorbar;colormap(gray);drawnow;%figure(9);imagesc(dg(:,:,N/2));title('dg');colorbar;colormap(gray);drawnow;
    
    %Gradient dJ mise à jour
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % CALCUL DU PAS
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    num_alpha=sum(dJ(:).^2);
    proj_dJ=doProjection(iter,dJ);
    denum_alpha=2*sum(proj_dJ(:).^2);
    clear proj_dJ;
    
    %SI REGULARISATION
    %if (getLambda(iter) ~= 0)
     %   s=zeros(size(dJ));
     %   doLaplacian(iter,dJ,s);
      %  s=sum(s(:).^2);
      %  denum_alpha=denum_alpha+getLambda(iter)*s;
    %end
    
    alpha=num_alpha/denum_alpha;
    
    %iter.alpha(iter.num_iter)=alpha; %figure(10);plot(iter.alpha);title('pas');xlabel('iter');ylabel('alpha');drawnow;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % MISE A JOUR DE f
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    f_estimated_n=f_estimated_n-alpha.*dJ;
    clear dJ;
    
    % SAUVEGARDE DU VOLUME RECONSTRUIT TOUS LES iter.save_file
    iter=sauvegarde_volume_TOMO8(f_estimated_n,f_real,iter);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %CALCUL DU CRITERE (FACULTATIF)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    J_MC=sum(dg(:).^2);
    iter.J(iter.num_iter)=J_MC;%+J_reg
    
    niter_done=size(iter.J,2);
    if (niter_done > 1)
        figure(11);plot(iter.J(2:niter_done));title('J');xlabel('iter');ylabel('J');drawnow;
    end
    figure(12);imagesc(f_estimated_n(:,:,N/2));title('gradient');colorbar;colormap(gray);drawnow;
end

%     disp('****************************')
%     disp('Descente de gradient OK !!!!')
%     disp('****************************')


figure(11);
plot(f_estimated_n(:,N/2,N/2),'b','LineWidth',1.5,'Marker','+');hold on;
plot(f_real(:,N/2,N/2),'k','LineWidth',1.5);hold on;
legend('gradient','real');


figure(13);
imagesc(f_real(:,:,N/2));title('real');colorbar;colormap(gray);drawnow;

