s. boot;

(
SynthDef(\samp, {
	var sig = sig, buf = \buf.ir(0);
	sig = PlayBuf.ar(2, buf, BufRateScale.ir(buf), doneAction: 2);
	sig = sig * \amp.ir(0.5);
	Out.ar(\out.ir(0), sig);
}).add;
SynthDef(\saw, {
	var sig, env;
	env = Env([0,1,0], [0.001, \rel.ir(1)], [0, -10]).kr(2);
	sig = Saw.ar(\freq.ir(50)) ! 2;
	sig = LPF.ar(sig, 1500);
	sig = sig * \amp.ir(0.2) * env;
	Out.ar(\out.ir(0), sig);
}).add;
)


(
b = ();
PathName("samples/".resolveRelative).entries.collect({
	|path|
	path.fileNameWithoutExtension.postln;
	b[path.fileNameWithoutDoubleExtension.asSymbol] = Buffer.read(s, path.fullPath);
	path.fullPath.postln;
})
)


b.keys;
b.stick.play;

MIDIIn.connectAll; // to connect devices
MIDIFunc.trace(true); // to track midi input

(
MIDIdef.noteOn(\note, {
	"hello!".postln;
});
)

(
MIDIdef.noteOn(\note, {
	//arg val, num, chan, src;
	//Synth(\saw);
	//[val, num, chan, src].postln;
	arg val, num;
	[val, num].postln;
	Synth(\saw, [freq: num.midicps, amp: val/127]);

});
)

~notes = Array.newClear(128);
(m
MIDIdef.noteOn(\note, {
	arg val, num; // val is velocity, num is midi value
	//[val, num].postln;
	~notes.at(num) = Synth(\saw, [
		freq: num.midicps,
		amp: val.linlin(0,127, -40,-6).dbamp
	]);
});
)

//left at 18:11 