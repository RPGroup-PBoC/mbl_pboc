function log_like = mcmc_log_like(param, indep_var, dep_var, epsilon)
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
%     log_likelihood: float.
%         log likelihood probability

    % unpack parameters
    ea = param(1);
    ei = param(2);
    sigma = param(3);
    
    
    % unpack the independe variables and convert to arrays
    IPTG = indep_var(:, 1);
    R = indep_var(:, 2);
    epsilon_r = indep_var(:, 3);
    
    % unique repressor copy number and binding energies
    rep = unique(R); % Repressor copy numbers
    eps_r = unique(epsilon_r); % Represor energies
    
    
    % Initialize the log_likelihood
    log_like = 0;
    % loop through the parameters to fit in order to compute the
    % theoretical fold change using the right parameters for each strain
    for r=1:length(rep)
        for eps=1:length(eps_r)
            IPTG_block = IPTG((R==r) & (epsilon_r==eps));
            fc_block = dep_var((R==r) & (epsilon_r==eps));
            % compute the theoretical fold-change
            fc_theory = fold_change(IPTG_block,...
                                    ea, ei,rep(r), eps_r(eps), epsilon);
            % compute the log likelihood for this block of data
            log_like = log_like -...
                       sum((fc_theory - fc_block).^2) ./ 2 ./ sigma.^2;
        end %for 1
    end %for 2
    
end