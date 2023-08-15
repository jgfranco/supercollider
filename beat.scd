// https://www.youtube.com/watch?v=gsAxCuUcy0o     @8:51
s.boot;
s.quit;
(
SynthDef(\kick, {
	var snd;
	snd = SinOsc.ar(50 * (1 + (16 * Env.perc(0.001, 0.3).ar)));
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
)
//

// snare
(
SynthDef(\bass, {
	var snd;
	snd = SinOsc.ar(\freq.kr(60) * (1 + (0.5 * Env.perc(0.01, 0.3).ar)));
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar + [0, 1]), 4600, 0.3) * -30.dbamp);
	snd = snd + ((snd * 10).tanh * -10.dbamp);
	snd = (snd * 1.dbamp).fold2;
	snd = snd * Env.perc(0, 1).ar;
	2.do {
		snd = snd + (PitchShift.ar(snd, 0.1, 2) * -10.dbamp);
		snd = (snd * 10.dbamp).tanh;
	};
	snd = LPF.ar(snd, 100) + HPF.ar(snd, 3000);
	snd = snd * Env.asr(0.3, 1, 0.3).ar(Done.freeSelf);
	snd = snd * \amp.kr(-10.dbamp);
	Out.ar(\out.kr(0), snd);
}).add;
)

Synth(\kick);

(
var s;
s = Server.default;
Routine({
	s.bind {
		Synth(\kick);
		Synth(\bass);
	};
}).play;
)

