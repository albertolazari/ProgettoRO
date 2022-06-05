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

s.t. istruttoreBoulder{g in G, o in O}: sum{i in I} s[i,g,o] * M >= b[g,o];
s.t. istruttoreLead{g in G, o in O}: sum{i in I} t[i,g,o] * M >= l[g,o];
s.t. istruttoreAgonisti{g in G}: sum{i in I} u[i,g] >= a[g];

s.t. boulderOppureLead{i in I, g in G, o in O}: s[i,g,o] + t[i,g,o] <= 1;

s.t. maxCorsiBoulder{g in G, o in O}: b[g,o] / (sum{i in I} s[i,g,o]) <= maxCorsiIstruttore;
s.t. maxCorsiLead{g in G, o in O}: l[g,o] / (sum{i in I} t[i,g,o]) <= maxCorsiIstruttore;

s.t. maxOre{i in I}:
	(sum{g in G, o in O} s[i,g,o] + t[i,g,o])
	+ (sum {g, in G} 2 * u[i,g])
	+ o[i] * durataCorsoOutdoor <= maxOre[i];

s.t. soloCorsoAgonisti{o = orarioCorsoAgonisti, i in I, g in G}: s[i,g,o] + s[i,g,o+1] + t[i,g,o] + t[i,g,o+1] <= (1 - u[i,g] * M);

s.t. minAllenamentiAgonisti: sum{g in G} a[g] >= minAllenamentiAgonisti
