function [ p_trans ] = create_patient_mesh( theta, new_grid,...
    M, Mass  )
%create_patient_mesh creates the patient-specific mesh
% -- INPUT:
% -- theta is the file .mat containing the transformation data;
% -- new_grid is the struct containing the informations on the mesh
% -- M is the max size of the image;
% -- Mass is the mass matrix associated to the mesh.
% -- 
% -- OUTPUT:
% -- p_tran is the matrix containing the x- and y-informations of the
%       transformed mesh.

p_trans = mesh_transf(new_grid, theta, Mass)*M;
p_trans = flip_mesh(p_trans);

end

