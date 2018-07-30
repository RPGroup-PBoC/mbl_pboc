function log_prior = mcmc_log_prior(param, indep_var, dep_var, epsilon)
%     Computes the log prior for a single set of parameters.
%     Parameters
%     ----------
%     param : array
%         param(1) = epsilon_A = -log(KA)
%         param(2) = epsilon_I = -log(KI)
%         param(3) = sigma
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
%     log_prior: float.
%         log prior probability

    % unpack parameters
    ea = param(1);
    ei = param(2);
    sigma = param(3);
    
    % unpack the independe variables and convert to arrays
    IPTG = indep_var(:, 1);
    R = indep_var(:, 2);
    epsilon_r = indep_var(:, 3);
    
    % Initialize the log_prior
    log_prior = true;
                
    % Check the bounds on the parameters
    % Here we have set bounds on our priors 
    % for ea and ei.
    if (sigma <= 0)
        log_prior = false;
    end %if
    if (ea <= -7) || (ea >= 7)
        log_prior = false;
    end %if
    if (ei <= -7) || (ei >= 7)
        log_prior = false;
    end %if
end