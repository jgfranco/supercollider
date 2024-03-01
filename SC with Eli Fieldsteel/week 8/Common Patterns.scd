// Common Patterns
// see help files for additional information and examples


//Pseq - sequentially output values from a list

(
p = Pseq([4, 9, 3], inf);
q = p.asStream;
)
q.next;
q.nextN(20);

//Prand - randomly ouptut values from a list

(
p = Prand([4, 9, 3], inf);
q = p.asStream;
)

q.nextN(20);

// Pxrand - randomly output values from a list but never repeat the same item twice in a row

(
p = Pxrand([4, 9, 3], inf);
q = p.asStream;
)

q.nextN(20);

// Pwrand - randomly output values from a list based on an array of weights, which must sum to 1, 'nomalizeSum' can be used to produce a suitable weights array.

(
p = Pwrand([4, 9, 3], [1, 10, 30].normalizeSum, inf);
q = p.asStream;
)
[1, 10, 30].normalizeSum.postln;
q.nextN(20);

// Pshuf - output items in a list in a random order

(
p = Pshuf([4,9,3], inf);
q = p.asStream;
)

q.next;

//Pseries = arithmetic series


(
p = Pseries(1, 2, inf);
q = p.asStream;
)

q.nextN(20);

//Pgeom - multiplicative series

(
p = Pgeom(1, 2, inf);
q = p.asStream;
)
q.nextN(20);


// see help files for more