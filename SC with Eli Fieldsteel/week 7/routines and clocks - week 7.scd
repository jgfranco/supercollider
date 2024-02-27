s.boot;
~marimba = Buffer.read(s, "marimba.aif".resolveRelative);

(
SynthDef(\sine, {
	var sig;
	sig = SinOsc.ar(\freq.ir(440), \phs.ir(0));
	sig = Pan2.ar(sig, \pan.ir(0), \amp.kr(0.2));
	sig = sig * Env(
		levels: [0,1,1,0],
		times: [\atk.ir(0.001), \sus.ir(0.03), \rel.ir(0.001)],
		curve: [\atkcrv.ir(-4), 0, \relcrv.ir(-4)]
	).ar(Done.freeSelf);
	Out.ar(\out.ir(0), sig);
}).add;

SynthDef(\samp, {
	var sig, env, buf = \buf.ir(0);
	sig = PlayBuf.ar( 1, buf, BufRateScale.ir(buf) * \rate.ir(1));
	//sig = LPF.ar(sig, \lpf.ir(20000));
	sig = Pan2.ar(sig, \pan.ir(0), \amp.ir(0.2));
	sig = sig * Env(
		levels: [0,1,1,0],
		times: [\atk.ir(0), \sus.ir(1), \rel.ir(1)],
		curve: [0, 0, \relcrv.ir(-4)]
	).ar(Done.freeSelf);
	Out.ar(\out.ir(0), sig);
}).add;
)

Synth(\sine);
Synth(\samp, [buf: ~marimba]);

(
f = {
	Synth(\samp, [buf: ~marimba, atk: 0.2, rate: -4.midiratio, amp: 0.5]);
	Synth(\samp, [buf: ~marimba, atk: 0.2, rate: -2.midiratio, amp: 0.5]);
	Synth(\samp, [buf: ~marimba, atk: 0.2, rate: 2.midiratio, amp: 0.5]);
	Synth(\samp, [buf: ~marimba, atk: 0.2, rate: 7.midiratio, amp: 0.5]);
};

)

f.();

(
r = Routine({
	0.postln;
	1.wait;
	10.postln;
	2.wait;
	100.postln;
});
)

r.next;




(
f = {
	Synth(\samp, [buf: ~marimba, atk: 0.2, rate: 0.midiratio, amp: 1]);
	1.yield;
	Synth(\samp, [buf: ~marimba, atk: 0.5, rate: 3.midiratio, amp: 1]);
	1.yield;
	Synth(\samp, [buf: ~marimba, atk: 0.4, rate: 7.midiratio, amp: 1]);
	1.yield;
	Synth(\samp, [buf: ~marimba, atk: 0.3, rate: 10.midiratio, amp: 1]);
	1.yield;
};
)

(
r = Routine(f);
)

r.next;
r.reset;



(
f = {
	[0, 3, 7, 10].collect({ |rate|
		Synth(\samp, [buf: ~marimba, atk: 0.1, rate: rate.midiratio, amp: 1]);
		1.wait;
	})


};

r = Routine(f);
)

r.reset;
r.play;


(
f = {
		[0, 3, 7, 10].collect({ |rate|
			Synth(\samp,
				[
					buf: ~marimba,
					atk: 0.1,
					rate: rate.midiratio,
					amp: 1
			]);
			0.03.wait;
		});
};

r = Routine(f).play;
)

(
f = {
	[0,1,2,3].collect({ |shift|
		[0, 3, 7, 10].collect({ |rate|
			Synth(\samp,
				[
					buf: ~marimba,
					atk: 0.1,
					rate: (rate+shift).midiratio,
					amp: 1
			]);
			0.03.wait;
		});
	});

};

r = Routine(f).play;
)


(
f = {
	[0,1,2,3].collect({ |shift|
		[0, 3, 7, 10].collect({ |rate|
			Synth(\samp,
				[
					buf: ~marimba,
					atk: exprand(0.01, 0.3),
					rate: (rate+shift).midiratio,
					amp: 0.5
			]);
			exprand(0.03, 0.1).wait;
		});
	});

};

r = Routine(f).play;
)

//left at 16:20

