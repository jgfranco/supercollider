s.scope;
s.boot;

(
~scale = Dictionary.newFrom([ \B3, 233, \C4, 261, \D4, 293, \E4, 331, \F4, 348, \G4, 391, \A4, 439, \B4, 493, \C5, 522, \D5, 586, \E5, 659, \D2, 72.5, \E2, 82.5,\F2,86.5, \G2, 98.5
]);

s.newBusAllocators;
~toDelay = Bus.audio(s, 2);
~toReverb = Bus.audio(s, 2);
~dbus = Bus.control(s, 1);
~pbus = Bus.control(s, 1);
~osc1mix = 0.5;
~osc2mix = 0;
~osc3mix = 0;
~filter = 20000;

SynthDef(\synth, {
	var sig, buf = \buf.ir(0);
	sig = SinOsc.ar(\freq.ir(200), mul: ~osc1mix);
	sig = sig + Saw.ar(\freq.ir(200), mul: ~osc2mix);
	sig = sig + VarSaw.ar(\freq.ir(200), mul: ~osc3mix);
	sig = MoogFF.ar(sig, ~filter, gain: 0.1);
	sig = sig * Env.adsr().ar(2, \gate.kr(1));
	sig = Pan2.ar(sig, \pan.ir(0), \amp.ir(1));
	Out.ar(\out.ir(0), sig);
}).add;

SynthDef(\bass, {
	var sig, buf = \buf.ir(0);
	sig = SinOsc.ar(\freq.ir(200), mul: ~osc1mix);
	sig = sig + Saw.ar(\freq.ir(200), mul: ~osc2mix/2);
	sig = sig + VarSaw.ar(\freq.ir(200), mul: ~osc3mix/2);
	sig = MoogFF.ar(sig, ~filter, gain: 0.1);
	sig = sig * Env.adsr().ar(2, \gate.kr(1));
	sig = Pan2.ar(sig, \pan.ir(0), \amp.ir(1));
	Out.ar(\out.ir(0), sig);
}).add;



//FX
SynthDef(\echo, {
	var sig;
	sig = In.ar(\in.ir(0), 2);
	sig = sig + CombL.ar(sig ,maxdelaytime: 0.2, delaytime: \dly.kr(0.1), decaytime: 4);
	sig = sig * \amp.kr(0.5);
	Out.ar(\out.ir(0), sig);

}).add;

SynthDef(\rev, {
	var sig = In.ar(\in.ir(0), 2);
	sig = JPverb.ar(sig, t60: 5, damp: \damp.kr(0.8), size: \size.kr(5),lowcut: \lc.kr(500), highcut: \hc.kr(20000));
	//sig = sig * \amp.kr(1);
	sig = Pan2.ar(sig, \pan.ir(0), \amp.ir(1));
	Out.ar(\out.ir(0), sig);
}).add;

//LFO
//
SynthDef(\lfo, {
	var sig;
	sig = SinOsc.kr(0.1).exprange(0.1, 0.12);
	Out.kr(\out.kr(0), sig);
}).add;
//pitch
SynthDef(\lfo2, {
	var sig;
	sig = SinOsc.kr(0.25).bipolar(1);
	Out.kr(\out.kr(0), sig);
}).add;

)



// fx
(
~lfo = Synth(\lfo, [out: ~dbus]);
~lfo2 = Synth(\lfo2, [out: ~pbus]);
~reverb = Synth(\rev, [in: ~toReverb, out:0, pan: ~pbus.asMap]);
~echo = Synth(\echo, [in: ~toDelay, out:0, \dly: ~dbus.asMap]);
)


~bass.mute;

~bass.unmute;
~arp.mute;
~arp.unmute;
~rand.unmute;
~rand.mute;

//patterns
(
~pat0 = Pbind(
	\instrument, \synth,
	\dur, Pseq([0.125, 0.25], inf),
	\db, Pexprand(-30, -25, inf),
	\freq, Pseq([Prand([~scale.at(\A4), ~scale.at(\A4), ~scale.at(\C5), ~scale.at(\D5)], 4),
		Prand([~scale.at(\A4), ~scale.at(\A4), ~scale.at(\C5), ~scale.at(\D5)], inf)], 4),
	\pan, Prand([-1, -0.8,-0.6, 0.6,0.8, 1], inf),
	\sustain, Pexprand(0.01, 0.5, inf),
	\lpf, Pexprand(5000, 10000, inf),
	\out, Pwrand([2, 0, Prand([~toDelay, ~toReverb], 1)], [5,5,2].normalizeSum, inf);
);
~rand = ~pat0.play;



~pat1 = Pbind(
	\instrument, \synth,
	\dur, Pseq([0.25, 0.5], inf),
	\db, Pexprand(-30, -25, inf),
	\freq, Pseq([
	Prand([~scale.at(\G4), ~scale.at(\A4), ~scale.at(\C5)], 4),
	Prand([~scale.at(\A4), ~scale.at(\B4), ~scale.at(\E5)], 4)], inf),
	\sustain, Pexprand(0.2, 0.4, inf),
	\lpf, Pexprand(1000, 20000, inf),
	\pan, Prand([-0.3,-0.2, -0.1 , 0.1, 0.2, 0.3], inf),
	\out, Pwrand([~toDelay, 0, 2, ~toReverb], [1,30,5, 1].normalizeSum, inf);
);
~arp = ~pat1.play;
~arp.mute;


//bass
~pat2 = Pbind(
	\instrument, \bass,
	\dur, Pseq([Pseq([0.25, 1, 0.5], 8)],inf),
	\db, Pexprand(-20, -10, inf),
	\freq, Pseq([
		Pseq([~scale.at(\F2)], 8),
		Pseq([~scale.at(\G2)], 8),
		Pseq([~scale.at(\F2)], 8),
		Pseq([~scale.at(\G2)], 8),
		Pseq([~scale.at(\D2)], 8),
		Pseq([~scale.at(\C4)]/4, 8),
	],inf),
	\sustain, Pexprand(0.1, 0.2, inf),
	\pan, 0,
	\out, 0;
 );
~bass  = ~pat2.play;
// ~bass.mute;
)
