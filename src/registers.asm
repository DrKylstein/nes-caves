; -- registers.h -- ;
; PPU
    SEG.U PPU_REGISTERS
    ORG $2000
PPU_CTRL ds 1
PPU_MASK ds 1
PPU_STATUS ds 1
OAM_ADDR ds 1
OAM_DATA ds 1
PPU_SCROLL ds 1
PPU_ADDR ds 1
PPU_DATA ds 1
; pAPU
    SEG.U APU_REGISTERS
    ORG $4000
APU_PULSE1_CTRL ds 1
APU_PULSE1_RAMP_CTRL ds 1
APU_PULSE1_FT ds 1
APU_PULSE1_CT ds 1
APU_PULSE2_CTRL ds 1
APU_PULSE2_RAMP_CTRL ds 1
APU_PULSE2_FT ds 1
APU_PULSE2_CT ds 1
APU_TRI_CTRL1 ds 1
APU_TRI_CTRL2 ds 1
APU_TRI_FREQ1 ds 1
APU_TRI_FREQ2 ds 1
APU_NOISE_CTRL1 ds 1
APU_NOISE_CTRL2 ds 1
APU_NOISE_FREQ1 ds 1
APU_NOISE_FREQ2 ds 1
APU_DMC_CTRL ds 1
APU_DMC_DA ds 1
APU_DMC_ADDR ds 1
APU_DMC_DL ds 1
OAM_DMA ds 1
APU_CLOCK ds 1
JOYPAD1 ds 1
JOYPAD2 ds 1
;;UNROM
    ; ORG $8000
; UNROM ds 1
;;CNROM
    ; ORG $8000
; CNROM ds 1
;;MMC1
    ; ORG $8000
; MMC1_CTRL ds 1
    ; ORG $A000
; MMC1_VROM_LOW ds 1
    ; ORG $C000
; MMC1_VROM_HIGH ds 1
    ; ORG $E000
; MMC1_PRG ds 1
;;MMC3
    ; ORG $8000
; MMC3_CMD ds 1
; MMC3_PAGE ds 1
    ; ORG $A000
; MMC3_MIRR ds 1
; MMC3_SRAM ds 1
    ; ORG $C000
; MMC3_CLOCK ds 1
; MMC3_CLOCK_LATCH ds 1
    ; ORG $E000
; MMC3_CLOCK_OFF ds 1
; MMC3_CLOCK_ON ds 1
