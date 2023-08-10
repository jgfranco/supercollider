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

SynthDef(\ping, {
	var snd;
	//snd = SinOsc.ar(\freq.kr(400) * (LFNoise2.kr(0.3) * 0.1).midiratio);
	snd = SinOsc.ar(\freq.kr(400));
	snd = snd * Env.perc(0.1, 0.5).ar(Done.freeSelf);
	snd = snd * \amp.kr(-10.dbamp);
	snd = Pan2.ar(snd, \pan.kr(0));
	Out.ar(\out.kr (0), snd);
}).add;

SynthDef(\fm, {
	var snd, freq;
	freq = \freq.kr(440) * (LFNoise2.kr(8) * 0.1).midiratio;
	snd = SinOsc.ar(freq + (SinOsc.ar(freq * (800 / freq).round) * 1000));
	snd = snd + SinOsc.ar(freq + (SinOsc.ar(freq * (2000/freq).round) * 1000));
	snd = LPF.ar(snd, 2000) * -10.dbamp;
	snd = snd * Env.perc(0.5, 8).ar(Done.freeSelf);
	snd = snd * \amp.kr(-10.dbamp);
	snd = Pan2.ar(snd, \pan.kr(0));
	Out.ar(\out.kr (0), snd);
}).add;

SynthDef(\fx, {
	var snd;
	snd = In.ar(\out.kr(0), 2);
	//snd - snd + PitchShift(snd, 0.2, 0.5, 0,0.1);
	snd = snd + NHHall.ar(snd, 3, modDepth: 1);
	snd = BHiShelf.ar(snd, 3000, 1, -10 + (5 * LFNoise2.kr(16 ! 2)));
	snd = BPeakEQ.ar(snd, 240, 0.1, -8 * LFNoise2.kr(16 ! 2));
	snd = BPeakEQ.ar(snd, 460, 0.1, -8 * LFNoise2.kr(16 ! 2));
	snd = BPeakEQ.ar(snd, 820, 0.1, -8 * LFNoise2.kr(16 ! 2));
	snd = BLowShelf.ar(snd, 100, 1, 10);
	snd = Limiter.ar(snd);
	snd = snd * -5.dbamp;
	ReplaceOut.ar(\out.kr (0), snd);
}).add;

)

(
Routine {
	var frequencies, chords;
	chords = [
		[0, 14, 15, 29, 31],
		[3, 15, 24, 27],
		[7, 14,  19, 26, 31],
		[12, 14,  19, 22],
		[9, 12, 14, 17],
		[3, 7, 12, 14, 15, 22, 24, 26]
	];
	Synth.tail(nil, \fx);

	Routine {
		loop {
			rrand(2.0, 16.0).wait;
			24.do {      // multiply freqencies.choose by a factor (e.g 4, to change octaves for the ping
				if(frequencies.notNil){
					Synth(\ping, [freq: frequencies.choose * 2, amp: -20.dbamp, pan: rrand(-1.0,1.0)]);
				};
				exprand(0.1, 0.5).wait;
			};

		};
	} .play;

	Routine {
		loop {
			rrand(5.0, 8.0).wait;
			12.do {
				if(frequencies.notNil){
					Synth(\fm, [freq: frequencies.choose, amp: -20.dbamp, pan:rrand(-1.0, 1.0)]);
				};
				exprand(0.1, 0.5).wait;
			};

		};
	} .play;

	loop{
		chords.do{ |chord|
			frequencies = (39 + (chord +.x [0, 12])).midicps;
			frequencies.scramble.do { |frequency|
				Routine {
					var synth;
					synth = Synth(\pad, [freq: frequency]);
					rrand(1.0, 4.0).wait;
					synth.set(\gate, 0);
				} .play;
				rrand(0.3, 1.0).wait;
			};
			rrand(5.0, 10.0).wait;
		};
	};
} .play;
) 