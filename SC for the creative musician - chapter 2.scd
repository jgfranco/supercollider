s.boot;
Server.local.boot;

s.quit;
Server.local.quit;

s.sampleRate;
s.options.blockSize;


// calibrating your setup
// before running the following command:
{PinkNoise.ar(mul: 1) !2}.play;
// set your volume to the minimum  (now play the sound)
//then bring your system volume up
// until the sound is slighlty annoying.
// now you have  healthy level


// [cmd]+[Enter] evaluates the code
// [cmd]+[period] stops all the sound
{SinOsc.ar(300, 0, 0.1, 0) !2}.play;

// verbose style
{SinOsc.ar(freq: 440,phase: 0,mul: 0.1,add: 0) !2}.play;

// changing a sound while playing
(
x = { |freq = 300|
	SinOsc.ar(freq, mul: 0.1) !2;
}.play;
)

x.set(\freq, 660);

(

// define the sound
f = { |freq = 440, amp= 0.1|
	SinOsc.ar(freq, mul: amp) !2;
};
)

x = f.play;

x.set(\freq, 660, \amp, 0.5);

f.set(\freq, 880, \amp, 0.3); // no effect if applied to function


x = f.play(args: [freq: 800, amp: 0.2]); //override default arguments
y = f.play(args: [freq: 440, amp: 0.5]); //

x.free; // use of free to stop a specific sound

y.release(2); //gentler stop

// using addition to mix a sine wave with pink noise

(
x = {
	var sig;
	sig = SinOsc.ar(freq: 300, mul: 0.5);
	sig = sig + PinkNoise.ar(mul: 0.01);
	sig = sig ! 2;
}.play;
)

x.release(2);

// using binary operators as an alternative to specifying mul and add

(
x = {
	var sig;
	sig = SinOsc.ar(freq: 300) * 0.15;
	sig = sig + (PinkNoise.ar * 0.01);
	sig = sig ! 2;
}.play;
)

x.release(2);

// modulating amplitude of pink noise with a LFO

(
x = {
	var sig, lfo;
	lfo = SinOsc.kr(freq:1/5, phase: 3pi/2, mul: 0.1, add: 0.1);
	sig = PinkNoise.ar * lfo;
	sig = sig !2;
}.play;
)

x.release(2);

// use of range to speficy custom ouput boundaries of a UGEN
// (we avoid defining mul and add)

s.boot;
s.quit;
(
x = {
	var sig, lfo;
	lfo = SinOsc.kr(freq: 0.2, phase: 3pi/2).range(0, 0.2);
	sig = PinkNoise.ar * lfo;
	sig = sig !2;
}.play;
)

x.release(2);

// range mapping methods
// range, exprange, curverange, unipolar, bipolar



// usage of Line AND XLine as simple amplitude envelopes

(
{
	var sig, env;
	env = Line.kr(start: 0.3, end: 0, dur: 0.35);
	sig = SinOsc.ar(350) * env;
	sig = sig !2;
}.play;
)

(
{
	var sig, env;
	env = XLine.kr(start: 0.5, end: 0.0001, dur: 0.8); // XLine cannot end on 0
	sig = SinOsc.ar(350) * env;
	sig = sig !2;
}.play;
)

s.boot;

// introducing doneAction. A doneAction 2 tells the server to destroy the synth after it finishes playing it
(
{
	var sig, env;
	env = XLine.kr(start: 0.5, end: 0.0001, dur: 0.8, doneAction: 2); // XLine cannot end on 0
	sig = SinOsc.ar(350) * env;
	sig = sig !2;
}.play;
)


// Env and EnvGen

(
e = Env.new(
	levels: [0,1,0],
	times: [1,3],
	curve: [0,0]
);
e.plot;
)

// usage of Env and EnvGen to create a custom amplitude envelope signal

(
{
	var sig, env;
	env = EnvGen.kr(
		envelope: Env.new(
			levels: [0,1,0],
			times: [1,3],
			curve:[0,0]),
		doneAction: 2
	);
	sig = SinOsc.ar(350) * 0.3;
	sig = sig * env;
	sig = sig !2;
}.play;
)

// using a gate to scope a Envelope with an indifinite duration

(
f = { |gate = 1|
	var sig, env;
	env = EnvGen.kr(
		envelope: Env.new(
			levels: [0, 1, 0.2, 0],
			times: [0.02, 0.3, 1],
			curve: [0, -1, -4],
			releaseNode: 2
		),
		gate: gate,
		doneAction: 2
	);
	sig = SinOsc.ar(350) * 0.3;
	sig = sig * env;
	sig = sig ! 2;
};
)

x = f.play;
x.set(\gate, 0);


// A retriggerable gated envelope

(
f = { |gate = 1|
	var sig, env;
	env = EnvGen.kr(
		Env.new(
			[0, 1, 0.2, 0],
			[0.02, 0.3, 1],
			[0, -1, -4],
			2
		),
		gate
	);
	sig = SinOsc.ar(350) * 0.3;
	sig = sig * env;
	sig = sig !2;
};
)

x = f.play;
x.set(\gate, 0); // fade to silence but do not free
x.set(\gate, 1); // reopen the gate to restart the envelope
x.set(\gate, 0); // fade to silence again
x.free; // free when finished

// use of trigger-type arguments to create a retriggerable fixed-duration envelope
s.boot;
(
x = { |t_gate = 0|
	var sig, env;
	env = EnvGen.kr(
		Env.new(
			[0, 1, 0],
			[0.02, 0.3],
			[0, -4],
		),
		t_gate
	);
	sig = SinOsc.ar(350) * 0.3;
	sig = sig * env;
	sig = sig !2;
}.play;
)

x.set(\t_gate,1); // evaluate repeatedly
x.free;

// multichannel expansion
s.meter;

{SinOsc.ar(300, mul:0.1)}.play;
{SinOsc.ar(300, mul:0.1) !2}.play;

// step by step depiction of mutlichannel expansion in which an array argument produces an array of UGENS
{SinOsc.ar([350, 353]) * 0.2}.play;
{[SinOsc.ar(350), SinOsc.ar(353)] * 0.2}.play;
{[SinOsc.ar(350) * 0.2, SinOsc.ar(353) * 0.2]}.play;

// a UGEN function involving a binary operation between two multichannel singals. The 450 Hz tone is modulated by a 1 Hz oscillator, and the 800 Hz tone is modulated by a 9 Hz oscillator

(
{
	var sig, mod;
	sig = SinOsc.ar([450, 800]);
	mod = SinOsc.kr([1, 9]).range(0, 1);
	sig = sig * mod;
	sig = sig * 0.2
}.play
)

// Duplicating a UGEN vs UGEN arguement, which produces different behaviour when applied to stochastic signals

// these two expresions produce the same signal:
{SinOsc.ar(300 ! 2, mul: 0.5)}.play;
{SinOsc.ar(300, mul: 0.5) ! 2}.play;

// these two expresions produce different signals:
{PinkNoise.ar(mul:0.2) ! 2}.play; // point source between the speakers
{PinkNoise.ar(mul:0.2 ! 2)}.play; // wide source between the speakers

// similar to when you try to create an array of random numbers

rrand(1, 9) !8; // eight copies of one random number
{rrand(1, 9)} !8; // eight uniquely generated random numbers


// erronously applyin duplication to a multichanel signal

(
{
	var sig;
	sig = [SinOsc.ar(300), PinkNoise.ar()];
	sig = sig * 0.1;
	sig = sig ! 2;
}.play;
)


// Use of Pan2 to "move" a sound in the stereophonic field

(
{
	var sig, pan;
	pan = SinOsc.kr(0.5) * 0.8;
	sig = PinkNoise.ar * 0.2;
	sig = Pan2.ar(sig, pan);
}.play;
)
{SinOsc.kr(0.5) * 0.8}.plot(2);

// an attempt to tplay a 50-channel signal. Only the lowest two channels will be heard.
s.boot;
(
{
	var sig, freq;
	freq = {exprand(200, 2000)} ! 50;
	sig = SinOsc.ar(freq) * 0.1;
}.play;
)

(
{
	var sig, freq;
	freq = {exprand(400, 4000)} ! 50;
	sig = SinOsc.ar(freq) * 0.1;
	sig = Splay.ar(sig);
}.play;
)

// a simple UGEN function used to illustrate the process of conversion to a Synthdef

(
x = {
	var sig;
	sig = SinOsc.ar([350, 353]);
	sig = sig * 0.2;
}.play;
)
x.release(2);

// a synthdef created from the previous UGEN function

(
SynthDef(\test, {
	var sig;
	sig = SinOsc.ar([350, 353]);
	sig = sig * 0.2;
	Out.ar(0, sig);
}).add;
)

// creating and freeing a synth

x = Synth(\test);
x.free;

// a more flexibly designed synthdef with multiple arguments

(
SynthDef(\test, {
	arg freq = 350, amp = 0.2, atk = 0.01, dec = 0.3, slev = 0.4, rel = 2, gate = 1, out =0;
	var sig, env;
	env = EnvGen.kr(
		Env.adsr(atk, dec, slev, rel),
		gate, doneAction: 2
	);
	sig = SinOsc.ar(freq + [0, 1]);
	sig = sig * env;
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
)

x = Synth(\test);
x.set(\freq, 450);
x.set(\amp, 0.5);
x.set(\gate, 0, \rel, 3);

x = Synth(\test, [freq:800, amp: 0.1, atk: 4, slev: 1]);
x.set(\gate, 0);


// a pair of code expressions that generate and fade a tone cluster

(
// return an array of four Synths, assigned to x
x = [205, 310, 525, 700].collect({ |f|
	Synth.new(\test, [\freq, f, \amp, 0.1]);
});
)

x.do({ |n| n.set(\gate, 0, \rel, 5) });