# cslc-csd 
A library of UDO's and intruments to support live coding in Csound.

## ABOUT ##
This csound CSD file provides User Defined Opcodes to assist
with Live Coding sessions using Csound.

### Dependencies ### 
Csound with UDP port 8099 open.

### USAGE ###
Run the command:  
`$csound cslc.csd`  
Code can be sent on UDP port 8099 (or whatever --port is set to in CsOptions).  
To use the instruments in Sounds.orc, save Sounds.orc in your $INCDIR path, (or same directory as cslc.csd)  
Then uncomment the commandline flag `--omacro:SOUNDLIB=Sounds.orc`  
Some instrument numbers are reserved and should be avoided: 1 - 10,299,300,301   
The 'patch' feature requires named instruments.  
All UDO's have i-time versions. This allows them to be used in csound global space (outside instrument defenitions).  

### FEATURES / UDO's ###
	* Patch and send audio between instruments on-the-fly. (See patch* UDO's)
	* Microtonal support (See Microtonal)
	* Effect instrument generation (See Effects)
	* Rhythm helpers
	* Event generators
	* An assortment of other utilities and helpers.

Private UDO names are prefixed with the form _cslc_<name> e.g. `_cslc_loopmaster`.
These UDO's are used within other UDO's. It is not expected that users would use these UDO's in performance (although nothing strictly prohibits this).  

Private variable names use the format rate_cslc_<name> e.g. `gk_cslc_tempo`  

Public UDO names haven't been pseudo namespaced, largely to assist with the convenience of live coding. However be wary of name clashes / overloading.

### PUBLIC UDO's ###

#### RHYTHM ####
A clock (gk_now) begins running when performance starts. The clock value updates at csound control rate, and is meaured in bpm. A 'beat' can be considered as a round number in the clock.  
* `now` - the current value of the clock 
* `temposet` - set the speed of the clock in bpm
* `tempoget` - get the speed of the clock in bpm
* `tempodur/tempodur_k` - return the duration in seconds for the clock time duration.
* `nextbeat` - returns the time interval in seconds for the clock to reach the beat n beats from now.
* `onbeat` - returns the time interval in seconds for the clock to reach the next beat n in a bar.
* `nextrh` - yield the duration to the next beat in an array on successive calls.
* `euclidean/euclidean_i` - Use a euclidean rhythm algorithm to return an array of rhythm values

#### MICROTONAL ####
Scales are stored in tables in a format suitable for the cpstun/i opcodes.
Two tables are always available: `gi_SuperScale`, and `gi_CurrentScale`. Many UDO's (such as the event generators will reference the scales set in these tables).
Typically, one would put a complete temperament in gi_Superscale (e.g. a chromatic scale). Then a subset of that temperament is placed in gi_CurrentScale (e.g. a major scale)  

Many of the included scale tables set degree '0' at 263 cps.  
* `Tbedn` - senerate a table of equidistant degrees per period
* `cpstun3` - return values from a scale table
* `cps2deg` - returns the nearest scale value to the value given in cps pitch.
* `sclbend` - returns the cps pitch when given a scale degree and a modifier (pitchbend) channel.
* `passing` - returns an interpolated array of from a subset of scale degrees.
* `scalemode` - sets gi_CurrentScale to a mode from gi_SuperScale.
* `scaleModulate` - shifts and rotates the interval pattern in gi_CurrentScale
* `scalemode31` - sets gi_CurrentScale with a selection of modes in 31edo 
* `scldegmatch` - returns the index in one scale table which matches the pitch from another scale table.

#### EVENT GENERATORS ####
Event generators produced score events.
* `orn` - generate score events from arrays of intervals and rhythms
* `chrdi` - generate concurrant score events
* `arpi` - generate score events from arrays of scale degrees and rhythms
* `loopevent` - generate repeating score event cycles
* `loopcode` - generate repeating cycles of arbitrary code.

#### PATCH UDO's for signal routing ####
Patching routes audio between named instruments. Patch UDO's guide the path of audio between instruments.
In this context 'Source' Intruments send audio to the patch system using the 'send' opcode.
'Effect' instruments retrieve and send audio back to the patch system. See 'EffectConstruct'.

Syntax:  
`patchsig Ssource, SDestination [,ilevel] `
`patchchain Spatharray[] [,ilevel]` 
`patchspread Ssource, SDestinationarray[] [,ilevel]` 
`send asig` 
`send asig1,asig2` 
`send asigs[]o`
	
	Ssource -- String name of the instrument or effect sending audio  
	SDestination -- String name of the effect receiving audio (See EffectConstruct)  
	SDestination[] (In patchspread) -- A string array of the names of effects receiving audio.  
	Patchspread sends audio from Ssource to each effect in parallel. Useful for splitting the signal path.  
	Spatharray[] (In patchchain) -- Spatharray is a string array of Instrument and/or Effect Names.  
	Patchchain seqentially applies patchsig to each element in the array in series. Audio is routed between each instrument/effect from the beginning of the array to the end. While the first element can be a either a source instrument or an Effect, subsequent elements must be effects (with inputs).  
	
Example:
```csound
instr myoscil
asig oscil p4,p5
send fillarray(asig) ; send audio to the patch array
endin

EffectConstruct "flange",{{
ain = ains[0]
aout flanger ain, oscili:a(0.005,0.25,-1,1) + 0.0055, 0.66
aouts[] fillarray aout
}},1,1,1

;Now route the audio
patchsig "myoscil", "outs"                               ; Send audio to the output.
patchchain fillarray("myoscil", "flange","outs"),0.6     ; re-route the audio to an effect, then from the effect to the output.
patchspread "myoscil", fillarray("rvb","compressor")     ; re-route audio to two effects in parallel. 
```
#### EFFECT Instruments ####

EffectConstruct generates 'Effect' instruments. These are 'always on' instruments, but can be re-evaluated to update the code 'on the fly'. Re-evaluating replaces the running instance.
The generated Effect instrument has an implicit 'send' which sends audio to the Patch system.  
Syntax: 
`EffectConstruct SName, Scode, input_count, ioutput_count, icrossfade`
Sname -- A name given to the instrument (must be unique). The Patchsend opcodes use this name to route audio.  
	Scode -- the body of csound code used to process audio.  
Input audio arrives in an audio array labelled ains[]. The length of this array depends on input_count. Output audio should be assigned to an audio array labelled aouts[]. The length of this array depends on ioutput_count.  
	input_count -- Number of audio inputs (sets the size of the ains[] array)  
	ioutput_count -- Number of audio outputs (sets the size of the aouts[] array)  
	icrossfade -- crossfade length in seconds for the transition to the new instance.  
	Example:
```csound
;create an instrument named 'flange' with one input and two outputs.
EffectConstruct "flange",{{
ain = ains[0]
adel1 = oscili(0.005,0.25,-1,1) + 0.0055
adel2 = oscili(0.004,0.23,-1,1) + 0.0045
aoutL flanger ain, adel1, 0.75
aoutR flanger ain, adel2, 0.75
aouts fillarray aoutL, aoutR
}},1,2,1
```
#### Other Utilities/miscellaneous ####
* `fillarray:a` - a-rate version of fillarray
* `catarray` - concatenate multiple 1d arrays into a single array.
* `encode2` - encode two audio signals into a single audio signal 
* `decode2` - decodes two audio signals from one encoded by encode2
* `encode4` - encode 4 integers into a single integer
* `decode4` - decode 4 integers from a single encoded integer
* `n` - short wrapper for nstrnum
* `rescale`, `rescalek` - rescales values
* `randint` - return a random integer in a range
* `ndxarray` - forgiving array indexing
* `mono` - signals when a concurrant instance is active
* `castarray`/`ca` - iarray to karray or vice versa 
* `truncatearray` - extend or trim an array
* `wchoice` - weighted choice selection
* `rotatearray` - permute an array
* `dedupe` - remove dulicates from an array
* `slicearray_k` - like slicearray with k-rate inputs
* `poparray` - returns item at index in an array, and the array with item removed.
* `rndpick` - return a random selection from an array without duplicates.
* `cosr` - returns a value in a cosine circle with resp[ect to the current time.
* `linslide` - control a channel value
* `counterChan` - increment a channel value
* `iterArr` - yield the next value in an array on successive calls.
* `seesaw` - oscillate between two values
* `walker` - Random walk
* `randselect_i` - Select a random value fromthe argument list
* `curve/curvek` - convex/concave curves

Optional: See also cslc-mode, the emacs minor mode for live coding.
