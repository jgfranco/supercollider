s.boot;
(
SynthDef(\kick, {
	var snd;
	//snd = SinOsc.ar(60);

	//laser kick, this is btw modifying the oscillator to give it a clicky sound. this is used instead of the chirp

	//snd = SinOsc.ar(50 *(1+ (8* Env.perc(0, 0.3, curve: -8).ar)) * (1 +(8*Env.perc(0, 0.1).ar)));//frequency of the kick 60 Hz

	// main Sin
	snd = SinOsc.ar(50 *(1+ (8* Env.perc(0, 0.3, curve: -8).ar)));

	//chirp (add a clicking noise to the kick)
	snd = snd + (SinOsc.ar(XLine.ar(4000,50.01)) * Env.perc(0.0001, 0.01).ar * -10.dbamp);

	// add white noise
	snd = snd + (BPF.ar(WhiteNoise.ar, 10120,0.3) * (Env.perc(0.001,0.03).ar));


	// add distortion
	snd = (snd * 3.dbamp).tanh;

	// shape the kick with an Envelope
	snd = snd * Env.perc(0.001,0.8).ar(Done. freeSelf);

	// decrease amplitud by 10db
	snd = snd * -10.dbamp;

	// pan center
	snd = Pan2.ar(snd, \pan.kr(0));

	// connect to output
	Out.ar(\out.kr(0), snd);
}).add;
)
//
Synth(\kick);
