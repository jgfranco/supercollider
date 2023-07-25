s.boot;
(
SynthDef(\kick, {
	var snd;
	//snd = SinOsc.ar(60);

	//laser kick, this is btw modifying the oscillator to give it a clicky sound. this is used instead of the chirp

	//snd = SinOsc.ar(50 *(1+ (8* Env.perc(0, 0.3, curve: -8).ar)) * (1 +(8*Env.perc(0, 0.1).ar)));//frequency of the kick 60 Hz

	// main Sin
	snd = SinOsc.ar(55
		* (1+ (4 * Env.perc(0, 0.13, curve: -8).ar))
		* XLine.ar(1,0.5, 1)); //slide down

	//chirp (add a clicking noise to the kick)
	snd = snd + (SinOsc.ar(XLine.ar(4000,50.01))
		* Env.perc(0.0001, 0.01).ar
		* -5.dbamp);

	// add white noise
	/*snd = snd + (BPF.ar(WhiteNoise.ar, 10120,0.3)
		* (Env.perc(0.001,0.02).ar
			* -8.dbamp));*/

	//instead of white noise. we can use Hasher with Sweep, which makes the noise 100% deterministic
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 10120,0.5)
		* (Env.perc(0.001,0.03).ar
			* -8.dbamp));


	// drive the tanh harder at the beginning and less at the end
	snd = snd * (1 + (2 * Env.perc(0.001, 0.2).ar));

	// add distortion
	//snd = ((snd * 3.dbamp) + 0.3).tanh; // asymmetrical distortion
	snd = (snd * 0.dbamp).tanh;

	// shape the kick with an Envelope
	snd = snd * Env.perc(0.001,1.3, curve: -8).ar(Done.freeSelf);

	// decrease amplitud by 10db
	snd = snd * -5.dbamp;

	// pan center
	snd = Pan2.ar(snd, \pan.kr(0));

	//snd.scope;
	// connect to output
	Out.ar(\out.kr(0), snd);
}).add;
)
//
Synth(\kick)


Env.perc(0.001,1.3, curve: -8).plot;
Env.perc(0.001,1.3, curve: -4).plot;
Env.perc(0.001,1.3, curve: -1).plot;


