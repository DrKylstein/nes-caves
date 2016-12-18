song_party subroutine
    .byte 6
    .word testLeadSequence
    .word 0;testChordSequence
    .word testBassSequence
    .word testDrumSequence

testLeadSequence subroutine
    .word .pat0
    
    .word .pat0
    .word .pat0
    .word .pat0
    
    
    .word .pat1
    .word .pat2
    .word .pat3

    .word .pat1
    .word .pat2
    .word .pat3
    
    .word .pat0
    
    
    .word .pat0
    .word .pat0
    .word .pat0
    
    .word .pat0
    .word .pat0
    .word .pat0
    
    .word .pat0

    
    .word .pat4
    .word .pat5
    .word .pat6
    
    .word .pat4
    .word .pat5
    .word .pat6
    
    .word .pat0
    

    .word .pat0
    .word .pat0
    .word .pat0
    
    .word .pat0
    .word .pat0
    .word .pat0
    
    .word .pat0

    
    .word 4<<1
.pat0:
    .byte REST
    .byte REST
    .byte REST
    .byte REST
    .byte REST
    .byte REST
    .byte REST
    .byte REST
    .byte REST
    .byte REST
    .byte REST
    .byte REST
    .byte REST
    .byte REST
    .byte REST
    .byte REST
    .byte END_PATTERN
.pat1:
    .byte VOICE_GUITAR,NOTE_C3
    .byte REST
    .byte REST
    .byte NOTE_A3
    .byte REST
    .byte NOTE_E3
    .byte REST
    .byte REST
    
    .byte NOTE_C3
    .byte REST
    .byte NOTE_E3
    .byte REST
    .byte NOTE_A3
    .byte REST
    .byte REST
    .byte REST
    .byte END_PATTERN
.pat2:
    .byte NOTE_A3
    .byte REST
    .byte REST
    .byte REST
    .byte NOTE_A3
    .byte REST
    .byte REST
    .byte REST
    
    .byte NOTE_C3
    .byte REST
    .byte REST
    .byte REST
    .byte NOTE_C3
    .byte REST
    .byte REST
    .byte REST
    .byte END_PATTERN
.pat3:    
    .byte VOICE_GUITAR,NOTE_C3
    .byte REST
    .byte REST
    .byte NOTE_A3
    .byte REST
    .byte NOTE_E3
    .byte REST
    .byte REST
    
    .byte NOTE_C3
    .byte REST
    .byte NOTE_E3
    .byte REST
    .byte NOTE_A3
    .byte REST
    .byte REST
    .byte REST
    .byte END_PATTERN
.pat4:
    .byte VOICE_GUITAR,NOTE_C3
    .byte REST
    .byte NOTE_A3
    .byte REST
    .byte REST
    .byte NOTE_E3
    .byte REST
    .byte REST
    
    .byte NOTE_C3
    .byte REST
    .byte REST
    .byte NOTE_E3
    .byte REST
    .byte NOTE_A3
    .byte REST
    .byte REST
    .byte END_PATTERN
.pat5:
    .byte NOTE_E3
    .byte NOTE_F3
    .byte REST
    .byte REST
    .byte NOTE_E3
    .byte NOTE_F3
    .byte REST
    .byte REST
    
    .byte NOTE_A3
    .byte NOTE_D3
    .byte REST
    .byte NOTE_A3
    .byte NOTE_D3
    .byte REST
    .byte REST
    .byte REST
    .byte END_PATTERN
.pat6:
    .byte VOICE_GUITAR,NOTE_C3
    .byte REST
    .byte NOTE_A3
    .byte REST
    .byte REST
    .byte NOTE_E3
    .byte REST
    .byte REST
    
    .byte NOTE_C3
    .byte REST
    .byte REST
    .byte NOTE_E3
    .byte REST
    .byte NOTE_A3
    .byte REST
    .byte REST
    .byte END_PATTERN

testChordSequence subroutine
    .word .pat0
    
    .word .pat0
    .word .pat1
    .word .pat2
    
    
    .word .pat1
    .word .pat2
    .word .pat3
    
    .word .pat1
    .word .pat2
    .word .pat3
    
    .word .pat0
    
    .word 4<<1
.pat0:
    .byte REST
    .byte REST
    .byte REST
    .byte REST
    .byte REST
    .byte REST
    .byte REST
    .byte REST
    .byte REST
    .byte REST
    .byte REST
    .byte REST
    .byte REST
    .byte REST
    .byte REST
    .byte REST
    .byte END_PATTERN
.pat1:
    .byte VOICE_MAJOR_ARP ,NOTE_C3
    .byte REST
    .byte REST
    .byte REST
    .byte NOTE_C3
    .byte REST
    .byte REST
    .byte REST
    .byte NOTE_C3
    .byte REST
    .byte REST
    .byte REST
    .byte NOTE_C3
    .byte REST
    .byte REST
    .byte REST
    .byte END_PATTERN
.pat2:
    .byte VOICE_MAJOR_ARP ,NOTE_F3
    .byte REST
    .byte REST
    .byte REST
    .byte NOTE_F3
    .byte REST
    .byte REST
    .byte REST
    .byte NOTE_C3
    .byte REST
    .byte REST
    .byte REST
    .byte NOTE_C3
    .byte REST
    .byte REST
    .byte REST
    .byte END_PATTERN
.pat3:
    .byte VOICE_MINOR_ARP ,NOTE_G3
    .byte REST
    .byte REST
    .byte REST
    .byte VOICE_MAJOR_ARP ,NOTE_F3
    .byte REST
    .byte REST
    .byte REST
    .byte NOTE_C3
    .byte REST
    .byte REST
    .byte REST
    .byte VOICE_MINOR_ARP ,NOTE_G3
    .byte REST
    .byte VOICE_MAJOR_ARP ,NOTE_C3
    .byte REST
    .byte END_PATTERN
    
testDrumSequence subroutine
    .word .pat0
    
    .word .pat1
    .word .pat1
    .word .pat1
    
    .word .pat1
    .word .pat1
    .word .pat1
    
    .word .pat1
    .word .pat1
    .word .pat1
    
    .word .pat0
    .word 4<<1
.pat1:
    .byte  VOICE_KICK,NOTE_C1
    .byte REST
    .byte    VOICE_HAT,NOTE_C1
    .byte REST
    .byte  VOICE_SNARE,NOTE_G3
    .byte REST
    .byte    VOICE_HAT,NOTE_C1
    .byte REST
    .byte  VOICE_KICK,NOTE_C1
    .byte REST
    .byte    VOICE_HAT,NOTE_C1
    .byte REST
    .byte  VOICE_SNARE,NOTE_G3
    .byte REST
    .byte    VOICE_HAT,NOTE_C1
    .byte REST
    .byte END_PATTERN
.pat0:
    .byte  VOICE_SNARE,NOTE_G3
    .byte NOTE_G3
    .byte  VOICE_KICK,NOTE_C1
    .byte NOTE_C1
    .byte    VOICE_HAT,NOTE_C1
    .byte NOTE_C1
    .byte REST
    .byte REST
    .byte  VOICE_SNARE,NOTE_G3
    .byte NOTE_G3
    .byte  VOICE_KICK,NOTE_C1
    .byte NOTE_C1
    .byte    VOICE_HAT,NOTE_C1
    .byte NOTE_C1
    .byte REST
    .byte REST
    .byte END_PATTERN

testBassSequence subroutine
    .word .pat1
    .word 0
.pat1:
    .byte REST
    .byte   VOICE_BASS,NOTE_C2
    .byte REST
    .byte NOTE_C1
    .byte REST
    .byte NOTE_C2
    .byte REST
    .byte NOTE_C1
    .byte REST
    .byte NOTE_G2
    .byte REST
    .byte NOTE_G1
    .byte REST
    .byte NOTE_G2
    .byte REST
    .byte NOTE_G1
    .byte END_PATTERN
