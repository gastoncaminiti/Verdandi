VAR  max_turn = 3
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
        ->END
 }
 
=== halagaz_kenningars ===
{~But the warrior found the light-of-battle was loath to bite, to hard the heart.|Soon then saw that shepherd-of-evils that never he met in this middle-world, in the ways of earth, another wight with heavier hand-gripe}
-> main_game

=== default_kenningars ===
{~a shaman's gathering place|large-scale battle}
-> main_game

=== naudiz_kenningars ===
{~Ne’er heard I of host in haughtier throng more graciously gathered round giver-of-rings!|killed by an avalanche}
-> main_game

=== isa_kenningars ===
{~Go to the bench now, battle-adorned.|Mid the battle-gear he saw a blade triumphant, old-sword of Eotens, with edge of proof, warriors’ heirloom, weapon unmatched}
-> main_game

===  get_kenningar(rune) ===
   ~  runes -= rune
   {LIST_VALUE(rune):
    - 1:     -> halagaz_kenningars
    - 2:     -> naudiz_kenningars
    - 3:     -> isa_kenningars 
    - else:  -> default_kenningars
    }
    
    