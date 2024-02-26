s.boot;
(
Buffer.freeAll;
~path = PathName(thisProcess.nowExecutingPath).parentPath;
b = (
	sound1: Buffer.read(s, ~path ++ "celesta_4.wav"),
	sound2: Buffer.read(s, ~path ++ "PSN.wav")
);
)
b.keys;
b.sound1.play;
b.sound2.play;


(
SynthDef(\play, {
	arg buf = 0;
	var sig;
	sig = PlayBuf.ar(
		numChannels: 2,
		bufnum: buf,
		rate: BufRateScale.ir(buf) * \rate.kr(1),
		loop: \loop.kr(1),
		doneAction: Done.freeSelf
	);

	sig = sig * \amp.kr(0.5);
	Out.ar(\out.ir(0), sig);

}).add;
)


x = Synth(\play, [buf: b.sound1, amp: -10.dbamp, rate:12.midiratio, loop:0]);


(
SynthDef(\play, {
	arg buf = 0;
	var sig, env;
	env = Env(
		levels: [0, 1, 0],
		times: [\atk.ir(0.001), \rel.ir(0.5)],
		curve: [0, -4]
	).ar(2); // this is wheremdone action for the synth

	sig = PlayBuf.ar(
		numChannels: 1,
		bufnum: buf,
		rate: BufRateScale.ir(buf) * \rate.kr(1),
		trigger: Impulse.kr(\trig.kr(6)),
		startPos: \spos.kr(0),
		loop: \loop.kr(1)
		//doneAction: Done.freeSelf  // done action defined on the envelope
	);

	sig = sig * env;
	sig = sig * \amp.kr(0.5);
	Out.ar(\out.ir(0), sig);

}).add;
)

(
10.do({
	x = Synth(\play, [
		buf: b.sound1,
		amp: -15.dbamp,
		loop:1,
		rate: rrand(-6, 6).midiratio,
		rel: 10,
		//trig: rrand(1,10)
		trig: exprand(1,2),
		//trig: 1,
		spos: rrand(0, b.sound1.numFrames -1).postln;
	]);
})
)

b.sound1.numFrames;
{Impulse.ar(5) * 0.2 ! 2}.play;
{Dust.ar(10) * 0.2 ! 2}.play;



(
SynthDef(\play, {
	arg buf = 0;
	var sig, env;
	/*env = Env(
		levels: [0, 1, 0],
		times: [\atk.ir(0.001), \rel.ir(0.5)],
		curve: [0, -4]
	).ar(2); */
	sig = PlayBuf.ar(
		numChannels: 2,
		bufnum: buf,
		rate: BufRateScale.ir(buf) * \rate.kr(1),
		trigger: Impulse.kr(MouseY.kr(1, 100,1)),
		startPos: MouseX.kr(0, BufFrames.kr(buf) -1),
		loop: \loop.kr(1)
		//doneAction: Done.freeSelf  // done action defined on the envelope
	);
	//sig = sig * env;
	sig = sig * \amp.kr(0.5);
	Out.ar(\out.ir(0), sig);

}).add;
)

(

	x = Synth(\play, [
		buf: b.sound2,
		amp: -15.dbamp,
		loop: 1,
	rate: -1
	]);
)

s.boot;

(
SynthDef(\read, {
	arg buf = 0;
	var sig, phs;
	phs = Line.ar(
		start: 0,
		end: BufFrames.ir(buf) -1,
		dur: BufDur.ir(buf) * \durscl.ir(1),
		doneAction:2
	);
	sig = BufRd.ar(
		numChannels: 2,
		bufnum: buf,
		phase: phs
	);
	sig = sig * \amp.kr(0.5);
	Out.ar(\out.ir(0), sig);
}).add
)

Synth(\read, [buf: b.sound2, amp: 0.10, durscl: 2]);
Synth(\read, [buf: b.sound2, amp: 0.10, durscl: 1/2]);
Synth(\read, [buf: b.sound2, amp: 0.10, durscl: -5.midiratio]);


(
SynthDef(\read, {
	arg buf = 0;
	var sig, phs;
	phs = LFSaw.ar(
		freq: 1 / BufDur.ir(buf) * \rate.kr(1),
		iphase: 1
	).range(0, BufFrames.ir(buf)-1);
	sig = BufRd.ar(
		numChannels: 2,
		bufnum: buf,
		phase: phs,
		loop: 1,
		interpolation: 4
	);
	sig = sig * \amp.kr(0.5);
	Out.ar(\out.ir(0), sig);
}).add
)

x = Synth(\read, [buf: b.sound2, amp: 0.25, ]);
x.set(\rate, -10.midiratio);


// left at 34:35 on youtube

// depending on what you need to do, BufRd and PlayBuf can do it, except one can be easier to use for the specificities of task than the other, they do the same, they just do it differently, they are different tools for the same task



//building vibrato modifying rate with a Sine oscilator

(
SynthDef(\play, {
	arg buf = 0;
	var sig, env;
	env = Env(
		levels: [0, 1, 0],
		times: [\atk.ir(0.001), \rel.ir(0.5)],
		curve: [-2, 2]
	).ar(2);
	sig = PlayBuf.ar(
		numChannels: 2,
		bufnum: buf,
		rate: BufRateScale.ir(buf) * \rate.kr(1)
		* SinOsc.kr(\vibhz.kr(6)).bipolar(\vibdepth.kr(1)).midiratio,
		loop: \loop.kr(1)
	);
	sig = sig * env;
	sig = sig * \amp.kr(0.5);
	Out.ar(\out.ir(0), sig);

}).add;
)

(
20.do({
Synth(\play, [
	buf: b.sound2,
	atk: 0.001,
	rel: 10,
		vibdepth: rrand(4,14),
		vibhz: exprand(1, 12),
		amp: 0.1
]);
})
)

-20.dbamp.postln;