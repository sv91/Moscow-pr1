function loss = loss(yN, yHat)
	ident = 0;
    comp = (yN ~= yHat);
    loss = sum(comp)/length(yN);
% 	for i=1:length(yN)
% 		if yN ~= yHat
% 			ident=ident+1;
% 		end
% 	end
	
end
