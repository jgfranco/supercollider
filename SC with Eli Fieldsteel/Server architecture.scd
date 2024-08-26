s.boot;
// busses and groups
(
~reverbBus2 = Bus.audio(s, 2);=
~srcGrp = Group.new;
~fxGrp = Group.after(~srcGrp);
y = Synth.new(\reverb, [\in, ~reverbBus2], ~fxGrp, \addToTail);
)

// synth definitions
(
SynthDef.new(\blip, {
	arg out, fund = 300, dens= 2, decay = 0.2;
	var freq, trig, sig;
	freq = LFNoise0.kr(3).exprange(fund, fund * 4).round(fund);
	sig = SinOsc.ar(freq) * 0.25;
	trig = Dust.kr(dens);
	sig = sig * EnvGen.kr(Env.perc(0.01, decay), trig);
	sig = Pan2.ar(sig, LFNoise1.kr(10));
	Out.ar(out, sig);
}).add;

SynthDef.new(\reverb, {
	arg in, out = 0;
	var sig;
	sig = In.ar(in, 2);
	sig = FreeVerb.ar(sig, 0.5, 0.8, 0.2);
	Out.ar(out, sig);
}).add;
)

// synth instantiation
(
8.do{
	Synth.new(
		\blip,
		[
			\out, ~reverbBus2,
			\fund, exprand(60, 300).round(30)
		],
		~srcGrp
	);
}
)





y.free;