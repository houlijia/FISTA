function test_lasso_weighted()
	clc
	d      = 30; 	% data dimension
	N      = 7; 	% number of samples 
	k      = 50; 	% dictionary size 
	lambda = 0.01;
	Y      = normc(rand(d, N));
	D      = normc(rand(d, k));
	lambda = rand(k, 1);
    if size(lambda, 2) == 1
        lambda = repmat(lambda, 1, N);
    end
    %% fista solution 
	opts.pos = true;
	opts.lambda = lambda;
    opts.check_grad = 1;
	X_fista = fista_lasso(Y, D, [], opts);
	%% spams solution 
	param.lambda     = 1; 
	param.lambda2    = 0;
	param.numThreads = 1; 
	param.mode       = 2; 
	param.pos = opts.pos;
	W = opts.lambda;
	% mex solution and optimal value 
	X_spams      = mexLassoWeighted(Y, D, W, param);
	%% compare costs 
	% cost function 
    function c = calc_F(X)    	
        c = 1/2*normF2(Y - D*X) + norm1(lambda.*X);
    end
	cost_spams = calc_F(X_spams);
	cost_fista = calc_F(X_fista);
	fprintf('cost_fista = %.5s\n', cost_fista);
	fprintf('cost_spams = %.5s\n', cost_spams);
    cost_fista - cost_spams
end