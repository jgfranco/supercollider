s.boot;
s.reboot;

x = {SinOsc.ar([300,301], mul:0.5)}.play;

x.free;
s.freeAll;

//JITLib

NodeProxy

x+2; // produces an error

{x} + 2;

y = {x} + 2;

x = 3;

y.value;


n = NodeProxy.new;

n.isPlaying;

n.play;
n.isPlaying;

s.plotTree;

n.clear;
n.source;
n.source = {PinkNoise.ar(0.1 ! 2)};

n.source = {SinOsc.ar([440, 441], mul:0.8) * LFPulse.kr([2,3])};

n.clear(6);

// fadeTime

n.play;
n.source_({LPF.ar(Saw.ar([60, 60.2], mul: 0.05), 1000)});
n.fadeTime;
n.fadeTime_(3);

n.source_({LPF.ar(Saw.ar([60, 60.2] * -2.midi
	ratio, mul: 0.1), 1500)});

n.source_({ }); // set it to an empty function to stop the playing

n.stop;
n.play;
n.monitor.fadeTime_(1);
n.fadeTime_(5);



n.source_({LPF.ar(Saw.ar([60,60.25] * Rand(-5.0, 5.0).midiratio, mul: 0.3), 1000)});

n.release;
n.send;

n.pause;
n.resume;

m = NodeProxy.new;
m.play;
m.fadeTime_(5);
m.source_({Dust.ar(13!2, mul: 0.3)});

m.pause;
n.pause;
m.resume;
n.resume;

m.source_({ Impulse.ar([9, 9.1], mul: 0.5) * SinOsc.kr(0.2, 3pi/2).exprange(0.1, 1)});

// left at 22.28


