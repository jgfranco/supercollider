s.boot;

// a function that produces a three note chord when evaluated

(
~eventA = {SinOsc.ar(60.midicps ! 2) * Line.kr(0.1, 0, 1, 2)};
~eventB = {SinOsc.ar(70.midicps ! 2) * Line.kr(0.1, 0, 1, 2)};
~eventC = {SinOsc.ar(75.midicps ! 2) * Line.kr(0.1, 0, 1, 2)};

f = {
	~eventA.play;
	~eventB.play;
	~eventC.play;
};
)

f.();

// using a Routine and hthe next method to manually step through a sequence of notes

(
~eventA = {SinOsc.ar(60.midicps ! 2) * Line.kr(0.1, 0, 1, 2)};
~eventB = {SinOsc.ar(70.midicps ! 2) * Line.kr(0.1, 0, 1, 2)};
~eventC = {SinOsc.ar(75.midicps ! 2) * Line.kr(0.1, 0, 1, 2)};

f = {
	~eventA.play;
	1.yield;
	~eventB.play;
	1.yield;
	~eventC.play;
	1.yield;
};

r = Routine(f);
)

r.next;
r.reset;
r.play;
// using a routine and while loop to generate randomly incremented midi note numbers

(
~noteFunc = {
	var num = 48;
	while({num < 84}, {
		num.yield;
		num = num + rrand(1, 4);
	});
};
~noteGen = Routine(~noteFunc);
)

~noteGen.next;

// using iteration inside a rountine to create repetitions

(
~playTone = { |freq|
	{SinOsc.ar(freq ! 2) * Line.kr(0.1, 0, 1, 2)}.play;
};

f = {
	3.do({
		~playTone.(72.midicps);
		0.2.yield;
		~playTone.(62.midicps);
		0.4.yield;
	});
};

r = Routine(f);
)
r.play
r.reset;

// an infinate length routine
(
~playTone = { |freq|
	{SinOsc.ar(freq ! 2) * Line.kr(0.1, 0, 0.2, 2)}.play;
};

r = Routine({
	loop({
		~playTone.(72.midicps);
		0.4.yield;
		[62, 64, 65].do({ |n|
			~playTone.(n.midicps);
			(0.4 /3).yield;
		});
	});
});
)

r.play;
r.stop;