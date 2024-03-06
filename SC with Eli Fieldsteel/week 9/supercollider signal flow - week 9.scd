s.boot;

(
SynthDef(\echo, {
	var sig;
	sig = SinOsc.ar(\freq.ir(500) + [0,3]);
	sig = sig * Env.perc(0.001, \rel.ir(1), 1, \crv.ir(-10)).ar(2);
	sig = sig * \amp.ir(0.3);
	Out.ar(\out.ir(0), sig);
}
).add;
)

Synth(\echo, [freq: rrand(45, 85).midicps, amp: 0.2]);


(
SynthDef(\echo, {
	var sig, fx;
	sig = SinOsc.ar(\freq.ir(500) + [0,3]);
	sig = sig * Env.perc(0.001, \rel.ir(1), 1, \crv.ir(-10)).ar(2);
	fx = CombL.ar(sig,maxdelaytime: 0.2, delaytime: 0.2, decaytime: 4);
	sig = sig + fx;
	sig = sig * \amp.ir(0.3);
	Out.ar(\out.ir(0), sig);
}
).add;
)

Synth(\echo, [freq: rrand(45, 85).midicps, amp: 0.2]); // the effect gets cutoff because the synth that generates the sound (and actually contains the fx) is shorter than the delay


(
SynthDef(\echo, {
	var sig;
	sig = SinOsc.ar(\freq.ir(500));
	sig = sig * Env.perc(0.001, \rel.ir(1), 1, \crv.ir(-10)).ar(2);
	sig = sig * \amp.ir(0.3);
	Out.ar(\out.ir(0), sig);
}
).add;
)

Synth(\echo, [freq: rrand(45, 85).midicps, amp: 0.2, out: 0]);
Synth(\echo, [freq: rrand(45, 85).midicps, amp: 0.2, out: 5]); // you can see the visual representation in s.scope and incrementing the number of channels



// Busses

s.scope;

s.options.numAudioBusChannels; // we have 1024 busses at our disposal
s.options.numOutputBusChannels; // we have to ouput channels
s.options.numInputBusChannels; // and two input channels
s.options.numPrivateAudioBusChannels; // so if you remove the output channels and input channels you are left with 1020 channels of "private" use

(
SynthDef(\src, {
	var sig;
	sig = SinOsc.ar(\freq.ir(500) + [0,3]);
	sig = sig * Env.perc(0.001, \rel.ir(1), 1, \crv.ir(-10)).ar(2);
	sig = sig * \amp.ir(0.3);
	Out.ar(\out.ir(0), sig);
}).add;


SynthDef(\echo, {
	var sig;
	sig = In.ar(\in.ir(19), 2); // this will read from 19 and 20
	sig = sig + CombL.ar(sig, 0.2, 0.2, 4);
	Out.ar(\out.ir(0), sig);
}).add;
)

Synth(\echo, [in:19, out:0]);

Synth(\src, [out: 19, freq: rrand(50,80).midicps]);


// left at 18:55

// Input/Output UGens	