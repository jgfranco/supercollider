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
		numChannels: 2,
		bufnum: buf,
		rate: BufRateScale.ir(buf) * \rate.kr(1),
		trigger: Impulse.kr(\trig.kr(6)),
		startPos: 0,
		loop: \loop.kr(1)
		//doneAction: Done.freeSelf  // done action defined on the envelope
	);

	sig = sig * \amp.kr(0.5);
	Out.ar(\out.ir(0), sig);

}).add;
)

(
x = Synth(\play, [
	buf: b.sound1,
	amp: -10.dbamp,
	loop:0,
	rate: -3.midiratio,
	rel: 3,
	trig: rrand(1,10)
]);
)

{Impulse.ar(5) * 0.2 ! 2}.play;
{Dust.ar(10) * 0.2 ! 2}.play;

// left at 18:21 on youtube