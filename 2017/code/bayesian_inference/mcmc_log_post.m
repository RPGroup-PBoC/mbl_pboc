function lnp = mcmc_log_post(param, indep_var, dep_var, epsilon)
%     Computes the log prior for a single set of parameters.
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

    % unpack parameters
    ea = param(1);
    ei = param(2);
    sigma = param(3);
    
    lnp = mcmc_log_prior(param, indep_var, dep_var, epsilon);
    % Check before computing the likelihood if one of the boundaries set by
    % the prior was not satisfied. If that is the case don't waste time
    % computing the likelihood and return -inf
    if lnp == false
        lnp = false;
    else
        lnp = -(length(dep_var) + 1) * log(sigma)...
            + mcmc_log_like(param, indep_var, dep_var, epsilon);
    end %if

end