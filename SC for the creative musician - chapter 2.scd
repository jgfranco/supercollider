s.boot;
Server.local.boot;

s.quit;
Server.local.quit;

s.sampleRate;
s.options.blockSize;


// calibrating your setup
// before running the following command:
{PinkNoise.ar(mul: 1) !2}.play;
// set your volume to the minimum  (now play the sound)
//then bring your system volume up
// until the sound is slighlty annoying.
// now you have  healthy level


// [cmd]+[Enter] evaluates the code
// [cmd]+[period] stops all the sound
{SinOsc.ar(300, 0, 0.1, 0) !2}.play;

// verbose style
{SinOsc.ar(freq: 440,phase: 0,mul: 0.1,add: 0) !2}.play;

// changing a sound while playing
(
x = { |freq = 300|
	SinOsc.ar(freq, mul: 0.1) !2;
}.play;
)

x.set(\freq, 440);