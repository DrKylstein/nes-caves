song_industrial subroutine
    .byte 6
    .word .drumTrack
    .word .bassTrack
    .word 0
    .word 0
.drumTrack:
    .word .drum0
    .word .drum0
    
    .word .drum1
    .word .drum2
    .word .drum1
    .word .drum2
    .word .drum1
    
    .word .drum0
    .word .drum0
    .word 2<<1
.drum1:
    .byte VOICE_KICK,NOTE_C1
    .byte REST
    .byte REST
    .byte REST
    .byte VOICE_SNARE,NOTE_G3
    .byte REST
    .byte VOICE_KICK,NOTE_G3
    .byte VOICE_KICK,NOTE_G3
    .byte VOICE_KICK,NOTE_G3
    .byte REST
    .byte VOICE_KICK ,NOTE_G3
    .byte REST
    .byte VOICE_SNARE ,NOTE_G3
    .byte REST
    .byte VOICE_KICK ,NOTE_G3
    .byte REST
    .byte END_PATTERN
.drum2:
    .byte VOICE_KICK ,NOTE_G3
    .byte REST
    .byte REST
    .byte REST
    .byte VOICE_SNARE ,NOTE_G3
    .byte REST
    .byte VOICE_KICK ,NOTE_G3
    .byte VOICE_KICK ,NOTE_G3
    .byte REST
    .byte REST
    .byte REST
    .byte VOICE_KICK ,NOTE_G3
    .byte VOICE_SNARE ,NOTE_G3
    .byte REST
    .byte REST
    .byte REST
    .byte END_PATTERN
.drum0:
    .byte VOICE_SNARE ,NOTE_G3
    .byte NOTE_G3
    .byte NOTE_G3
    .byte REST
    .byte NOTE_G3
    .byte NOTE_G3
    .byte REST
    .byte NOTE_G3
    .byte NOTE_G3
    .byte REST
    .byte NOTE_G3
    .byte REST
    .byte REST
    .byte REST
    .byte REST
    .byte REST
    .byte END_PATTERN
    
.bassTrack:
    .word .bass0
    .word .bass0
    
    .word .bass0
    .word .bass0
    .word .bass0
    .word .bass0
    .word .bass0

    .word .bass0
    .word .bass0
    
    .word .bass1
    .word .bass1
    .word .bass0
    .word .bass2
    .word .bass2
    
    .word .bass0
    .word .bass0
    
    .word .bass3
    .word .bass4
    .word .bass0
    .word .bass3
    .word .bass4
    
    .word .bass0
    .word .bass0

    .word .bass0
    .word .bass0
    .word .bass0
    .word .bass0
    .word .bass0

    .word .bass0
    .word .bass0

    .word .bass1
    .word .bass2
    .word .bass0
    .word .bass3
    .word .bass4
    
    .word .bass0
    .word .bass0
    .word 1<<2
.bass0:
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
.bass1:
    .byte VOICE_GUITAR2
    
    .byte NOTE_D1S
    .byte REST
    .byte NOTE_C1
    .byte NOTE_G1S
    .byte REST
    .byte NOTE_D1S
    .byte REST
    .byte NOTE_D1S
    .byte REST
    .byte REST
    .byte NOTE_G1S
    .byte REST
    .byte NOTE_C1
    .byte REST
    .byte REST
    .byte REST
    
    .byte END_PATTERN
.bass2:
    .byte VOICE_GUITAR2
    
    .byte NOTE_C1
    .byte REST
    .byte NOTE_G1S
    .byte NOTE_C1
    .byte NOTE_D1S
    .byte NOTE_C1
    .byte REST
    .byte REST
    .byte REST
    .byte NOTE_G1S
    .byte NOTE_D1S
    .byte REST
    .byte NOTE_C1
    .byte NOTE_D1S
    .byte REST
    .byte REST
    
    .byte END_PATTERN
.bass3:
    .byte VOICE_GUITAR2
    
    .byte NOTE_D1S
    .byte REST
    .byte NOTE_D1S
    .byte REST
    .byte NOTE_D1S
    .byte REST
    .byte REST
    .byte NOTE_G1S
    .byte REST
    .byte NOTE_C1
    .byte REST
    .byte NOTE_C1
    .byte REST
    .byte NOTE_C1
    .byte REST
    .byte REST
    
    .byte END_PATTERN
.bass4:
    .byte VOICE_GUITAR2
    
    .byte NOTE_G1S
    .byte REST
    .byte NOTE_C1
    .byte REST
    .byte NOTE_D1S
    .byte REST
    .byte NOTE_C1
    .byte REST
    .byte NOTE_D1S
    .byte REST
    .byte NOTE_C1
    .byte REST
    .byte NOTE_C1
    .byte REST
    .byte NOTE_C1
    .byte REST
    
    .byte END_PATTERN
