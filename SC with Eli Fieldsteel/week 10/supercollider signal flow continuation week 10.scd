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
s.meter;
~src = Synth(\sin, [out: ~abus]);

~fx = Synth(\rev, [in: ~abus, out: 0], ~src, \addAfter);

~src.free;

~fx.free;

s.options.numControlBusChannels;


// More on Control Busses & Audio Busses

s.scope; // open the stethoscope and see the control channels not the audio ones for this next portion of the code
x = {Out.kr(3, SinOsc.kr(1))}.play;
x.free;

b = Bus.control(s,8);
b.setn([0, 0, 0, 0, 0,0,0,0]);


(
s.newBusAllocators;
b = Bus.control(s, 1);
)
b.value_(0);


(
s.newBufferAllocators;
~abus = Bus.audio(s, 2);
~kbus = Bus.control(s, 1);


SynthDef(\lfo, {
	var sig;
	sig = SinOsc.kr(8).exprange(200, 400);
	Out.kr(\out.kr(0), sig);
}).add;

SynthDef(\sin, {
	var sig, trig, freq;
	freq = In.kr(\in.kr(0), 1);
	trig = Impulse.kr(0.5);
	sig = SinOsc.ar(freq + [0, 5], mul: 0.2);
	sig = sig * Env.perc().ar(0,trig);
	Out.ar(\out.kr(0), sig);
}).add;

SynthDef(\saw, {
	var sig, trig, freq;
	freq = In.kr(\in.kr(0), 1);
	trig = Impulse.kr(0.5);
	sig = Saw.ar(freq * 1.5 + [0, 5], mul: 0.1);
	sig = sig * Env.perc().ar(0,trig);
	Out.ar(\out.kr(0), sig);
}).add;

SynthDef(\rev, {
	var sig = In.ar(\in.kr(0), 2);
	sig = FreeVerb.ar(sig, 0.3, 0.999, 0.7);
	Out.ar(\out.kr(0), sig);
}).add;
)


~lfo= Synth(\lfo, [out: ~kbus]);
~src = Synth(\sin, [in: ~kbus, out: 0], ~lfo, \addAfter);
~src.set(\out, ~abus);

~fx = Synth(\rev, [in: ~abus, out: 0], ~src, \addAfter);

~saw = Synth(\saw, [in: ~kbus, out:~abus], ~src, \addAfter);
~saw.free;

~src.free;

~fx.free;



(
s.newBufferAllocators;
~abus = Bus.audio(s, 2);
~kbus = Bus.control(s, 1);



SynthDef(\sin, {
	var sig, trig;
	trig = Impulse.kr(\impFreq.kr(0.5));
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

~src = Synth(\sin, [in: ~kbus, out: ~abus]);

~fx = Synth(\rev, [in: ~abus, out: 0], ~src, \addAfter);

~src.set(\freq, ~kbus.asMap);

~src.set(\freq, 400);

~src.free;

~fx.free;

s.scope;
s.reset;
~lfo = {Out.kr(~kbus, SinOsc.kr(\freq.kr(12)).range(200,1200));}.play;
~lfo.set(\freq, 60);
~src.set(\impFreq, 0.5);
~lfo.free;

~impbus = Bus.control(s, 1);
~src.set(\impFreq, ~impbus.asMap);

~impbus.value_(0.75);

~imp = {Out.kr(~impbus, SinOsc.kr(\freq.kr(0.1)).range(0.1, 4));}.play;

~imp.free;

//Emulating an Analog Synthesizer
s.boot;

(
s.newBusAllocators;

~bus = (); // this is an event
~bus.lfo = Bus.control(s, 1);
~bus.trig = Bus.control(s, 1);
~bus.env = Bus.control(s, 1);
~bus.vco = Bus.audio(s, 1);
~bus.vcf = Bus.audio(s, 1);
~bus.vca = Bus.audio(s, 1);


SynthDef(\lfo, {
	var sig = SinOsc.kr(\freq.kr(1)).unipolar(1);
	Out.kr(\out.kr(~bus.lfo), sig);
}).add;

SynthDef(\trig, {
	var sig = Impulse.kr(\freq.kr(1));
	Out.kr(\out.kr(~bus.trig), sig);
}).add;


SynthDef(\env, {
	var sig = Env.perc(\atk.kr(0.001), \rel.kr(0.5)
	).kr(0, \trig.kr(0));
	sig = sig * \amp.kr(1);
	Out.kr(\out.kr(~bus.env), sig);
}).add;


//oscillator
SynthDef(\vco, {
	var sig = Saw.ar(
		\freq.kr(0.1).linexp(0,1, \fmin.kr(20), \fmax.kr(20000))
	);
	Out.kr(\out.kr(~bus.vco), sig);
}).add;

SynthDef(\vcf, {
	var sig = In.ar(\in.kr(~bus.vco), 1);
	sig = MoogFF.ar(
		in: sig,
		freq: \freq.kr(1).linexp(0, 1, \fmin.kr(20), \fmax.kr(15000)),
		gain: 2
	);
	Out.kr(\out.kr(~bus.vcf), sig);
}).add;

SynthDef(\vca, {
	var sig = In.ar(\in.kr(~bus.vcf), 1);
	sig = sig * \amp.kr(1);
	Out.ar(\out.kr(~bus.vca), sig);
}).add;

SynthDef(\rev, {
	var sig = In.ar(~bus.vca, 1);
	sig = sig.blend(
		LPF.ar(GVerb.ar(sig, 200, 4), \lpf.kr(1200)),
		\mix.kr(0.2)
	);

	Out.ar(\out.kr(0), sig);
}).add;
)

(
~lfo = Synth(\lfo);
~trig = Synth.after(~lfo, \trig);
~env = Synth.after(~trig, \env);
~vco = Synth.after(~env, \vco);
~vcf = Synth.after(~vco, \vcf);
~vca = Synth.after(~vcf, \vca);
~rev = Synth.after(~vca, \rev);
)
s.reboot;

// i was checking around 27:12 because my version is not producing sound
