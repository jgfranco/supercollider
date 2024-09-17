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

// nesting routines inside of other routines so that they play in parallel or in series

(
~playTone = { |freq|
	{SinOsc.ar(freq ! 2) * Line.kr(0.1, 0, 0.2, 2)}.play;
};

~sub0 = {
	2.do({
		~playTone.(67.midicps);
		0.15.yield;
		~playTone.(69.midicps);
		0.15.yield;
	});
	0.5.yield;
};

~sub1 = {
	3.do({
		~playTone.(75.midicps);
		0.5.yield;
	});
	1.yield;
};

~r_parallel = Routine({
	Routine(~sub0).play;
	Routine(~sub1).play;
});

~r_series = Routine({
	Routine(~sub0).embedInStream;
	Routine(~sub1).embedInStream;
});

)

~r_parallel.play;
~r_series.play;

// TempoClock
TempoClock.default.beats;
t = TempoClock(132/60);
t.beats;

// a routine that plays three notes in sequence with timings based on beat durations at a specific temp0.

(
t = TempoClock(132/60);

~playTone = { |freq|
	{SinOsc.ar(freq ! 2) * Line.kr(0.1, 0, 1, 2)}.play;
};

r = Routine({
	[60, 70, 75].do({ |n|
		~playTone.(n.midicps);
		(1/2).yield;
	});
});
)

r.play;
r.reset;

// rythmic quantization of two routines

(
t = TempoClock(132/60);

~playTone = { |freq|
	{SinOsc.ar(freq ! 2) * Line.kr(0.1, 0, 0.2, 2)}.play;
};

~r0 = Routine({
	loop({
		[60, 63, 65, 67].do({ |n|
		~playTone.(n.midicps);
		(1/2).yield;
		});
	});
});

~r1 = Routine({
	loop({
		[70, 72, 75, 77].do({ |n|
		~playTone.(n.midicps);
		(1/2).yield;
		});
	});
});
)

~r0.play(t, quant: 4); // begin playing on next beat multiple of four
~r1.play(t, quant: 4); // will be beat-aligned with ~r0

// beat offset : starting the routine shifted a certain amount of beats
~r0.play(t, quant: [4, 0]); // plays on the next beat multiple of four
~r1.play(t, quant: [4, 1]); // plays one beat after the next beat multiple of four

t.clear;
t.stop;

// configuring a clock to survivde [cmd] + [period]

t = TempoClock(132/60).permanent_(true);
// press [cmd] + [period]
t.beats; // the clock remains
t.permanent = false;
// press [cmd] + [period]
t.beats; // the clock is destroyed

//check www.oup.com/us/supercolliderforthecreativemusician


(0..999).postln;  // truncated double post
(0..999).postln;\ // truncated single post
(0..999).postcs;  // non-truncated double post
(0..999).postcs;\ // non-truncated single post

(
~func = { |input|
	input = input + 2;
};
)

~func.postln;
~func.postcs;

// the event model
().play;

(freq: 625, amp: 0.2).play;

(
SynthDef(\bpf_brown, {
	arg atk = 0.02, rel = 2, freq = 800, rq = 0.005, pan = 0, amp =1, out = 0;
	var sig, env;
	env = Env([0, 1, 0], [atk, rel]).kr(2);
	sig = BrownNoise.ar(0.8);
	sig = BPF.ar(sig, freq, rq, 1/rq.sqrt);
	sig = Pan2.ar(sig, pan, amp) * env;
	Out.ar(out, sig);
}).add;
)

(instrument: \bpf_brown, freq: 800, atk: 0.001, rel: 3, amp: 0.3).play;

(degree: 0).play;
(degree: 1).play; // modal transposition by scale degree

(note: 0).play;
(note: 2).play; // chromatic transposition by semitones

(midinote: 60).play;
(midinote: 62).play; // MIDI note numbers

(freq: 261.626).play;
(freq: 293.665).play; //Hertz
s.reboot;
(degree: 0).play;
(degree: 0.1).play; // sharp

(degree: 0).play;
(degree: 0s).play; // sharp
(degree: 0b).play; // flat

// automatic gate closure when using an event to create a synth with a gated envelope

(
SynthDef(\bpf_brown, {
	arg atk = 0.02, rel = 2, gate = 1, freq = 800, rq = 0.005, pan = 0, amp =1, out = 0;
	var sig, env;
	env = Env.asr(atk, 1, rel).kr(2,gate);
	sig = BrownNoise.ar(0.8);
	sig = BPF.ar(sig, freq, rq, 1 /rq.sqrt);
	sig = Pan2.ar(sig, pan, amp) * env;
	Out.ar(out,sig);
}).add;
)

x = Synth(\bpf_brown, [freq: 500, amp: 0.2]);
x.set(\gate, 0); // manual gate closure

(instrument: \bpf_brown, freq: 500, amp: 0.2).play; // automatic gate closure

// using Pbind to manually play a sequence of note events

(
p = Pbind(
	\midinote, Pseq([55, 57, 60], 2),
	\db, Pwhite(-20.0, -10.0, 6),
	\pan, Prand([-0.5,0, 0.5], 6)
);
)
~seq = p.asStream;
~seq.next(()).play;
~seq.reset;

(
p = Pbind(
	\midinote, Pseq([55,57,60],2).trace // use of trace to visualize what the Pbind is doing
);
~seq = p.play
)

//using the dur key to specify timing information for an EventStreamPlayer

(
p = Pbind(
	\dur, Pseq([0.75, 0.25, 0.75, 0.25, 0.5, 0.5]),
	\midinote, Pseq([55, 57, 60], 2),
	\db, Pwhite(-20.0, -10.0, 6),
	\pan, Prand([-0.5,0, 0.5], 6)
);

~seq = p.play;
)


// rythmically quantizing two EvenStreamPlayers on a custom TempoClock

(
t = TempoClock(90/60);

p = Pbind(
	\dur, 0.25,
	\midinote, Pwhite(48, 60, inf);

);

q = Pbind(
	\dur, 0.25,
	\midinote, Pwhite(72, 84, inf);
);
)

~seq_p = p.play(t, quant:4);
~seq_q = q.play(t, quant:4);



s.reboot;

// use of rest events in a duration pattern to express a musical figure

t = TempoClock(112/60);

(
Pbind(
	\dur, Pseq([
		Pseq([Rest(1/4), 1/4], 4),
		Pseq([1/4, Rest(1/4), 1/4, Rest(1/4), 1/4, Rest(3/4)])
	], 1),
	\sustain,  0.1,
	\degree, Pseq([
		0,4,0,5,0,7,0,4,
		5,0,7,0,8,0,0,0
	]),
).play(t);
)

// using symbols in a pitch pattern to express the same musical phrase as above
t = TempoClock(112/60);

(
Pbind(
	\dur, 1/4,
	\sustain,  0.1,
	\degree, Pseq([
		\,4,\,5,\,7,\,4,
		5,\,7,\,8,\,\,\
	]),
).play(t);
)

// pattern manipulation of the type key to express the musci phrase as above

t = TempoClock(112/60);
s.reboot;
(
Pbind(
	\type, Pseq([
		Pseq([\rest, \note], 4), // bar 1
		Pseq([\note, \rest], 2), \note, Pseq([\rest], 3) // bar 2
	], 1),
	\dur, 1/4,
	\sustain,  0.1,
	\degree, Pseq([
		0, 4,0,5,0,7,0,4,
		5,0,7,0,8,0,0,0
	]),
).play(t);
)






