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
MIDIFunc.trace(false); // to track midi input

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
	Synth(\saw, [freq: num.midicps, amp: val/127, rel:3]);

});
)


~notes = Array.newClear(128);
(
MIDIdef.noteOn(\note, {
	arg val, num; // val is velocity, num is midi value
	[val, num].postln;
	~notes.at(num)=Synth(\saw, [
		freq: num.midicps,
		amp: val.linlin(0,127, -40,-6).dbamp,
	]);
});
)


(
s.newBusAllocators;
~cfbus = Bus.control(s, 1);
)

(MIDIdef.cc(\cf, {
	arg val,num;
	~cfbus.value_(val/127);
}, ccNum: 21) // 21 is the ccNum that my launchkey mini gave me when I "listened"
//with MIDIfunc.trace(true);
)

s.scope;
(
SynthDef(\saw, {
	var sig, env, cf;
	cf = In.kr(\in.kr(~cfbus),1);
	cf = cf.linexp(0,1, 30,15000);
	env = Env([0,1,0], [0.001, \rel.ir(1)], [0, -10]).kr(2);
	sig = Saw.ar(\freq.ir(50)) ! 2;
	sig = LPF.ar(sig, cf);
	sig = sig * \amp.ir(0.2) * env;
	Out.ar(\out.ir(0), sig);
}).add;
)

MIDIdef(\note).disable;
MIDIdef(\note).enable;

MIDIFunc.trace(false);


//this next poriton deals with the samples
MIDIdef.freeAll;

Synth(\samp, [buf:b.sna, amp:0.5]);

b.size;

s.reboot;



MIDIIn.connectAll;
(
MIDIdef.noteOn(\samp, {

	arg val, num;
	var buffer;
	[val,num].postln;
	buffer = switch(num)
	{36} {b.kick}
	{38} {b.snare2}
	{40} {b.hh}
	{41} {b.hh2}
	{43} {b.stick}
	{45} {b.sticks}
	{true} {nil};
	if(buffer.notNil){
		Synth(\samp, [buf: buffer]);
	}
});
)


//left at 36:45



 