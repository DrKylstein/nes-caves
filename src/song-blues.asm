song_blues subroutine
    .byte 4
    .word .seq_bass
    .word .seq_lead
    .word 0
    .word 0

.seq_bass:
    .word .pat_bass1
    .word .pat_bass2
    .word .pat_bass1
    .word .pat_bass0
    .word 0

.seq_drums:
    .word .pat_drums1
    .word 0
    
.seq_lead:
    .word .pat_lead0
    .word .pat_lead1
    .word 1<<1
    
.pat_drums0:
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
    
.pat_drums1:
    .byte VOICE_KICK,NOTE_C1
    .byte REST
    .byte REST
    .byte REST
    
    .byte VOICE_SNARE,NOTE_G3
    .byte REST
    
    .byte VOICE_KICK,NOTE_C1
    .byte REST
    .byte REST
    .byte REST
    
    .byte VOICE_SNARE,NOTE_G3
    .byte REST
    .byte END_PATTERN

.pat_bass0:
    .byte VOICE_BASS
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

    .byte REST
    .byte REST


    .byte REST
    .byte REST
    .byte REST
    .byte REST
    
    .byte REST
    .byte REST
    .byte END_PATTERN
    
.pat_bass1:
    .byte VOICE_BASS
    .byte NOTE_E2
    .byte REST
    .byte REST
    .byte REST

    .byte REST
    .byte REST


    .byte REST
    .byte REST
    .byte REST
    .byte REST

    .byte NOTE_F2S
    .byte REST
    
    
    .byte NOTE_G2
    .byte REST
    .byte REST
    .byte REST

    .byte REST
    .byte REST


    .byte NOTE_G2S
    .byte REST
    .byte REST
    .byte REST
    
    .byte NOTE_A2
    .byte REST
    .byte END_PATTERN
    
.pat_bass2:
    .byte VOICE_BASS
    .byte REST
    .byte REST
    .byte REST
    .byte REST

    .byte NOTE_D2
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
    
    
    .byte NOTE_D2S
    .byte REST
    .byte REST
    .byte REST

    .byte REST
    .byte REST
    .byte END_PATTERN
    
.pat_lead0:
    .byte VOICE_GUITAR2
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
    
.pat_lead1:
    .byte NOTE_A2
    .byte REST
    .byte REST
    .byte REST
    
    .byte NOTE_F2
    .byte REST
    
    
    .byte NOTE_A2
    .byte REST
    .byte REST
    .byte REST
    
    .byte NOTE_F2
    .byte REST
    
    
    .byte NOTE_A2
    .byte REST
    .byte REST
    .byte REST
    
    .byte NOTE_F2
    .byte REST
    
    
    .byte NOTE_E2
    .byte REST
    .byte REST
    .byte REST
    
    .byte REST
    .byte REST



    .byte NOTE_A2
    .byte REST
    .byte REST
    .byte REST
    
    .byte NOTE_F2
    .byte REST
    
    
    .byte NOTE_A2
    .byte REST
    .byte REST
    .byte REST
    
    .byte NOTE_F2
    .byte REST
    
    
    .byte NOTE_A2
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


    .byte NOTE_A2
    .byte REST
    .byte REST
    .byte REST
    
    .byte NOTE_F2
    .byte REST
    
    
    
    .byte NOTE_A2
    .byte REST
    .byte REST
    .byte REST
    
    .byte NOTE_F2
    .byte REST
    
    .byte NOTE_A2
    .byte REST
    .byte REST
    .byte REST
    
    .byte NOTE_F2
    .byte REST
    
    .byte NOTE_E2
    .byte REST
    .byte REST
    .byte REST
    
    .byte REST
    .byte REST
    
    .byte NOTE_A2
    .byte REST
    .byte REST
    .byte REST
    
    .byte REST
    .byte REST

    .byte NOTE_C3
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
    .byte REST
    .byte END_PATTERN
