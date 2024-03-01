//patterns, events, streams


// value patterns
(
~pat = {
	var num = 50, inc = 7, count = 0;
	while({ count < 6}, {
		num.yield;
		num = num + inc;
		count = count + 1
	});
};
~seq = r(~pat);
)

~seq.next;


// this is a simplified version using the Pseries pattern
(
~pat = Pseries(50, 7, 6);
~seq = ~pat.asStream;
)

~seq.next;

//mathematical operations with patterns
(
~pat = Pseq([1 ,2 ,3], inf);
~pat = ~pat + Pseq([10,20], inf);
~seq = ~pat.asStream;
)

~seq.next;


// nested patterns

(
~pat = Pseq([
	5,
	Pwhite(lo:1, hi:9, length:1),
	12,
	Pseq([2, 3], 2)
], 3);

~seq = ~pat.asStream;
)

~seq.next;


// cool panner
(
~pat = Pseq([-1, 1], inf);
//~pat = ~pat * rrand(0, 1.0);// this wont work, it always return the same random number
~pat = ~pat * Pwhite(0, 1.0, inf); // we can use the white noise pattern instead
~seq = ~pat.asStream;
)

~seq.next;

// left at 22:09

