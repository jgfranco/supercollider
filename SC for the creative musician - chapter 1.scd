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

// randomness

exprand(20, 20000);
rrand(1, 9);
rrand(1, 9.0);


// randomly picking from a collection
(
var scale, note;
scale = [0,2,4,5,7,9,11,12];
note = scale.choose;
)

// weighted randomness

// imagine you have a bag with 1000 marbles, 750 are red, 220 are green adn 30 are blue
(
var bag, pick;
bag = [\red, \green, \blue];
pick = bag.wchoose([750, 220, 30].normalizeSum);
)

// generating an array of random values

rrand(40, 90).dup(8); // does not quite work
{rrand(40,90)}.dup(8); // this is the right way
