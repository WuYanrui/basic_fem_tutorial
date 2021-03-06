function [u, A, b, freenodes] = fem_for_poisson_2d_rectangle_ex3(c4n, n4e, ...
    n4db, n4nb, ind4e, M_R, Srr_R, Sss_R, M_R1D, f, u_D, u_N)
% fem_for_poisson_2d_rectangle_ex3    FEM solver for Poisson problem in 2D with
%   rectangular elements
%
%   fem_for_poisson_2d_rectangle_ex3(c4n,n4e,n4db,n4nb,ind4e,M_R, ...
%   Srr_R,Sss_R,M_R1D,f,u_D,u_N) solves the Poisson problem. In order to
%   use this code, mesh information (c4n, n4e, n4db, ind4e), matrices (M_R,
%   Srr_R, Sss_R), the source f, and the boundary condition u_D. Then the
%   results of this code are the numerical solution u, the global stiffness 
%   matrix A, the global load vector b and the freenodes.
%
%   Parameters:
%     - c4n : coordinates for nodes.
%     - n4e : nodes for elements.
%     - n4db : nodes for Dirichlet boundary.
%     - n4nb : nodes for Neumann boundary.
%     - ind4e : indices for elements
%     - M_R : Mass matrix on the reference rectangle
%     - Srr_R : Stiffness matrix on the reference rectangle
%     - Sss_R : Stiffness matrix on the reference rectangle
%     - M_R1D : Mass matrix on the reference interval in 1D
%     - f : RHS in the Poisson problem
%     - u_D : Dirichlet boundary condition for the solution u
%     - u_N : Neumann boundary condition for the solution u
%
%   Returns:
%     - u : numerical solution
%     - A : Global stiffness matrix
%     - b : Global right-hand side
%     - freenodes : free nodes

number_of_nodes = size(c4n,1);
A = sparse(number_of_nodes, number_of_nodes);
b = zeros(number_of_nodes, 1);
u = b;
for j = 1:size(n4e,1)
    xr = (c4n(n4e(j,2),1)-c4n(n4e(j,1),1))/2;
    ys = (c4n(n4e(j,4),2)-c4n(n4e(j,1),2))/2;
    J = xr*ys;
    rx=ys/J; sy=xr/J;

    A(ind4e(j,:), ind4e(j,:)) = A(ind4e(j,:),ind4e(j,:)) ...
        + J*(rx^2*Srr_R + sy^2*Sss_R);
    b(ind4e(j,:)) = b(ind4e(j,:)) + J*M_R*f(c4n(ind4e(j,:),:));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TODO: Add a few lines to treat Neumann boundary condition.
% Hint: You can use Jacobian and Mass matrix in 1D.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

freenodes = setdiff(1:length(c4n), n4db);
u(n4db) = u_D(c4n(n4db,:));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TODO: Add a few lines to treat non-homogeneous Dirichlet boundary
% condition. If you finished Exercise 2, the following lines can be copied
% from fem_for_poisson_2d_rectangle_ex2.m

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

u(freenodes) = A(freenodes, freenodes)\b(freenodes);
end