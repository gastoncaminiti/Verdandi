VAR  max_turn = 3
VAR  points   = 0
LIST runes = (halagaz), (naudiz), (isa), (jera), (eihwaz), (perth), (algiz)

-> main_game

=== main_game ===
~ temp pick_rune = LIST_RANDOM(runes)
 {
    - (LIST_COUNT(runes) > 0) && (TURNS() < max_turn):
        + Play {pick_rune}
        -> get_kenningar(pick_rune)
    - else:
        Final 
        {points}
        {TURNS()}
        {points/TURNS()}
        ->END
 }
 
=== halagaz_kenningars ===
~ temp k1 = "But the warrior found the light-of-battle was loath to bite, to hard the heart"
~ temp k2 = "In the ways of earth, another wight with heavier hand-gripe"
~ temp k3 = "Legendary kenningar"
{kenningars_choices(k1,k2,k3)}
-> main_game

=== default_kenningars ===
~ temp k1 = "a shaman's gathering place"
~ temp k2 = "large-scale battle"
~ temp k3 = "Legendary kenningar"
{kenningars_choices(k1,k2,k3)}
-> main_game

=== naudiz_kenningars ===
~ temp k1 = "Ne’er heard I of host in haughtier throng more graciously gathered round giver-of-rings!"
~ temp k2 = "killed by an avalanche"
~ temp k3 = "Legendary kenningar"
{kenningars_choices(k1,k2,k3)}
-> main_game

=== isa_kenningars ===
~ temp k1 = "Go to the bench now, battle-adorned."
~ temp k2 = "Mid the battle-gear he saw a blade triumphant, old-sword of Eotens, with edge of proof, warriors’ heirloom, weapon unmatched"
~ temp k3 = "Legendary kenningar"
{kenningars_choices(k1,k2,k3)}
-> main_game

===  get_kenningar(rune) ===
   ~  runes -= rune
   {LIST_VALUE(rune):
    - 1:     -> halagaz_kenningars
    - 2:     -> naudiz_kenningars
    - 3:     -> isa_kenningars 
    - else:  -> default_kenningars
    }
    
=== function kenningars_choices(k1,k2,k3) ===
   {RANDOM(1,3):
    - 1: 
        ~ points+=1
        ~ return k1
    - 2: 
        ~ points+=2
        ~ return k2
    - 3: 
        ~ points+=3
        ~ return k3
    }