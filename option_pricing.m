% Function option_pricing used in homework 3
function stock_price = option_pricing(So,r,sigma,time,b_m_value)
    A = sigma*b_m_value - r*time + 0.5*time*(sigma)^2;
    stock_price = So * exp(A);
end
