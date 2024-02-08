% Filename: ora_foc_demo.m
% Demo for Oustaloup-Recursive-Approximation for fractional order differentiator
% Reference
% [1] Oustaloup, A.; Levron, F.; Mathieu, B.; Nanot, F.M.; "Frequency-band 
%     complex noninteger differentiator: characterization and synthesis". 
%     EEE Transactions on Circuits and Systems I: Fundamental Theory and 
%     Applications, I , Volume: 47 Issue: 1, Jan. 2000, Page(s): 25 -39
% [2] D. Xue, Y.Q. Chen and D. Atherton. "Linear feedback control - 
%     analysis and design with Matlab 6.5". Textbook draft. Chapter 9
%     "Fractional order control - An introduction". PDF available upon
%     request. Send request email to "yqchen@ieee.org".
% by YangQuan Chen. Nov. 2001. 
% Utah State University. http://www.csois.usu.edu/people/yqchen/
% FOC web http://mechatronics.ece.usu.edu/foc/
close all;clear all
w_L=0.1;w_H=1000;        % frequency of practical interest
for r=-1:.25:1;                     % s^r
    figure;
    for i=2:2:10
    N=i;                        % 2N+1 recursive z-p pairs
    sys_N_tf=ora_foc(r,N,w_L,w_H);
    bode(sys_N_tf);grid on;hold on;
    end
    title(['Oustaloup-Recursive-Approximation for {\it s}^{\^}',num2str(r)]);
end



 
