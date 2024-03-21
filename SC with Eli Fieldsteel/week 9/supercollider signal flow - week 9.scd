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

Synth(\echo, [freq: rrand(65, 95).midicps, amp: 0.2]);


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

Synth(\src, [out: 19, freq: rrand(65,85).midicps]);

// using - like in the previous two lines - numbers for the busses can become quite complex if we have a large session with multiple synths and multiple effects. Thats why we have to introduce the Bus class, which handles busses for us

s.freeAll;

~toDelay = Bus.audio(s, 2);
c = Bus.audio(s, 2);

s.newBusAllocators; // resets the busses assigned via the Bus class

Synth(\echo, [in:~toDelay, out:0]);

Synth(\src, [out: ~toDelay, freq: [77, 78, 80,82, 84, 85, 87].choose.midicps]);


// Input/Output UGens

// microphone signals


// use headphones for the following excercise if using the computer mic and speaker
(
SynthDef(\mic, {
	var sig;
	//sig = In.ar(\in.ir(2), 1);
	sig = SoundIn.ar(\in.ir(0));
	sig = sig * \amp.kr(0.25);
	sig = sig ! 2;
	Out.ar(\out.ir(0), sig);
}).add;
)

Synth(\echo, [in:~toDelay, out:0]);
x = Synth(\mic, [out: ~toDelay, amp: 0.5]);
x = free;
s.scope;

// how to configure the server input and output structure:

s.options.numOutputBusChannels = 4;
s.options.numInputBusChannels = 4
s.reboot; // there's the need of rebooting the server so the changes take effect
s.meter;

s.boot;

// Order of Exexution

(
SynthDef(\src, {
	var sig, freq;
	freq = LFNoise0.kr([7,8]).range(45,84).midicps;
	sig = SinOsc.ar(freq);
	sig = sig * Env.adsr().ar(2, \gate.kr(1));
	sig = sig * \amp.ir(0.3);
	Out.ar(\out.ir(0), sig);
}).add;


SynthDef(\echo, {
	var sig;
	sig = In.ar(\in.ir(0), 2); // this will read from 19 and 20
	sig = sig + CombL.ar(sig, 0.2, 0.2, 4);
	Out.ar(\out.ir(0), sig);
}).add;
)


// if  you create the effect and then play the sound it should work just fine
~fx = Synth(\echo, [in:~toDelay, out:0]);
~src = Synth(\src, [out: ~toDelay]);

// on the other hand, if you play the instrument that is routed to the effect and then run the effect, it does not play anything
~src = Synth(\src, [out: ~toDelay]);
~fx = Synth(\echo, [in:~toDelay, out:0]);


~src.set(\gate, 0);
~fx.free;

// Groups, Targets, AddActions

~fxgrp = Group.new;
~srcgrp = Group.new;

~fx = Synth(\echo, [in:~toDelay, out:0], ~fxgrp);
~src = Synth(\src, [out: ~toDelay], ~srcgrp);

~src.set(\gate, 0);
~fx.free;

~fxgrp.free;
~srcgrp.free;

// left at 44:17
