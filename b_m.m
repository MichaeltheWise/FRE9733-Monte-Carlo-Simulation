% Function brownian_motion used
function brownian_motion = b_m(w_t,X_t,delta_t)
    brownian_motion = w_t + X_t * sqrt(delta_t);
end