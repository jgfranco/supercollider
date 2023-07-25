s.boot;
(
SynthDef(\kick, {
	var snd;
	//snd = SinOsc.ar(60);

	//laser kick??
	//snd = SinOsc.ar(50 *(1+ (8* Env.perc(0, 0.3, curve: -8).ar)) * (1 +(8*Env.perc(0, 0.1).ar)));//frequency of the kick 60 Hz

	// main Sin
	snd = SinOsc.ar(50 *(1+ (8* Env.perc(0, 0.3, curve: -8).ar)));

	//chirp
	snd = snd + (SinOsc.ar(XLine.ar(4000,50.01)) * Env.perc(0.0001, 0.01).ar * -10.dbamp);

	// add white noise
	snd = snd + (BPF.ar(WhiteNoise.ar, 10120,0.1) * (Env.perc(0.001,0.03).ar));

	snd = snd * Env.perc(0.001,0.7).ar(Done. freeSelf); // shape the kick with an Envelope
	snd = snd * -10.dbamp; // decrease amplitud by 10db?
	snd = Pan2.ar(snd, \pan.kr(0)); // pan center
	Out.ar(\out.kr(0), snd); // connect to output
}).add;
)
//
Synth(\kick);
