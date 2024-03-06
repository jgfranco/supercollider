x = [4.5, true, nil, 7, -100, \hello];

x.size;

x.at(3);
x[3];

x = (1..100);
x = (1,3..99);
x = Array.series(100,1,1);

y = "hello";
y[2];
y[2].class;

$6;
$6.class;


(
x = [0, 2, 4, 5, 7, 9, 11]; // C scale
x = x + 3;  //Eb scale
x = x.scramble.postln;
//x.at((0..3));
x.keep(4);
)

/* Functions */
(
x = {
	var num;
	num = 8;
	num = num.squared;
	num = num - 1
};
)



(
x = {
	//var num;
	//num = 8;
	//arg num;
	|num = 0|
	num = num.squared;
	num = num - 1
};
)

~result = x.value(5);
~result = x.(3);
~result = x.();

(
~makeNotes = {
	|root = 0, numNotes = 4|
	// syntax alternative:
	// arg root = 0;
	var scale = [0, 2, 4, 5, 7, 9, 11], notes;
	scale = scale + root;
	notes = scale.scramble.keep(numNotes)
};
)

~makeNotes.(0,5)

/* RANDOMNESS */
rrand(1,9); // produces an equal distribution
exprand(1, 1000); // produces a exponential distribution (useful for amplitude for example)
exprand(1, 1000).asInteger;

5.dup(4);

rrand(1,100).dup(8); // generates a random number an creates an array of size 8 of the same number

// what if I want to create an array of random numbers? use curly braces to wrap (basically create a function and duplicate it, functions respond differently to duplicate than arrays

{rrand(1,100)}.dup(8);
// syntax alternative:
{rrand(1,100)} !8;


/* Iteration*/

// using collect, we want to "mess" with the initial array (or receiver)
(
x = [0, 2, 4, 5, 7, 9, 10];
y = x.collect({
	|item|
	//item.postln;
	item + rrand(2,3);
});
)

x;
y;


// using do, we want to keep the receiver intact, but do something with its values

(
x = [0, 2, 4, 5, 7, 9, 10];
x.do({
	|item|
	item.postln;
	item + rrand(2,3);
	"whee!".postln;
});
)

x;
y;