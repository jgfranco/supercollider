s.scope;
s.boot;
s.reboot;
s.makeWindow;

//synths
(
~scale = Dictionary.newFrom([ \Fs4, 369.99, \Gs4, 415.3, \A4, 439, \As4, 466.16, \B4, 493.88, \Cs5, 554.37, \D5, 587.33, \E5, 659.25, \Fs2, 739.99, \D2, 739.99, \E2, 82.41,\Fs2, 92.5, \A2, 110, \B2, 123.47
]);

s.newBusAllocators;
~toDelay = Bus.audio(s, 2);
~toReverb = Bus.audio(s, 2);
~dbus = Bus.control(s, 1);
~pbus = Bus.control(s, 1);
~osc1mix = 1;
~osc2mix = 0.5;
~osc3mix = 1;
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
	sig = sig * \amp.kr(0.5);
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
	sig = SinOsc.kr(1).bipolar(1);
	Out.kr(\out.kr(0), sig);
}).add;

(
SynthDef(\mic, {
	var sig;
	sig = In.ar(\in.ir(2), 1);
	sig = LPF.ar(sig, 4000);
	sig = sig * \amp.kr(0.25);
	sig = sig ! 2;
	Out.ar(\out.ir(0), sig);
}).add;
)
)



// fx
(
~lfo = Synth(\lfo, [out: ~dbus]);
~lfo2 = Synth(\lfo2, [out: ~pbus]);
~reverb = Synth(\rev, [in: ~toReverb, out:0]);
~echo = Synth(\echo, [in: ~toDelay, out:0, \dly: ~dbus.asMap]);
//~mic = Synth(\mic, [out: 0, amp: 1]);
)


//RUN
(
~rand = ~pat0.play;
~arp = ~pat1.play;
~bass  = ~pat2.play;
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
	\dur, 0.15,
	\db, Pexprand(-30, -15, inf),
	\freq, Prand([~scale.at(\E5), ~scale.at(\Fs4), ~scale.at(\Gs4)], inf),
	\pan, Prand([-1, -0.8,-0.6, 0.6,0.8, 1], inf),
	\sustain, Pexprand(0.01, 1.0, inf),
	\lpf, Pexprand(5000, 10000, inf),
	\out, Pwrand([~toDelay, 0, 2, ~toReverb], [1,10, 10,1].normalizeSum, inf);
);
~rand = ~pat0.play;

// arp lead
~pat1 = Pbind(
	\instrument, \synth,
	\dur, 1,
	\db, Pexprand(-30, -15, inf),
	\freq,Pseq([~scale.at(\Cs5), ~scale.at(\Fs4)], inf) ,
	\sustain, 0.2,
	\lpf, Pexprand(1000, 20000, inf),
	\pan, Prand([-0.3,-0.2, -0.1 , 0.1, 0.2, 0.3], inf),
	\out, Pwrand([~toDelay, 0, 2, ~toReverb], [1,30,5, 1].normalizeSum, inf);
);
~arp = ~pat1.play;


//bass
~pat2 = Pbind(
	\instrument, \bass,
	\dur, 4,
	\db, Pexprand(-20, -10, inf),
	\freq, ~scale.at(\Fs2),inf),
	\sustain, 0.1,
	\pan, 0,
	\out, 0;
 );
~bass  = ~pat2.play;
)



