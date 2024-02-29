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
	sig = PlayBuf.ar(2, buf, BufRateScale.ir(buf) * \rate.ir(1));
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

// Routine

// as sound sequencer (chord -> melody)

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

(
f = {
	inf.do({
		[-10, -7, 3, 0].collect({ |rate|
			Synth(\samp,
				[
					buf: ~marimba,
					atk: exprand(0.001, 0.15),
					rate: rate.midiratio,
					sus: rrand(0.01, 0.15),
					rel: rrand(0.1, 0.15),
					amp: exprand(0.1, 0.4)
			]);
			0.15.wait;
		});
	});

};

r = Routine(f).play;
)



(
f = {
	loop({  // loop instead of inf.do does the same trick
		// as soon as you use loop or inf.do you have to consider adding "space"
		// between synths, meaning: you have to add 1.yield or 1.wait in the loop
		// otherwise supercollider will create synths forever and one after the
		// other (almost instantly) and will become unresponsive
		[-10, -7, 3, 0].collect({ |rate|
			s.bind({
				// adding s.bind as a wrapper for synths adds extra precision
				// specially when dealing with yield times that are extremely small
				// for example a synth that does 150 to 200 sounds per second
				// when the yield is "chunkier" like in this case, it doesnt really
				// make a perceivable difference
				Synth(\samp,
					[
						buf: ~marimba,
						atk: 0.01,
						rate: rate.midiratio,
						amp: 0.2
				]);
			});
			0.2.yield; // yield and wait are basically interchangeable
		});
	});

};

r = Routine(f).play;
)

r.stop; // stop the routine manually
r.reset;
r.play;


(
f = {
	loop({
		[-10, -7, 3, 0].collect({ |rate|
				Synth(\samp,
					[
						buf: ~marimba,
						atk: 0.01,
						rate: rate.midiratio,
						amp: 0.2
				]);
			0.2.yield;
		});
	});

};

r = Routine(f).play;
)


// 22: 52 as algorithmic data source(e.g. pitch generator)

(
~pitchFn = {
	var note;
	loop {
		note = -12;
		note.yield;
		3.do{
			note = note + [2, 5, 7].choose;
			note.yield
		};
	};
};

~pitchGen = Routine(~pitchFn);
)

~pitchGen.next;
~pitchGen.reset;

Synth(\samp, [buf: ~marimba,  rate: ~pitchGen.next.midiratio]);

(
~synthFn = {
	loop {
		Synth(\samp, [buf: ~marimba,  rate: ~pitchGen.next.midiratio]);
		0.2.wait;
	}
};
//~synthGen = Routine(~synthFn);
~synthGen = ~synthFn.r; // this is the simplified version of the line above
)

~synthGen.play;
~synthGen.reset;
~synthGen.stop;

(
~synthFn = {
	loop {
		Synth(\samp, [buf: ~marimba,  rate: ~pitchGen.next.midiratio]);
		0.2.wait;
	}
};
//~synthGen = Routine(~synthFn);
//~synthGen = ~synthFn.r; // this is the simplified version of the line above
)


// you can do this if you don't want to deal with reset.
// You are basically creating a new instance everytime
~synthGen = ~synthFn.r.play;
~synthGen = Routine(~synthFn).play; // alternative to the line above
~synthGen = r(~synthFn).play; // yet another alternative
~synthGen.stop;

// tempoClock
TempoClock.default;

TempoClock.default.tempo; // 1.0 bps beats per second
TempoClock.default.beats;


t.beats;
t = TempoClock.new(98/60).permanent_(true);

(

~pitchFn = {
	var note;
	loop {
		note = -12;
		note.yield;
		3.do{
			note = note + [2, 5, 7].choose;
			note.yield
		};
	};
};

~pitchGen = Routine(~pitchFn);

~synthFn = {
	loop {
		Synth(\samp, [buf: ~marimba,  rate: ~pitchGen.next.midiratio]);
		0.2.wait;
	}
};

//~synthGen = r(~synthFn).play(TempoClock.default);
~synthGen = r(~synthFn).play(t);
)

~synthGen.stop;
t.tempo_(80/60); // method used to change tempo while live coding

(
~post = {t.beats.postln; 1;};
t.schedAbs(t.nextBar, {~post.()});
)

~post = {}; // reset the function so the previous test stops


(
~pitchFn = {
	var note;
	loop {
		note = -12;
		note.yield;
		3.do{
			note = note + [2, 5, 7].choose;
			note.yield
		};
	};
};

~pitchGen = Routine(~pitchFn);

~synthFn = {
	loop {
		Synth(\samp, [buf: ~marimba,  rate: ~pitchGen.next.midiratio]);
		0.5.wait;
	}
};

//~synthGen = r(~synthFn).play(TempoClock.default);
//~synthGen = r(~synthFn).play(clock: t, quant: [4, -1]); // see Quant class for more details on these parameters (quant, phase)
~synthGen = r(~synthFn).play(clock: t, quant: Quant(4, 1));
)

~synthGen.stop;



// quantization


(
~r0 = r{
	loop {
		Synth(\samp, [buf: ~marimba,  rate: [0, 3, 5].choose.midiratio, amp: 0.05]);
		0.25.wait;
	}
}.play(t, quant:4);
)

~r0.stop;

(
~r1 = r{
	loop {
		Synth(\samp, [buf: ~marimba,  rate: [0, 3, 5, 7].choose.midiratio/2, amp: 0.2]);
		0.5.wait;
	}
}.play(t, quant:4);
)

(
~r2 = r{
	loop {
		Synth(\samp, [buf: ~marimba,  rate: 0.midiratio/4, amp: 0.5, rel: 1, sus: 0]);
		0.75.wait;
	}
}.play(t, quant:4);
)

~r2.stop()

(
~r3= r{
	loop {
		Synth(\samp, [buf: ~marimba,  rate: [0, 3, 5, 7, 9, 10].choose.midiratio*2, amp: 0.1, rel: 0.2, sus: 0]);
		0.25.wait;
	}
}.play(t, quant:4);
)

[~r0, ~r1, ~r2, ~r3].do{|r| r.stop;}
~post = {};
t.stop;

