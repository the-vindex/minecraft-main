if arg.getn() ~= 3 then
	print('Must be 3 arguments, colors from left to right')
	exit(1)
end

local p = peripheral.wrap('front')
p.setColorNames(arg[3],arg[2],arg[1])
