//patterns, events, streams


// value patterns
(
~pat = {
	var num = 50, inc = 7, count = 0;
	while({ count < 6}, {
		num.yield;
		num = num + inc;
		count = count + 1
	});
};
~seq = r(~pat);
)

~seq.next;


// this is a simplified version using the Pseries pattern
(
~pat = Pseries(50, 7, 6);
~seq = ~pat.asStream;
)

~seq.next;

//mathematical operations with patterns
(
~pat = Pseq([1 ,2 ,3], inf);
~pat = ~pat + Pseq([10,20], inf);
~seq = ~pat.asStream;
)

~seq.next;


// nested patterns

(
~pat = Pseq([
	5,
	Pwhite(lo:1, hi:9, length:1),
	12,
	Pseq([2, 3], 2)
], 3);

~seq = ~pat.asStream;
)

~seq.next;


// cool panner
(
~pat = Pseq([-1, 1], inf);
//~pat = ~pat * rrand(0, 1.0);// this wont work, it always return the same random number
~pat = ~pat * Pwhite(0, 1.0, inf); // we can use the white noise pattern instead
~seq = ~pat.asStream;
)

~seq.next;

// Events

// like a hashmap?
e = (abc: 5, def: 7, ghi: 9)
e.keys;

e[\abc];

e.ghi;

e.abc = 12; // keys are unique

s.boot;

().play; // this actually plays a sound;

Event.eventTypes.keys.postln;

(amp: 0.5, freq: 500, type:\note).play;
(amp: 0.5, freq: 500, type:\rest).play;
(amp: 0.5, freq: 65.midicps, type:\note).play;
(amp: 0.5, note: 0).play; // this goes chromatically up
(amp: 0.5, degree: 1).play; // this follows the scale (major)
(amp: 0.5, midinote: 64).play;

(amp: 0.5, midinote: 50, ctranspose:7).play;
(amp: 0.5, midinote: 50, harmonic:5).play;
(db: -10).play;
(db: -5, pan: 1).play;
(db: -5, pan: -1).play;

s.boot;

b = Buffer.read(s, "ceramic.wav".resolveRelative);

(
SynthDef(\play, {
	var sig, buf = \buf.ir(0);
	sig = PlayBuf.ar(
		numChannels: 2,
		bufnum: buf,
		rate: BufRateScale.ir(buf) * \rate.ir(1),
		startPos: \spos.ir(0),
		loop: \loop.ir(0)
	);
	sig = RLPF.ar(
		in: sig,
		freq: \lpf.ir(2000).clip(20, 2000),
		rq: \rq.ir(1);
	);
	sig = sig * Env(
		levels: [0, 1, 0],
		times: [\atk.ir(0.001), \rel.ir(0.5)],
		curve: [-2, -2]
	).ar(2);
	sig = Pan2.ar(sig, \pan.ir(0), \amp.ir(0.5));
	Out.ar(\out.ir(0), sig);
}).add;
)

Synth(\play, [buf:b]);
Synth(\play, [buf: b, lpf: 5000, rq:0.1, rel: 1, rate: 5.midiratio]);

(instrument: \play, buf: b, amp: 1, atk: 0.001, rel: 5).play;

(
SynthDef(\saw, {
	var sig, buf = \buf.ir(0);
	sig = Saw.ar(\freq.ir(200), mul: 0.5);
	sig = RLPF.ar(
		in: sig,
		freq: \lpf.ir(1000).clip(20, 2000),
		rq: \rq.ir(1);
	);
	sig = sig * Env.adsr().ar(2, \gate.kr(1));
	sig = Pan2.ar(sig, \pan.ir(0), \amp.ir(0.5));
	Out.ar(\out.ir(0), sig);
}).add;
)
x = Synth(\saw, [amp: 0.6]);
x.set(\gate, 0);

(instrument: \saw, amp: 0.2).play; // Event silences the synth that would run indefinitely if invoked via Synth
(instrument: \saw, amp: 0.5, sendGate: false).play; // sendGate is the way an Event "silences" by default the synth, by setting it to false we get the same effect that running Synth produces
(instrument: \saw, amp: 0.5, sustain: 3 ).play;

// Pbind - defines a sequence of events


// this is just for showing how it works
(
~pat = Pbind(
	\instrument, \saw,
	\amp, 0.5,
	\midinote, 60,
	\sustain, 0.2
);
~seq = ~pat.asStream;
)

~seq.next(()).play; // input an empty event


// on the other hand, this is how its usually used
(
~pat = Pbind(
	\instrument, \saw,
	\dur, 0.25,
	\db, -10,
	\midinote, Pwhite(50,70, inf),
	\sustain, 0.2
);
~seq = ~pat.play;
)

~seq.stop;

(
~pat = Pbind(
	\instrument, \saw,
	\dur, 0.2,
	\db, -10,       //D   E   F   G   A   B   C    D
	\midinote, Prand([62, 64, 65, 67, 69, 71, 72, 74], inf),
	\sustain, 0.2
);
~seq = ~pat.play;
)


t = TempoClock.new(108/60).permanent_(true);

(
~pat = Pbind(
	\instrument, \play,
	\rel, 0.5,
	\buf, b,
	\amp, 0.8,
	\rate, Pseq([Pseries(0, -1, {[7,8,9].choose})], inf).midiratio,
	\dur, Pseq([
		Pseq([0.12], 6),
		Pwhite(0.2, 2, 1)
	], inf),
	\lpf, Pseq([
		Pgeom(5000, 0.5, 6),
		Pseq([312.5], 1)
	], inf),
	\rq, 0.04
);
~seq = ~pat.play(t);
)

~seq.stop;



