s.boot;
(
x = {
	var sig;
	sig = VarSaw.ar(freq: [300, 301], width: 0.9);
	sig = sig * -20.dbamp;
}.play;
)

x.release(3);
// Arguments
(
x = {
	arg freq = #[300,301], wdt = 0.9, amp = 0.1; // hash on the array to make the array a literal
	var sig;
	sig = VarSaw.ar(freq: freq, width: wdt);
	sig = sig * amp;
}.play;
)

x.set(\wdt, 0.5);
x.set(\amp, 0.05);
x.set(\wdt, 0.1, \amp, 0.09);
x.set(\freq, [440, 441]); //no need for the hashtag
x.release(1);

(
x = {
	arg freq = 300, wdt = 0.9, amp = 0.1;
	var sig;
	sig = VarSaw.ar(freq: freq + [ -1, 1], width: wdt);
	sig = sig * amp;
	//0; // shortcut to mute a sound (disable playback
};
)

x.play;
x.release(1);


(
x = {
	|freq = 300, wdt = 0.9, amp = 0.1|
	var sig;
	sig = VarSaw.ar(freq: freq + [ 0, 3], width: wdt);
	sig = sig * amp;
}.play;
)

x.set(\freq, 200);

//shortcut to not declaring arguments, turn them to symbols
(
x = {
	var sig;
	sig = VarSaw.ar(freq: \freq.kr(330) + [ 0, 3], width: \wdt.kr(0.9));
	sig = sig * \amp.kr(-20.dbamp);
}.play;
)

x.set(\freq, 200);

// glisando using .lag and varlag
(
x = {
	|freq = 300, wdt = 0.9, amp = 0.1|
	var sig;
	sig = VarSaw.ar(freq: freq.varlag(1, -8) + [ 0, 3], width: wdt);
	sig = sig * amp.lag(3);
}.play;
)
x.set(\freq, 200);
x.set

// Envelopes (& doneActions)
(
x = {
	var sig;
	sig = VarSaw.ar(freq: [300, 301], width: 0.9);
	sig = sig * -20.dbamp;
}.play;
)

x.release(3);

(
e = Env.new(
	levels: [0,1,0],
	times: [0.5, 2],
	curve: [-4, -1]
);
)

e.plot();

(
x = {
	var sig, env;
	env = EnvGen.kr(
		Env.new(
			levels: [0,1,0],
			times: [0.5, 2],
			curve: [-4, -1]
		),
		//doneAction: Done.freeSelf
		doneAction: 2 // 0 do nothing, 1 pause the enclosing synth do not free 2 free self
	); //.poll use it like postln for signals
	sig = VarSaw.ar(freq: [300, 301], width: 0.9);
	sig = sig * env;
	sig = sig * -20.dbamp;
}.play;
)

Done.freeSelf; // evaluates to 2

// left at 38:10
// SynthDef & Synth




































