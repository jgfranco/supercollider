s.boot;
(
SynthDef(\kick, {
	var snd;
	snd = SinOsc.ar(55 * (1+ (4 * Env.perc(0, 0.13, curve: -8).ar)) * XLine.ar(1,0.5, 1));
	snd = snd + (SinOsc.ar(XLine.ar(4000,50.01)) * Env.perc(0.0001, 0.01).ar * -5.dbamp);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 10120,0.5) * (Env.perc(0.001,0.03).ar * -8.dbamp));
	snd = snd * (1 + (2 * Env.perc(0.001, 0.2).ar));
	snd = (snd * 0.dbamp).tanh;
	snd = snd * Env.perc(0.001,1.3, curve: -8).ar(Done.freeSelf);
	snd = snd * -5.dbamp;
	snd = Pan2.ar(snd, \pan.kr(0));
	Out.ar(\out.kr(0), snd);
}).add;
)
//
Synth(\kick)



// for a more acousting sounding kick, layer many sine waves

(
SynthDef(\kick2, {
	var snd;
	snd = SinOsc.ar(55 * (1+ (4 * Env.perc(0, 0.13, curve: -8).ar))
		* XLine.ar(1,0.5, 1)
		* [1, 1.3, 3.4, 4.8]);
	snd = snd * [0, -10, -5, -8].dbamp;
	snd = snd * Env.perc(0, [1, 0.3, 0.1, 0.03]).ar;
	snd = snd.sum;
	snd = snd + (SinOsc.ar(XLine.ar(4000,50.01)) * Env.perc(0.0001, 0.01).ar * -5.dbamp);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 10120,0.5) * (Env.perc(0.001,0.03).ar * -8.dbamp));
	snd = snd * (1 + (2 * Env.perc(0.001, 0.2).ar));
	snd = (snd * 0.dbamp).tanh;
	snd = snd * Env.perc(0.001,1.3, curve: -8).ar(Done.freeSelf);
	snd = snd * -5.dbamp;
	snd = Pan2.ar(snd, \pan.kr(0));
	Out.ar(\out.kr(0), snd);
}).add;
)
//
Synth(\kick2)

Env.perc(0.001,1.3, curve: -8).plot;
Env.perc(0.001,1.3, curve: -4).plot;
Env.perc(0.001,1.3, curve: -1).plot;
