function r = resid(param, indep_var, dep_var, epsilon)
%     Residuals for the theoretical fold change.
%     
%     Parameters
%     ----------
%     param : array-like.
%         param[0] = epsilon_a
%         param[1] = epsilon_i
%     indep_var : n x 3 array.
%         series of independent variables to compute the theoretical fold-change.
%         1st column : IPTG concentration
%         2nd column : repressor copy number
%         3rd column : repressor binding energy
%     dep_var : array-like
%         dependent variable, i.e. experimental fold-change. Then length of this
%         array should be the same as the number of rows in indep_var.
%         
%     Returns
%     -------
%     fold-change_exp - fold-change_theory

    % unpack the parameters
    ea = param(1);
    ei = param(2);

    % unpack the independe variables and convert to arrays
    IPTG = indep_var(:, 1);
    R = indep_var(:, 2);
    epsilon_r = indep_var(:, 3);
    
    % compute theoretical fold-change
    fc_theory = fold_change(IPTG, ea, ei, R, epsilon_r, epsilon);
    
    % compute the log posterior probability
    r = dep_var - fc_theory;
end