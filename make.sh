#!/bin/bash
set -e
EXOMIZER=${EXOMIZER:=/w/exomizer31/src/exomizer}
BEEBASM=${BEEBASM:-beebasm}
BBCIM=${BBCIM:-bbcim}
DISC=${DISC:-pics.ssd}
function im {
    (cd build;
    ln -sf ../data/"$1" pic.bin
    $BEEBASM -i ../image.s  -D COL0="$2" -D COL1="$3" -D COL2="$4" -D COL3="$5" -v >"$6".txt
    $EXOMIZER sfx 0x6b0 -P+16 -n -D i_perf=1 -D i_table_addr=0x400 -D i_irq_during=0 -Di_irq_exit=0 -s 'sec ror $ff lda #126 jsr $fff4 lda #8 sta $fe00 lda #$f8 ora $291 sta $fe01 lda #3 sta $258 lda #$8f ldx #$0c ldy #$ff jsr $fff4 ldx #$ff txs' -t 0xbbcb pic@0x6b0 -o "$6"
    $BBCIM -a ../$DISC "$6"
    )
}
$BBCIM -new $DISC
$BBCIM -boot $DISC none
mkdir -p build
im munku-sardyk-bbcmicro.mode1.bin 0 7 4 6 MUNKU
im parrot-bbcmicro.mode1.bin 0 1 7 3 PARROT
im mezquita-bbcmicro.mode1.bin 0 4 1 2 MEZQ
im keyssunset-bbcmicro.mode1.bin 0 1 3 7 SUNSET
im fontain-bbcmicro.mode1.bin 0 1 2 7 POND
im beebs-bbcmicro.mode1.bin 0 7 1 2 BEEBS
im lenna-bbcmicro.mode1.bin 0 7 5 1 LENNA
im Hosta_two-tone_3-bbcmicro.mode1.bin 0 2 3 7 HOSTA
im Golden_Gate_Bridge-bbcmicro.mode1.bin 0 4 1 2 GOLDEN
