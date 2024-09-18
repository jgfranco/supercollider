
// additive synthesis by way of manual sign summation
(
{
	var sig;
	sig = SinOsc.ar(200, mul: 0.15);
	sig = sig + SinOsc.ar(400, mul:0.1);
	sig = sig + SinOsc.ar(600, mul:0.05);
	sig = sig + SinOsc.ar(800, mul:0.025);
	sig = sig !2;
}.play;
)

s.scope;

// using do to rewrite the previous function

(
{
	var sig = 0, freqs = [200, 400, 600, 800];
	freqs.do({ |f, i|
		sig =sig + SinOsc.ar(f, mul: 0.2 / 2.pow(i));

	});
	sig = sig !2;
}.play;
)

//using collect to rewrite the previous function

(
{
	var sig = 0, freqs = [200, 400, 600, 800];
	sig = freqs.collect({ |f, i|
		SinOsc.ar(f, mul: 0.2 / 2.pow(i));
	});
	sig.postcs;
	sig = sig.sum;
	sig = sig !2;
}.play;
)

// use of blip to generate an additive spectrum

(
{
	var sig, harm;
	harm = LFTri.kr(0.1, 3).range(1, 50);
		sig = Blip.ar([120,121], harm);
		sig = sig *0.1;
}.play;
)
s.reboot;
// an additive synthesis example using Klang

(
{
	var sig;
	sig = Klang.ar(
		`[Array.exprand(40, 50, 8000).sort,
			Array.exprand(40, 0.001, 0.05).sort.reverse,
			Array.rand(40, 0, 2pi)
		]
	);
	sig = sig ! 2;
}.play;
)

// an additive synthesis example using DynKlang

(
{
	var sig, freqs, amps, phases;
	freqs = Array.exprand(40, 80, 8000).sort; // min value was originally 50, but it sounded to rumbly in my headphones
	amps = Array.exprand(40, 0.005, 0.2).sort.reverse;
	phases = Array.rand(40, 0, 2pi);
	sig = DynKlang.ar(`[
		freqs * LFNoise1.kr(0.02 ! 40).exprange(0.25, 2),
		amps * LFNoise1.kr(1 ! 40).exprange(0.02, 1),
		phases
	]);
	sig = sig ! 2;
}.play;
)

// modulation synthesis

// modulating the frequency of a low pass filter to create a "wah-wah" effect.

(
{
var sig, mod;
mod = SinOsc.ar(4, 3pi/2).range(0, 3000);
sig = Pulse.ar([90,91]);
	sig = LPF.ar(sig, 200 + mod);
	sig = sig * 0.1;
}.play;


)


// using LeakDC and Limiter to avoid signals that can be problematic for speakers

(
{
var sig, mod;
mod = SinOsc.ar(4, 3pi/2).range(0, 3000);
sig = Pulse.ar([90,91]);
	sig = LPF.ar(sig, 200 + mod);
	sig = sig * 0.1;
	sig = Limiter.ar(sig, level: 0.1);
	sig = LeakDC.ar(sig);
}.play;
)

// amplitude modilation with a gradyually increasing modulator frequency

(
{
	var sig, mod, modHz;
	modHz = XLine.kr(1, 150, 10);
	mod = SinOsc.ar(modHz).range(0, 1);
	sig = SinOsc.ar(750, mul: mod);
	sig = sig * 0.2 !2;

	sig = Limiter.ar(sig, level: 0.1);
	sig = LeakDC.ar(sig);
}.play;
)

// ring modulation with a gradually increasing modulator frequency
(
{
	var sig, mod, modHz;
	modHz = XLine.ar(1, 150, 10);
	mod = SinOsc.ar(modHz).range(-1, 1);
	sig = SinOsc.ar(750, mul:mod);
	sig = sig * 0.2 ! 2;
	sig = Limiter.ar(sig, level: 0.1);
	sig = LeakDC.ar(sig);
}.play;
)

{SinOsc.ar(XLine.ar(1, 150, 10))}.plot(10);



