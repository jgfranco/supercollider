(
SynthDef(\pad, {
	var snd;
	snd = Saw.ar(\freq.kr(440));
	snd = snd * Env.asr (3, 1, 3). ar (Done. freeSelf);
	snd = snd \amp.kr(-20.dbamp);
	snd = snd ! 2
	Out.ar(\out.kr (0), snd);
}).add;
)

Synth(\pad)