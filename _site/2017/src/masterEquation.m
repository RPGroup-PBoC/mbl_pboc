function prob = masterEquation(prob, k, dt)
% Computes the master equation for diffusion in one dimension.
% 
% Parameters
% ----------
% prob : 2d-array
%     Array in which the probabiilities will be stored. This should be in
%     the shape of N boxes by m time points. This should have a preset initial
%     condition. 
% k : float
%     Jump rate of particles between boxes in units of 1/s. 
% dt : float
%     Time step for our integration. This should be in units of seconds and
%     should be sufficiently smaller than our jump rate for numerical stability.
% 
% Returns
% -------
% prob: 2d-array
%     The probability vector given to the function where each element now
%     contains a computed probability.
    
% We'll first figure out the total number of boxes and the number 
% of time steps we will integrate over. This will essentially be the
% shape of our prob array. 
[numBoxes, timePoints] = size(prob);

% We need to integrate over each time step. Since we have the initial 
% condition  set, we can start at time step '2'. 
for t=2:timePoints
    % Now we will need to deal with the boundary conditions. If we are 
    % at box 0, we can't deal with box -1. Likewise, if we are in the
    % final box, we can't deal with box +1. There are more clever 
    % ways we could deal with this, but for right now we can just compute
    % these two cases explicity. 
    prob(1, t) = prob(1, t-1) + k * dt * prob(2, t-1) -...
                    k * dt * prob(1, t-1);

    % Identify the index of the last box.
    lastBox = numBoxes;
    prob(lastBox, t) = prob(lastBox, t-1) +...
                            k * dt * prob(lastBox-1, t-1) -...
                            k * dt * prob(lastBox, t-1);

    % With the boundary conditions in place, we can now iterate over 
    % all other boxes and repeat this procedure. 
    for box=2:numBoxes - 1
        prob(box, t) = prob(box, t-1) + k * dt * prob(box-1, t-1) +...
                       k * dt * prob(box+1, t-1) -...
                       2 * k * dt * prob(box, t-1);
                
    end %for2
end %for1

end %function