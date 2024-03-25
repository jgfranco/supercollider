//Recap of Signal FLow, Busses & order of execution

s.boot;

(
s.newBufferAllocators;
~abus = Bus.audio(s, 2);

SynthDef(\sin, {
	var sig, trig;
	trig = Impulse.kr(0.5);
	sig = SinOsc.ar(\freq.kr(1000) + [0, 5], mul: 0.2);
	sig = sig * Env.perc().ar(0,trig);
	Out.ar(\out.kr(0), sig);
}).add;

SynthDef(\rev, {
	var sig = In.ar(\in.kr(0), 2);
	sig = FreeVerb.ar(sig, 0.3, 0.999, 0.7);
	Out.ar(\out.kr(0), sig);
}).add;
)

s.scope;
~src = Synth(\sin, [out: ~abus]);

~fx = Synth(\rev, [in: ~abus, out: 0], ~src, \addAfter);


// left at 1:30