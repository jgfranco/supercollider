
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