clear all
close all
clc

load transformation.mat %load the transformation
load bone_mesh_flip.mat %load the mesh

pic_bones = imread('sqrad_flip.jpg'); %load the atlas image
pic_bones_t = imread('sqradtr_flip.jpg'); %load the patient image

pb_flip = flip_mesh(pb); %First flipping (this should be fixed maybe in the future)

M = max(size(pic_bones)); %size of the atlas image

%define the space for the creation of the mass matric
global spazio 
spazio = uniform2d(2,2); %Here one can play with the input variables

%create the base
base = start(3,9); %Here one can play with the input variables

[Mass, new_grid] = create_massgrid(pb_flip, base, M); %Creation of Mass and new grid
                                                      %associated to the
                                                      %image.

pb_trans = create_patient_mesh(a1, new_grid, M, Mass); %Transformation of the mesh.
%% Plotting of the images
figure()
subplot(121)
imshow(flipud(pic_bones))
hold on
for ie = 1:max(size(tb))
    ka = tb(1,ie);
    kb = tb(2,ie);
    kc = tb(3,ie);
    plot(pb(1,[ka,kb]),pb(2,[ka,kb]),'r-','LineWidth',.5);
    plot(pb(1,[ka,kc]),pb(2,[ka,kc]),'r-','LineWidth',.5);
    plot(pb(1,[kc,kb]),pb(2,[kc,kb]),'r-','LineWidth',.5);
end
title('Reference')
subplot(122)
imshow(flipud(pic_bones_t))
hold on
for ie = 1:max(size(tb))
    ka = tb(1,ie);
    kb = tb(2,ie);
    kc = tb(3,ie);
    plot(pb_trans(1,[ka,kb]),pb_trans(2,[ka,kb]),'r-','LineWidth',.5);
    plot(pb_trans(1,[ka,kc]),pb_trans(2,[ka,kc]),'r-','LineWidth',.5);
    plot(pb_trans(1,[kc,kb]),pb_trans(2,[kc,kb]),'r-','LineWidth',.5);
end
title('Patient')
