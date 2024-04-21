s.scope;

//synths
(
                           // \B3, 257, \C4, 262, \D4, 294, \E4, 330, \F4, 349, \G4, 392, \A4, 440, \B4, 494, \C5, 523, \D5, 587, \D2, 73, \E2, 82,\F2,87, \G2, 98
~scale = Dictionary.newFrom([ \B3, 258, \C4, 261, \D4, 293, \E4, 331, \F4, 348, \G4, 393, \A4, 439, \B4, 495, \C5, 522, \D5, 586, \D2, 72.5, \E2, 82.5,\F2,86.5, \G2, 98.5
]);

s.newBusAllocators;
~toDelay = Bus.audio(s, 2);
~toReverb = Bus.audio(s, 2);"/Users/juangerardofranco/Desktop/D/"
~dbus = Bus.control(s, 1);
~pbus = Bus.control(s, 1);
~osc1mix = 1;                                     // 1
~osc2mix = 0;                                       // 0.5
~osc3mix = 0;                                       // 1
~filter = 5000;                                    //5000

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
	sig = sig * \amp.kr(1);
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

)



// fx
(
~lfo = Synth(\lfo, [out: ~dbus]);
~lfo2 = Synth(\lfo2, [out: ~pbus]);
~reverb = Synth(\rev, [in: ~toReverb, out:0]);
~echo = Synth(\echo, [in: ~toDelay, out:0, \dly: ~dbus.asMap]); // sweep delaytime from 0.1 to 0.5

)

~pbus;

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
	\freq, Prand([~scale.at(\E4), ~scale.at(\F4), ~scale.at(\G4)], inf),
	\pan, Prand([-1, -0.8,-0.6, 0.6,0.8, 1], inf),
	\sustain, Pexprand(0.01, 1.0, inf),
	\lpf, Pexprand(5000, 10000, inf),
	\out, Pwrand([~toDelay, 0, 2, ~toReverb], [1,10, 10,1].normalizeSum, inf);
);
~rand = ~pat0.play;

// arp lead
~pat1 = Pbind(
	\instrument, \synth,
	\dur, 0.3,
	\db, Pexprand(-30, -15, inf),
	\freq, (Pseq([
		Pseq([~scale.at(\D4), Prand([~scale.at(\C5), ~scale.at(\A4)], 1), ~scale.at(\F4)], 5),
		Pseq([~scale.at(\C4), Prand([~scale.at(\G4),~scale.at(\A4)], 1), ~scale.at(\F4)],7),
		Pseq([Pwrand([~scale.at(\F4), ~scale.at(\G4)], [7, 3], 1), ~scale.at(\F4), ~scale.at(\D4)], 3),
		Pseq([~scale.at(\G4), ~scale.at(\F4), Pwrand([~scale.at(\C4), ~scale.at(\B3)], [6, 5], 1), ~scale.at(\F4)], 5)
	],inf)),
	\sustain, Pexprand(0.2, 0.4, inf),
	\lpf, Pexprand(1000, 20000, inf),
	\pan, Prand([-0.3,-0.2, -0.1 , 0.1, 0.2, 0.3], inf),
	\out, Pwrand([~toDelay, 0, 2, ~toReverb], [1,30,5, 1].normalizeSum, inf);
);
~arp = ~pat1.play;


//bass
~pat2 = Pbind(
	\instrument, \bass,
	\dur, Pseq([
		Pseq([0.6], 32),
		Pseq([0.3], 1)
	],inf),
	\db, Pexprand(-20, -10, inf),
	\freq, Pseq([
		Pseq([~scale.at(\D2)], 8),
		Pseq([~scale.at(\F2)], 8),
		Pseq([~scale.at(\E2)], 8),
		Pseq([~scale.at(\G2)], 8);
	],inf),
	\sustain, 0.1,
	\pan, 0,
	\out, 0;
 );
~bass  = ~pat2.play;
)

38.midicps.postln;


