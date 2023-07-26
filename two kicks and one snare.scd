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




// for a more acousting sounding kick, layer many sine waves

(
SynthDef(\kick2, {
	var snd;
	snd = SinOsc.ar(60 * (1+ (8 * Env.perc(0, 0.06, curve: -4).ar))
		* XLine.ar(1,0.9, 1)
		* [1, 1.3, 2.4, 2.6, 2.8, 3.3,  3.4]);
	snd = snd * [0, -10, -5, -19, -15, -20, -15].dbamp;
	snd = snd * Env.perc([0.01, 0.01, 0.015, 0.01, 0.03, 0.01, 0.02] * 0.5, [1, 0.3, 0.1, 0.03, 0.05, 0.03, 0.06] * 3).ar;
	snd = snd.sum;
	snd = snd + (BPF.ar(WhiteNoise.ar, 7120, 0.5) * Env.perc(0.001, 0.01).ar * -8.dbamp);
	snd = snd + (BPF.ar(WhiteNoise.ar, 3120, 0.3) * Env.perc(0.001, 0.08).ar * -8.dbamp);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 10120,0.5) * (Env.perc(0.001,0.03).ar * -8.dbamp));
	snd = LeakDC.ar(snd);
	snd = (snd * 4.dbamp).tanh;
	snd = snd + (GVerb.ar(snd, 6, 1) * -30.dbamp);
	snd = snd * Env.perc(0.001,1.3, curve: -6).ar(Done.freeSelf);
	snd = snd * -5.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;
)


// snare
(
SynthDef(\snare, {
	var snd;
	snd = SinOsc.ar(200 * (1 + (2 *Env.perc(0.001, 0.03).ar)) * [1, 2.3, 3.5, 5.8]);
	snd = snd * Env.perc(0,[2, 0.4, 0.2, 0.1]).ar;
	snd = snd * [0, -20, -12, -24].dbamp;
	snd = snd.sum;
	snd = snd + (SinOsc.ar(XLine.ar(3000, 100, 0.03)) * Env.perc(0.01, 0.03).ar);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 2120,0.3) * (Env.perc(0.05,0.1).ar * -3.dbamp));
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 4220,0.6) * (Env.perc(0.003,0.1).ar * -8.dbamp));
	snd =  snd + ((snd * 13.dbamp).tanh * -10.dbamp); // parallel distortion
	snd = snd + LPF.ar(PitchShift.ar(snd, 0.005, 1.8) * -4.dbamp, 3000);

	snd = snd * Env.perc(0.001,0.6, curve: -4).ar;
	snd = BHiShelf.ar((LPF.ar(snd, 8000) * 2.dbamp).tanh, 8000, 10);
	// snd =  (snd * 20.dbamp).tanh; // distortion applied on the whole signal
	/*snd = snd * (1 + (0.3* Env.perc(0.001, 0.03).ar));
	snd = snd.tanh;*/

	snd = snd + (GVerb.ar(snd, 16, 2) * -30.dbamp);
	snd = snd * Env.perc(0.001,1, curve: -4).ar(Done.freeSelf);
	snd = snd * -5.dbamp;
	Out.ar(\out.kr(0), snd);
}).add;
)

Synth(\kick)
Synth(\kick2)
Synth(\snare)

Env.perc(0.001,1.3, curve: -8).plot;
Env.perc(0.001,1.3, curve: -4).plot;
Env.perc(0.001,1.3, curve: -1).plot;
