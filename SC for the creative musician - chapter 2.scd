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