set G;
set O;
set I;

param maxCorsiIstruttore;
param costoIstruttore;
param maxOre{I};
param boulder{G, O};
param lead{G, O};
param guadagnoCorsoBoulder;
param guadagnoCorsoLead;
param minAllenamentiAgonisti;
param orarioCorsoAgonisti;
param guadagnoCorsoAgonisti;
param durataCorsoOutdoor;
param guadagnoCorsoOutdoor;
param M := 9999999;

var b{I, G, O} binary;
var l{I, G, O} binary;
var t{G} binary;
var a{I, G} binary;
var k binary;
var d{I} binary;

maximize FO:
    (sum{g in G, o in O} boulder[g,o] * guadagnoCorsoBoulder)
    + (sum{g in G, o in O} lead[g,o] * guadagnoCorsoLead)
    + (sum{g in G} t[g] * guadagnoCorsoAgonisti)
    + k * guadagnoCorsoOutdoor
    - costoIstruttore * (
        (sum{i in I, g in G, o in O} (b[i,g,o] + l[i,g,o]))
        + (sum{i in I, g in G} 2 * a[i,g])
        + (sum{i in I} d[i] * durataCorsoOutdoor)
    );

s.t. istruttoreBoulder{g in G, o in O}: sum{i in I} b[i,g,o] * M >= boulder[g,o];
s.t. istruttoreLead{g in G, o in O}: sum{i in I} l[i,g,o] * M >= lead[g,o];
s.t. boulderOppureLead{i in I, g in G, o in O}: (b[i,g,o] + l[i,g,o]) <= 1;
s.t. maxCorsiBoulder{g in G, o in O}: (sum{i in I} b[i,g,o]) >= boulder[g,o] / maxCorsiIstruttore;
s.t. maxCorsiLead{g in G, o in O}: (sum{i in I} l[i,g,o]) >= lead[g,o] / maxCorsiIstruttore;
s.t. soloCorsoAgonisti{i in I, g in G}:
    b[i,g,orarioCorsoAgonisti] + b[i,g,orarioCorsoAgonisti+1]
    + l[i,g,orarioCorsoAgonisti] + l[i,g,orarioCorsoAgonisti+1]
    <= (1 - a[i,g]) * M;
s.t. vincoloMaxOre{i in I}:
    (sum{g in G, o in O} (b[i,g,o] + l[i,g,o]))
    + (sum {g in G} 2 * a[i,g])
    + d[i] * durataCorsoOutdoor <= maxOre[i];
s.t. vincoloMinAllenamentiAgonisti: sum{g in G} t[g] >= minAllenamentiAgonisti;
s.t. istruttoreAgonisti{g in G}: sum{i in I} a[i,g] >= t[g];
