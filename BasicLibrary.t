#charset "us-ascii"
#include <adv3.h>
#include <en_us.h>


versionInfo: GameID
    IFID = 'bfb43744-7f25-4149-99f0-d7d22305281d'
    name = 'Basic Lib'
    byline = 'by Th31AndOnly '
    htmlByline = 'by <a href="mailto:your-email@host.com">
                  Th31AndOnly </a>'
    version = '1'
    authorEmail = 'Th31AndOnly  <your-email@host.com>'
    desc = '#!'
    htmlDesc = '#!'
;


gameMain: GameMainDef
    initialPlayerChar = me
;

me : Actor 
    location = startRoom
;

startRoom: Room 'Start Room'
    "This is the starting room. "
;

+ table : Table 'old first table' 'first table'
    "It's a mohogany table."
;

++ pen : Thing 'pen' 'pen'
    "A fountain pen."
    subLocation = &subSurface
;

+ cabinet : Cabinet 'cabinet' 'cabinet'
    "Cabinet."
;

++ flowerpot : Thing 'flowerpot' 'flowerpot'
    "It's very pretty."
    subLocation = &subUnderside
;

+ tallTable : TallTable 'tall table' 'tall table'
    "Ornate and grand, it's high in the room."
;

++ book : Thing 'book' 'book'
    "Ooh, it's Gordon Korman's new book!"
    subLocation = &subRear
;

+ useless : Table 'useless table' 'useless table'
    "It's terrible and useless."
    isListed = true
;

+ box : GeneralBox 'cardboard box' 'cardboard box'
    "It's not even made out of cards, and don't get me started on the fact that 
        you can't surf on this thing."
    allowOn(obj) { return true; }
    allowUnder(obj) { return obj == flowerpot; }
;

+ sofa : Sofa 'sofa' 'sofa'
    "It's a sofa."
;

+ bob : Actor
    desc = "It's finally Bob!"
    name = 'bob'
    isProperName = true
    isHim = true
    vocabWords = 'bob'
    obeyCommand(fromActor, action) 
    { 
        if(action.baseActionClass is in (SitOnAction)) 
            return true; 
        else 
            return inherited(fromActor, action);   
    } 
;

+ bobette : Actor
    desc = "It's finally Bobette!"
    name = 'bobette'
    isProperName = true
    isHer = true
    vocabWords = 'bobette'
    obeyCommand(fromActor, action) 
    { 
        if(action.baseActionClass is in (SitOnAction)) 
            return true; 
        else 
            return inherited(fromActor, action);   
    } 
;

+ boberella : Actor
    desc = "It's finally Boberella!"
    name = 'boberella'
    isProperName = true
    isIt = true
    vocabWords = 'boberella'
    obeyCommand(fromActor, action) 
    { 
        if(action.baseActionClass is in (SitOnAction, GetOffOfAction)) 
            return true; 
        else 
            return inherited(fromActor, action);   
    } 
;

+ thing : Thing 'thing' 'thing'
    desc = "<<(cube.self_).desc>>"
;

+ cube : Transformer 'cube' 'cube'
    "It's a cube."
    dobjFor(Examine) {
        action() { inherited(); self.transform(); }
    }
    referenceObj = sphere
;


sphere : Thing 'sphere' 'sphere'
    "It's a sphere."
;

script1 : RunningScript
    run() {
        book.desc = "<<one of>>Woah!<<or>>Oops!<<at random>>";
    }
;



