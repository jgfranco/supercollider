s.boot;

// filters
BPF
BRF
LPF
HPF
RHPF
RLPF

(
{
	var sig;
	sig = PinkNoise.ar(0.3 !2);
	sig = HPF.ar(
		in: sig,
		freq: MouseX.kr(100, 6000).poll;
	);
}.play;
)

(
{
	var sig;
	sig = PinkNoise.ar(0.3 !2);
	sig = HPF.ar(
		in: sig,
		freq: SinOsc.ar(1).range(100, 2000);
	);
}.play;
)

(
{
	var sig;
	sig = PinkNoise.ar(0.3 !2);
	sig = LPF.ar(
		in: sig,
		freq: SinOsc.ar(1).range(100, 2000);
	);
}.play;
)

(
{
	var sig;
	sig = PinkNoise.ar(0.1 ! 2);
	sig = RHPF.ar(
		in: sig,
		freq: MouseX.kr(100, 2000).poll,
		rq: MouseY.kr(0.01, 1).poll
	);
}.play;
)



// range mapping

rrand(1,20).postln.linexp(1,20, 40, 1000);
rrand(1,20).postln.linlin(1,20, 300, 400);


(
var num;
num = (1..100);
[
	num,
	num.linexp(1, 100, 1, 100),
	num.explin(1, 100, 1, 100),
	num.lincurve(1, 100, 1, 100, -8)
].plot;
)

// how is the previous concept apply to signals?

(
{
	var sig;
	sig = SinOsc.ar([400, 402]);
	sig = sig.lincurve(-1, 1, -1, 1, 1);
	sig = sig * 0.2;
}.play;
)

(
{
	var sig;
	sig = SinOsc.ar([400, 402]);
	sig = sig.lincurve(-1, 1, -1, 1, MouseX.kr(0,5));
	sig = sig * 0.2;
}.play;
)


(
{
	var sig, mod;
	mod = LFNoise2.kr(1 ! 2).range(-10, 10);
	sig = SinOsc.ar([400, 402]);
	sig = sig.lincurve(-1, 1, -1, 1, mod);
	sig = sig * 0.2;
}.play;
)

s.freeAll;


(
{
	var sig, freq;
	freq = LFTri.kr(0.15, 3).range(50,1200).linexp(50, 1200, 50, 1200);
	sig = SinOsc.ar(freq + [0, 1], mul: 0.1);
}.play;
)

(
{
	var sig, freq;
	freq = LFTri.kr(0.15, 3).range(50,1200);
	sig = SinOsc.ar(freq + [0, 1], mul: 0.1);
}.play;
)

// left at 31 or 33 min




