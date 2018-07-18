function lp = log_post(param, indep_var, dep_var, epsilon)
%     Computes the log posterior for a single set of parameters.
%     Parameters
%     ----------
%     param : array
%         param(0) = epsilon_A = -log(KA)
%         param(1) = epsilon_I = -log(KI)
%     indep_var : n x 3 array
%         series of independent variables to compute the theoretical fold-change
%         1st column: IPTG concentration
%         2nd column: repressor copy number
%         3rd column: repressor-DNA binding energy
%     dep_var : n x 1 array
%         dependent variable, i.e. experimental fold-change. 
%         NOTE: the lenght of this array should be the same as the number of rows
%         of the indep_var array
%     Returns
%     -------
%     log_post: float.
%         log posterior probability

    % unpack parameters
    ea = param(1);
    ei = param(2);
    
    % unpack the independe variables and convert to arrays
    IPTG = indep_var(:, 1);
    R = indep_var(:, 2);
    epsilon_r = indep_var(:, 3);
        
    % compute theoretical fold-change
    fc_theory = fold_change(IPTG, ea, ei, R, epsilon_r, epsilon);
    
    % compute the log posterior probability
    lp = -length(dep_var) ./ 2 .* log(sum((dep_var - fc_theory).^2));
end