//functions

(
f = {
	var num = 4;
	num = num.squared;
	num = num.reciprocal;
};
)
f.value;
f.();

// functions with arguments

(
f = {
	arg input = 4;
	var num;
	num = input.squared;
	num = num.reciprocal;
};
)

f.(5);
f.();

// functions with arguments using the pipe syntax

(
g = { |thingA = 7, thingB = 5|
	var result;
	thingA = thingA.squared;
	thingB = thingB.reciprocal;
	result = thingA + thingB
};
)

g.(3,2);