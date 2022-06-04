set G;
set O;
set I;

param maxCorsiIstruttore;
param costoIstruttore;
param maxOre{I};
param guadagnoCorsoBoulder;
param guadagnoCorsoLead;
param minAllenamentiAgonisti;
param orarioCorsoAgonisti;
param guadagnoCorsoAgonisti;
param durataCorsoOutdoor;
param guadagnoCorsoOutdoor;
param M := Infinity;

var b{G, O} >= 0 integer;
var l{G, O} >= 0 integer;
var s{I, G, O} binary;
var t{I, G, O} binary;
var a{G} binary;
var u{I, G} binary;
var k binary;
var o{I} binary;

maximize FO:
	(sum{g in G, o in O} b[g,o] * guadagnoCorsoBoulder)
	+ (sum{g in G, o in O} l[g,o] * guadagnoCorsoLead)
	+ (sum{g in G} a[g] * guadagnoCorsoAgonisti)
	+ k * guadagnoCorsoOutdoor)
	- costoIstruttore * (
		(sum{i in I, g in G, o in O} (s[i,g,o] + t[i,g,o]))
		+ (sum{i in I, g in G} 2 * u[i,g])
		+ (sum{i in I} o[i] * durataCorsoOutdoor)
	);

s.t.
