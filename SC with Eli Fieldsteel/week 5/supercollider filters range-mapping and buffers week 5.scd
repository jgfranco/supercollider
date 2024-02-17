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
s.boot;

(
{
	var sig, freq;
	freq = LFTri.kr(0.15, 3).range(50,1200).linexp(50, 1200, 50, 1200);
	sig = SinOsc.ar(freq + [0, 1], mul: 0.2);
}.play;
)

(
{
	var sig, freq;
	freq = LFTri.kr(0.15, 3).range(50,1200);
	sig = SinOsc.ar(freq + [0, 1], mul: 0.2);
}.play;
)
// we use linexp to map values to a exponential layout beacuse we perceive sound in a logarithmic fashion
(
{
	var sig, freq;
	freq = LFTri.kr(0.15, 3).range(50,1200).linexp(50, 1200, 50, 1200);
	sig = SinOsc.ar(freq + [0, 1], mul: 0.2);
}.play;
)

(
{
	var sig, freq;
	freq = LFTri.kr(0.15, 3).exprange(50, 1200);
	sig = SinOsc.ar(freq + [0, 1], mul: 0.2);
}.play;
)

// chapter 4: sampling

// buffer is a block of memory that is set on the server
s.boot;
b = Buffer.read(server: s, path: "/Users/juangerardofranco/Documents/supercollider/SC with Eli Fieldsteel/week 5/w39.mp3");
b.play;

b.query; // provides info on the buffer, displayed on the post window

b.duration; // gives us the lenght of the buffer

b.bufnum; // BufDur.kr
b.numFrames; // BufFrames.kr
b.numChannels; //


thisProcess.nowExecutingPath;
PathName.new(thisProcess.nowExecutingPath).parentPath ++ "w39.mp3";

b.free;
Buffer.freeAll; // free's all buffers

s.options.numBuffers; // number of buffers allowed by the server to be created

(
~path = PathName.new(thisProcess.nowExecutingPath).parentPath ++ "w39.mp3";
b = Buffer.read(s, ~path);
)

b.play;

// buffer reading UGEN PlayBuf
(
{
	var sig;
	sig = PlayBuf.ar(
		numChannels: 2,
		bufnum: b,
		rate: BufRateScale.kr(b) * 0.midiratio,
		doneAction: Done.freeSelf;
	);
}.play;
)

(
{
	var sig;
	sig = PlayBuf.ar(
		numChannels: 2,
		bufnum: b,
		rate: BufRateScale.kr(b) * rrand(0, 1.0).midiratio, // 1.0 makes it microtonal
		doneAction: Done.freeSelf;
	);
}.play;
)

s.sampleRate;
b.sampleRate;

