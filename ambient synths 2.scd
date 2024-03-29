s.boot;
//https://www.youtube.com/watch?v=ApegyaNoC2c       @ 10:01
(
SynthDef(\pad, {
	var snd;
	snd = Saw.ar(\freq.kr(440) * ({ LFNoise2.kr(8) } ! 16 * Line.kr(0,0.5,3)).midiratio * [1,2,1,2,1,2,1,2,2,1,2,1,2,1,2,1]);
	snd = DelayC.ar(snd, 0.01, { Rand(0, 0.01) } ! snd.size);
	snd = Splay.ar(snd);
	snd = LPF.ar(snd, XLine.kr(1000,100,8));
	snd = BPeakEQ.ar(snd, \freq.kr(440) * 8, 0.1, 8);
	snd = snd * Env.asr (1, 1, 8).ar(Done.freeSelf, \gate.kr(1));
	snd = snd * \amp.kr(-10.dbamp);
	snd = snd ! 2;
	Out.ar(\out.kr (0), snd);
}).add;

SynthDef(\fx, {
	var snd;
	snd = In.ar(\out.kr(0), 2);
	snd - snd + PitchShift(snd, 0.2, 0.5, 0,0.1);
	snd = snd + NHHall.ar(snd, 3, modDepth: 1);
	snd = BHiShelf.ar(snd, 3000, 1, -10 + (5 * LFNoise2.kr(16 ! 2)));
	snd = BPeakEQ.ar(snd, 240, 0.1, -8 * LFNoise2.kr(16 ! 2));
	snd = BPeakEQ.ar(snd, 460, 0.1, -8 * LFNoise2.kr(16 ! 2));
	snd = BPeakEQ.ar(snd, 820, 0.1, -8 * LFNoise2.kr(16 ! 2));
	snd = BLowShelf.ar(snd, 100, 1, 10);
	snd = Limiter.ar(snd);
	ReplaceOut.ar(\out.kr (0), snd);
}).add;
)

(
Routine {
	var frequencies;
	frequencies = (39 +  ([3, 7, 12, 14, 15, 22, 24, 26] +.x [0, 12])).midicps;
	Synth.tail(nil, \fx);
	loop{
		frequencies.scramble.do { |frequency|
			Routine {
				var synth;
				synth = Synth(\pad, [freq: frequency]);
				rrand(1.0, 4.0).wait;
				synth.set(\gate, 0);
			} .play;
			rrand(0.3, 1.0).wait;
		};
		rrand(3.0, 7.0).wait;
	};
} .play;
) 