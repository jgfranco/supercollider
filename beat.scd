// https://www.youtube.com/watch?v=gsAxCuUcy0o     @16:00
s.boot;
s.quit;
(
SynthDef(\kick, {
	var snd;
	snd = SinOsc.ar(50 * (1 + (4 * Env.perc(0.001, 0.3, curve: -8).ar)));
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 8600,0.3) * -15.dbamp * Env.perc(0.05,0.3).ar);
	snd = snd + ((snd * 10.dbamp).tanh * -10.dbamp);
	snd = snd + ((snd * 3.dbamp).fold2 * -10.dbamp);
	snd = snd + (snd * 10).tanh;
	snd = snd + snd.fold2;
	snd = (snd * (1 + Env.perc(0.001, 0.1).ar)).clip2;
	snd = snd * Env.perc(0.001, 0.2).ar(Done.freeSelf);
	snd = snd * \amp.kr(-10.dbamp);
	snd = Pan2.ar(snd, \pan.kr(0));
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\bass, {
	var snd;
	snd = SinOsc.ar(\freq.kr(60) * (1 + (0.5 * Env.perc(0.01,\pitchDecay.kr(0.5)).ar)));
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar + [0, 1]), 4600, 0.3) * -30.dbamp);
	snd = snd + ((snd * 10).tanh * -10.dbamp);
	snd = (snd * 1.dbamp).fold2;
	snd = snd * Env.perc(0, \timbreDecay.kr(3)).ar;
	2.do {
		snd = snd + (PitchShift.ar(snd, 0.1, 2) * -10.dbamp);
		snd = (snd * 10.dbamp).tanh;
	};
	snd = LPF.ar(snd, 100) + HPF.ar(snd, 3000);
	snd = snd * Env.asr(0.3, 1, 0.3).ar(Done.freeSelf, \gate.kr(1));
	snd = snd * \amp.kr(-10.dbamp);
	snd = Pan2.ar(snd, \pan.kr(0));
	Out.ar(\out.kr(0), snd);
}).add;
// snare
SynthDef(\snare, {
	var snd;
	snd = SinOsc.ar(210 * (1 + (1 *   Env.perc(0.001, 0.1).ar)) * [1, 1.75, 2.6, 4.3]);
	snd = snd * Env.perc(0.001, [1, 0.3, 0.2, 0.1]).ar;
	snd = snd.sum;
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 2100,0.3) * -5.dbamp * Env.perc(0.05,0.3).ar);
	snd = snd + LPF.ar((snd * 20.dbamp).tanh, 8000);
	snd = snd + (CombC.ar(snd, 0.1, 1/120, 0.3) * -10.dbamp);
	snd = snd + PitchShift.ar(snd, 0.03, 2.6);
	snd = snd + PitchShift.ar(snd, 0.05, 3.6);
	snd = snd * (1+ (SinOsc.ar(1400) * -5.dbamp));
	snd = snd * (1+ (SinOsc.ar(5000) * -10.dbamp));
	snd = snd * Env.perc(0.001, 0.3, curve:-2).ar(Done.freeSelf);
	snd = snd * \amp.kr(-15.dbamp);
	snd = Pan2.ar(snd, \pan.kr(0));
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\snare2, {
	var snd;
	snd = WhiteNoise.ar();
	snd = snd * Env.perc(0.001, 0.18, curve: -8).ar;
	snd = snd + LPF.ar((snd * 20.dbamp).tanh, 3000);
	snd = snd + HPF.ar(snd, 500);
	snd = snd * \amp.kr(-5 .dbamp);
	snd = Pan2.ar(snd, \pan.kr(0));
	Out.ar(\out.kr(0), snd);
}).add;
)

Synth(\snare2)

Synth(\kick);

(
var s, bpm, beat;
s = Server.default;
bpm = 140;
beat = 60 / bpm;
Routine({
	var bass;
	loop {
		s.bind {
			Synth(\kick);
			bass = Synth(\bass);
		};
		(beat*2).wait;
		s.bind{
			bass.set(\gate, 0);
			Synth (\snare);
		};
		(beat*3).wait;
		s.bind {
			Synth(\kick);
			bass = Synth(\bass);
		};
		(beat * 1).wait;
		s.bind{
			bass.set(\gate, 0);
			Synth(\snare);
		};
		(beat *2).wait;
	};
}).play;
)

