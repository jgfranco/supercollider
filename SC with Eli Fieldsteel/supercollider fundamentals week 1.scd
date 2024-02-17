neg(4.squared);

squared(4).neg;

4.pow(3);

/*
block
of
comments
*/

// interpreter variable (single letter variables, are persistent)
# this is called an enclosure which means
(
x = 4;
x = x.squared;
x = x.neg;
x;
)

(
var val;
val = 4;
val = val.squared;
val = val.neg;
val;
)


// enviroment variable (tilde name)
(
var ~val;
~val = 4;
~val = ~val.squared;
~val = ~val.neg;
~val;
)

k = 3 +4 .       squared; // supercollider doesn't care for whitespace

3 + 4 * 7 // its evaluated from left to right
3 + (4 * 7) // use parenthesis if different order is needed

4+ 2.pow(3); //methods have precedence over binary operators
(4 +2).pow(3);

1 + (4 +2).pow(3);

Integer.browse;



