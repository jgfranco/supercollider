s.boot;
s.quit;
//https://www.youtube.com/watch?v=ApegyaNoC2c       @ 5:40
(
SynthDef(\pad, {
	var snd;
	snd = Saw.ar(\freq.kr(440) * ({ LFNoise2.kr(8) } ! 16 * 0.1).midiratio);
	snd = DelayC.ar(snd, 0.1, { Rand(0, 0.1) } ! snd.size);
	snd = Splay.ar(snd);
	snd = snd * Env.asr (3, 1, 3). ar (Done. freeSelf, \gate.kr(1);
	snd = snd * \amp.kr(-20.dbamp));
	snd = snd ! 2;
	Out.ar(\out.kr (0), snd);
}).add;

SynthDef(\fx, {
	var snd;
	snd = In.ar(\out.kr(0), 2);
	snd = snd + NHHall.ar(snd, 3, modDepth: 1);
	snd = BHiShelf.ar(snd, 3000, 1, -10);
	snd = BLowShelf.ar(snd, 100, 1, 10);
	snd = Limiter.ar(snd);
	Out.ar(\out.kr (0), snd);
}).add;

)

(
Routine {
	var frequencies;
	frequencies = 50 * (1..8).nthPrime;
	Synth.tail(nil, \fx);
	loop{
		Routine {
		var synth;
		synth = Synth(\pad, [freq: frequencies.choose]);
		rrand(8.0, 16.0).wait;
		synth.set(\gate, 0);
		} .play;
		rrand(0.3, 1.0).wait;
	};
} .play
)

