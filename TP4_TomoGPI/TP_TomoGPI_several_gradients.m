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


[g_real,rsb_in]=addNoise(iter,g_real);
file_name=sprintf('%s/P_ER_GPU_NOISE_%2.1fdB.s',iter.workdirectory,rsb_in);
fid = fopen(file_name, 'wb');
fwrite(fid,g_real ,'float');
fclose(fid);

file_name=sprintf('%s/FDK_NOISE_%2.1fdB.v',iter.workdirectory,rsb_in);
fid = fopen(file_name, 'rb');
f_FDK_32=fread(fid,N*N*N ,'float');
f_FDK_32=reshape(f_FDK_32,N,N,N);
fclose(fid);
 
  
    
% RECONSTRUCTION ITERATIVE MOINDRE CARRE AVEC REGULARISATION QUADRATIQUE
setPositivity(iter,1);
setLambda(iter,100);
  l1=getLambda(iter);
f1_32=CreateVolumeInit(iter);
title1_32='lambda 100 P 32';
doGradient(iter,f1_32,g_real,f_real);

setLambda(iter,0.1);
  l2=getLambda(iter);
f2_32=CreateVolumeInit(iter);
title2_32='lambda 0.1 P 32';
doGradient(iter,f2_32,g_real,f_real);


setLambda(iter,0);
  l3=getLambda(iter);
f3_32=CreateVolumeInit(iter);
title3_32='lambda 0 P 32';
doGradient(iter,f3_32,g_real,f_real);


figure(11);
plot(f1_32(:,N/2,N/2),'b','LineWidth',1.5,'Marker','+');hold on;
plot(f2_32(:,N/2,N/2),'g','LineWidth',1.5,'Marker','x');hold on;
plot(f3_32(:,N/2,N/2),'c','LineWidth',1.5,'Marker','*');hold on;
plot(f_real(:,N/2,N/2),'k','LineWidth',1.5);hold on;
plot(f_FDK_32(:,N/2,N/2),'r','LineWidth',1.5,'Marker','o');hold on;
legend(title1_32,title2_32,title3_32,'real','fdk');
%legend(title1_32,'real','fdk');
 

figure(12);
imagesc(f_real(:,:,N/2));title('real');colorbar;colormap(gray);drawnow;
figure(13);
imagesc(f1_32(:,:,N/2));title(title1_32);colorbar;colormap(gray);drawnow;
figure(14);
imagesc(f_FDK_32(:,:,N/2));title('FDK');colorbar;colormap(gray);drawnow;
figure(15);
imagesc(f2_32(:,:,N/2));title(title2_32);colorbar;colormap(gray);drawnow;
figure(16);
imagesc(f3_32(:,:,N/2));title(title3_32);colorbar;colormap(gray);drawnow;



