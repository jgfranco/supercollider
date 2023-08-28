// https://www.youtube.com/watch?v=gsAxCuUcy0o     @48:41
s.boot;
s.quit;
(
SynthDef(\kick, {
	var snd;
	snd = SinOsc.ar((57) * (1+ (4 * Env.perc(0, 0.13, curve: -8).ar)) * XLine.ar(1,0.5, 1));
	snd = snd + (SinOsc.ar(XLine.ar(4000,50.01)) * Env.perc(0.0001, 0.01).ar * -5.dbamp);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 10120,0.5) * (Env.perc(0.001,0.03).ar * -8.dbamp));
	snd = snd * (1 + (2 * Env.perc(0.001, 0.2).ar));
	snd = (snd * 0.dbamp).tanh;
	snd = snd * Env.perc(0.001,1.3, curve: -8).ar(Done.freeSelf);
	snd = snd * -5.dbamp;
	snd = Pan2.ar(snd, \pan.kr(0));
	Out.ar(\out.kr(0), snd);
}).add;
// SynthDef(\kick, {
// 	var snd;
// 	snd = SinOsc.ar(55 * (1 + (3* Env.perc(0.001, 0.3, curve: -8).ar)));
// 	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 8600,0.3) * -15.dbamp * Env.perc(0.05,0.3).ar);
// 	snd = snd * \velocity.kr(1);
// 	snd = snd + ((snd * 10.dbamp).tanh * -5.dbamp);
// 	snd = snd + ((snd * 3.dbamp).fold2 * -10.dbamp);
// 	snd = snd + (snd * 10).tanh;
// 	snd = snd + snd.fold2;
// 	snd = (snd * (1 + Env.perc(0.001, 0.1).ar)).clip2;
//
// 	snd = snd * \amp.kr(-10.dbamp);
// 	snd = snd * Env.perc(0.001, 0.2).ar(Done.freeSelf);
// 	snd = Pan2.ar(snd, \pan.kr(0));
// 	Out.ar(\out.kr(0), snd);
// }).add;

SynthDef(\bass, {
	var snd, velocity, freq;
	velocity = \velocity.kr(0.5);
	freq = \freq.kr(70) * (1 + (0.5 * Env.perc(0.01, \pitchDecay.kr(0.5)).ar * velocity));
	snd = SinOsc.ar(freq);
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar + [0, 1]), 4600, 0.3) * -30.dbamp);
	snd = snd + ((snd * 10).tanh * -10.dbamp);
	snd = (snd * 1.dbamp).fold2;
	snd = snd * Env.perc(0, \timbreDecay.kr(3.0)).ar * velocity;
	2.do {
		snd = snd + (PitchShift.ar(snd, 0.1, 2) * -10.dbamp);
		snd = (snd * 10.dbamp).tanh;
	};
	snd = LPF.ar(snd, 250) + HPF.ar(snd, 3000);
	snd = HPF.ar(snd, freq) + SinOsc.ar(freq);
	snd = snd * Env.asr(0.3, 1, 0.03).ar(Done.freeSelf, \gate.kr(1));
	snd = snd * \amp.kr(-15.dbamp);
	snd = Pan2.ar(snd, \pan.kr(0));
	Out.ar(\out.kr(0), snd);
}).add;
// snare
SynthDef(\snare, {
	var snd;
	snd = SinOsc.ar(210 * (1 + (1 *   Env.perc(0.001, 0.1).ar)) * [1, 1.75, 2.6, 3.4]);
	snd = snd * Env.perc(0.001, [1, 0.3, 0.2, 0.1]).ar;
	snd = snd.sum;
	snd = snd + (BPF.ar(Hasher.ar(Sweep.ar), 2100,0.3) * -5.dbamp * Env.perc(0.05,0.3).ar);
	snd = snd + LPF.ar((snd * 20.dbamp).tanh, 8000);
	snd = snd + (CombC.ar(snd, 0.1, 1/120, 0.3) * -10.dbamp);
	snd = snd + PitchShift.ar(snd, 0.03, 2.6);
	snd = snd + PitchShift.ar(snd, 0.05, 3.6);
	snd = snd * (1+ (SinOsc.ar(1400) * -5.dbamp));
	snd = snd * (1+ (SinOsc.ar(5000) * -10.dbamp));
	snd = snd * Env.perc(0.001, 0.3, curve:-2).ar(Done.freeSelf);
	snd = snd * \amp.kr(-18.dbamp);
	snd = Pan2.ar(snd, \pan.kr(0));
	Out.ar(\out.kr(0), snd);
}).add;



SynthDef(\saw, {
	var snd, count, freq;
	count = 10;
	freq = \freq.kr(440) * Line.kr(\bend.kr(0), 0,0.2).midiratio;
	snd = LFSaw.ar(freq * (({LFNoise2.kr(0.5)} ! count* 0.5) * 0.5).midiratio, { Rand(0,4) ! count});
	snd = MoogFF.ar(snd,8000,0);

	snd = Splay.ar(snd) * -10.dbamp;
	snd = snd * Env.asr(0.05, 1, 0.05).ar(Done.freeSelf, \gate.kr(1));
	snd = snd + NHHall.ar(snd,inf,0, 200, 0.5, 8000, 1, 0.5, 0.5, 0.4, 0.4);
	snd = snd * \amp.kr(-25.dbamp);
	snd = Pan2.ar(snd, \pan.kr(0));
	Out.ar(\out.kr(0), snd)
}).add;

SynthDef(\snare2, {
	var snd;
	snd = WhiteNoise.ar();
	snd = snd * Env.perc(0.001, 0.18, curve: -8).ar;
	snd = snd + LPF.ar((snd * 20.dbamp).tanh, 3000);
	snd = snd + HPF.ar(snd, 500);
	snd = snd * \amp.kr(-5 .dbamp);
	snd = Pan2.ar(snd, \pan.kr(0));
	Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\hh, {
	var snd, velocity;
	velocity = \velocity.kr(0.5);
	snd = WhiteNoise.ar(1 * velocity);
	snd = snd * Env.perc(0.001, 0.18, curve: -8).ar;
	//snd = snd + LPF.ar(snd, 8000);
	snd = snd + HPF.ar(snd, 5000);
	snd = snd * \amp.kr(-5.dbamp);
	snd = Pan2.ar(snd, \pan.kr(0));
	Out.ar(\out.kr(0), snd);
}).add;
SynthDef(\hh2, {
	var snd, velocity;
	velocity = \velocity.kr(0.5);
	snd = WhiteNoise.ar(1 * velocity);
	snd = snd * Env.perc(0.001, 0.1, curve: -8).ar;
	snd = LPF.ar(snd, 8000) + HPF.ar(snd, 12000);
	snd = snd * \amp.kr(-5.dbamp);
	snd = Pan2.ar(snd, \pan.kr(0));
	Out.ar(\out.kr(0), snd);
}).add;




/*
SynthDef(\acid, {
	var snd, freq;
	freq = \freq.kr(440);
	snd = Saw.ar(freq);
	snd = MoogFF.ar(snd, XLine.kr(ExpRand(1000,8000), 1000, 0.1), 3);
	snd = (snd * 3).tanh;
	snd = MoogFF.ar(snd, XLine.kr(ExpRand(1000,8000), 0.1), 3);
	snd = (snd * 1.5).tanh;
	snd = snd * Env.asr(0.001, 1, 0.001).ar(Done.freeSelf, \gate.kr(1));
	snd = snd * \amp.kr(-1.dbamp);
	snd = Pan2.ar(snd, \pan.kr(0));
	Out.ar(\out.kr(0), snd);
}).add;
*/

SynthDef(\fm, {
	var snd, freq;
	snd = SinOsc.ar(ExpRand(1000,8000)) * Env.perc(0.001, ExpRand(0.001, 0.1)).ar * Rand(1000,8000);
	snd = SinOsc.ar(ExpRand(1000,8000) + snd) * Env.perc(0.001, ExpRand(0.001, 0.1)).ar * Rand(1000,8000);
	snd = SinOsc.ar(ExpRand(1000,8000) + snd);
	snd = (snd * 10).fold2;
	snd = MoogFF.ar(snd, 8000,0);
	snd = snd * Env.adsr(0.001, 0.1, 0.0, 0.001).ar(Done.freeSelf, \gate.kr(1));
	snd = snd * \amp.kr(-10.dbamp);
	snd = Pan2.ar(snd, \pan.kr(0));
	Out.ar(\out.kr(0), snd);
}).add;


)



(
var s, bpm, beat, root;
s = Server.default;
bpm = 135;
beat = 60 / bpm;
root = 34;
Routine({
	Routine({
	var synth;
		loop{
			var time;
			time = 0;
			"
             x......xxxx..... .......x....xxxx
             .x.xx.......xxxx xx..............
             .....xxx...x.... ..xxx.......xxxx
             x.x.........xxxx .....xx.xxxxx...
             ".do { |character|
				switch(character)
				{ $x } {
					s.bind {
						if(synth.notNil){
							synth.set(\gate, 0);
						};
						synth = Synth(\fm, [pan: 0.3 * [-1,1][time %2]]);
				 	};
					(beat/4).wait;
					time = time +1;
				}
				{ $- } {

					(beat / 4).wait;
					time = time +1;
				}
				{ $. } {
					s.bind {
						if(synth.notNil){
							synth.set(\gate, 0);
						};
						synth = nil;
					};
					(beat/4).wait;
					time = time +1;
				};
			};
		};
	}).play;
	Routine({
	var bass;
		loop{
			var time;
			time = 0;
			"X-xx--X-........ ..XxX-xX......xx
             X-------........ ..X-xx...x......
             X-xx--X-........ ..Xx..xX.....xxx
             X------X........ ..X-xx---x...xx.".do { |character|
				switch(character)
				{ $X } {
					s.bind {
						var velocity;
						velocity = [1.0, 0.1, 0.2, 0.1][time % 4];
						if(bass.notNil){
							bass.set(\gate, 0);
						};
						Synth(\kick, [\velocity: velocity]);
						bass = Synth(\bass, [\velocity: velocity, freq: root.midicps]);
				 	};
					(beat/4).wait;
					time = time +1;
				}
				{ $x } {
					s.bind {
						var velocity;
						velocity = [0.5, 0.05, 0.1, 0.05][time % 4];
						if(bass.notNil){
							bass.set(\gate, 0);
						};
						Synth(\kick, [\velocity: velocity]);
						 bass = Synth(\bass);
					};
					(beat / 4).wait;
					time = time +1;
				}
				{ $- } {

					(beat / 4).wait;
					time = time +1;
				}
				{ $. } {
					s.bind {
						if(bass.notNil){
							bass.set(\gate, 0);
						};
						bass = nil;
					};
					(beat/4).wait;
					time = time +1;
				};
			};
		};
	}).play;

	Routine({

		loop{
			var time, velocity;
			time = 0;
			"x-..-..-.-.x--..--..x---...-.".do { |character|
				velocity = [0.4, 0.1, 0.2, 0.1][time % 4];
				//velocity.postln;
				switch(character)
				{ $x } {
					s.bind {
						Synth(\hh, [\velocity: velocity]);
					};
					(beat / 4).wait;
					time = time +1
				}
				{ $- } {
					(beat / 4).wait;
					time = time +1
				}
				{ $. } {
					s.bind {
						Synth(\hh2);
					};
					(beat/4).wait;
					time = time +1
				};
			};
		};
	}).play;

	Routine({
		loop {
			(beat * 2).wait;
			s.bind{
				Synth (\snare);
			};
			(beat * 2).wait;
		};
	}).play;
	Routine({
		var synth;
		loop {
			[3, 4].do{ |octave|
				var first;
				first = true;
				2.do{
					(root + (12* octave) + [1,3,0, -5, 1,-2,1,0]).do{ |note|
						s.bind{
							synth = Synth (\saw, [
								freq: note.midicps,
								bend: if(first, 6 * if(octave==3, 1,-1),0)

							]);
						};
						first = false;
						(beat / 2).wait;
						s.bind{
							synth.set(\gate, 0);
						};
						(beat / 2).wait;
					};
				};
			};
		};
	}).play;
}).play;

)

