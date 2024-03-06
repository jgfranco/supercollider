s.boot;
s.reboot;
s.quit;

s = Server.local; // this happens by default, theres no need to do it, only if you reassign s by mistake to another thing



(
x = {
	//PinkNoise.ar * 0.2 ;
	PinkNoise.ar * -10.dbamp ;
	//Saw.ar * -20.dbamp;
	//SinOsc.ar * -10.dbamp;
	//Pulse
	//Saw
	//LFTri
	//Impulse
	//WhiteNoise
	//BrownNoise
	//ClipNoise

	// ar audio rate
	// kr
	// ir

}.play;
)

// panic button [cmd] + [period]


(
x = {
	PinkNoise.ar(-20.dbamp);
}.play;
)

(
x = {
	LFTri.ar(freq: 200, iphase: 0, mul: -15.dbamp) ;
}.play;
)

(
x = {
	LFTri.ar(freq: 200, iphase: 0, mul: -15.dbamp) ;
}.play;
)

s.meter;


(
x = {
	//LFNoise0.ar(1000);
	//LFNoise1.ar(1000);
	LFNoise2.ar(1000);
}.plot;
)
//example of modulation using a triangle signal
(
x = {
	var mod, sig, modmod;
	modmod = LFNoise0.kr(freq: 5).range(1,10);
	mod = LFTri.kr(modmod)*200;
	sig = SinOsc.ar(200 + mod);
	sig = sig * -1.dbamp;
}.play;
)

(
x = {
	var mod, sig;
	mod = LFNoise0.kr(freq: 4).range(200,2000);
	sig = SinOsc.ar(mod);
	sig = sig * -20.dbamp;
}.play;
)





(
x = {
	var mod, sig;
	mod = LFPulse.kr(freq: 4).range(900,1200);

	sig = SinOsc.ar(freq: mod);
	sig = sig * -20.dbamp;

}.play;
)

{LFPulse.ar(100)}.plot(0.5);
x.free;




(
x = {
	var sig;

	sig = [SinOsc.ar(freq: 400), SinOsc.ar(1000)];
	sig = sig * -20.dbamp;

}.play;
)

x.free;

// shift Command D : multichannel expansion

(
x = {
	var sig;

	sig = SinOsc.ar(freq: [ 301, 300]);
	//sig = sig * -20.dbamp;
	sig = sig * [-20, -10].dbamp;
}.play;
)



{exprand(100, 8000)} ! 8;
(
x = {
	var sig;
	sig = SinOsc.ar(freq: {exprand(100, 4000)} ! 8);
	sig = sig * -30.dbamp;
	sig = sig.sum;
	sig = sig ! 2;
}.play;
)

x.release(4);


s.reboot;
(
x.release(2);
x = {
	var sig;
	var f, notes, chord;

	notes = [0, 2, 4, 6, 7, 9, 11];
	chord = notes.scramble.keep(4);

	f = {440 * (2.pow(1/12)).pow(notes[rrand(0,6)])} ! 4;
	f.postln;
	sig = SinOsc.ar(freq: f);
	sig = Splay.ar(sig);
	sig = sig * -30.dbamp;
}.play;


)


























