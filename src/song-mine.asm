song_mine subroutine
    .byte 12
    .word .leadSeq
    .word .percussionSeq
    .word .bassSeq
    .word 0
    
.leadSeq:
    .word .leadRest
    .word .leadRest
    .word .lead1
    .word .lead1
    .word .lead1
    .word .leadRest
    .word .lead2
    .word .lead2
    .word .lead1
    .word .lead1
    .word 1 << 1
.leadRest:
    .byte VOICE_GUITAR2,REST
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
.lead1:
    .byte NOTE_G3
    .byte REST
    .byte REST
    .byte REST
    .byte NOTE_G3
    .byte REST
    .byte REST
    .byte REST
    .byte NOTE_A2S
    .byte REST
    .byte REST
    .byte REST
    .byte NOTE_A2S
    .byte REST
    .byte REST
    .byte REST
    .byte END_PATTERN
.lead2:
    .byte NOTE_A3
    .byte NOTE_D4
    .byte NOTE_A3
    .byte NOTE_D2
    .byte NOTE_G3
    .byte REST
    .byte NOTE_G3
    .byte NOTE_C3
    .byte REST
    .byte NOTE_C3
    .byte REST
    .byte NOTE_D3
    .byte REST
    .byte NOTE_D3S
    .byte REST
    .byte END_PATTERN,REST
.percussionSeq:
    .word .percussion1
    .word 0
.percussion1:
    .byte VOICE_HAT,NOTE_C1
    .byte NOTE_C1
    .byte NOTE_C1
    .byte NOTE_C1
    .byte NOTE_C1
    .byte NOTE_C1
    .byte NOTE_C1
    .byte NOTE_C1
    .byte END_PATTERN

.bassSeq:
    .word .bass0
    .word .bass1
    .word .bass1
    .word .bass1
    .word .bass1
    .word .bass2
    .word .bass2
    .word .bass2
    .word .bass1
    .word .bass1
    .word 1 << 1
.bass0:
    .byte VOICE_BASS,REST
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
    .byte NOTE_C3
    .byte REST
    .byte REST
    .byte NOTE_C3
    .byte NOTE_G2
    .byte REST
    .byte REST
    .byte NOTE_C3
    .byte REST
    .byte NOTE_C3
    .byte REST
    .byte NOTE_G2
    .byte NOTE_A2S
    .byte NOTE_A2S
    .byte NOTE_C3
    .byte NOTE_A2S
    .byte END_PATTERN
.bass2:
    .byte NOTE_D3
    .byte NOTE_G3
    .byte NOTE_D3
    .byte NOTE_G2
    .byte NOTE_C3
    .byte REST
    .byte NOTE_C3
    .byte NOTE_E2
    .byte REST
    .byte NOTE_F2
    .byte REST
    .byte NOTE_F2S
    .byte REST
    .byte NOTE_G2
    .byte REST
    .byte REST
    .byte END_PATTERN