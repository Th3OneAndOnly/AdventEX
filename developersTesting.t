#charset "us-ascii"
#include <adv3.h>
#include <en_us.h>

#ifdef __DEBUG
    #define dbgNoun(x) vocabWords = x
#else
    #define dbgNoun(x)
#endif


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

newRoom : Room 'New Room' 'the new room'
    "It's new!"
    north = startRoom
    dbgNoun('New Room')
;

startRoom: Room 'Start Room'
    "This is the starting room. "
    north = newRoom
    northDirLoc = 'north'
    dbgNoun('Start Room')
;

+ table : Table, Heavy 'old first table' 'first table'
    "It's a mohogany table."
;

++ pen : Thing 'pen' 'pen'
    "A fountain pen."
    subLocation = &subSurface
;

+ cabinet : Cabinet, Fixture 'cabinet' 'cabinet'
    "Cabinet."
;

++ flowerpot : Thing 'flowerpot' 'flowerpot'
    "It's very pretty."
    subLocation = &subUnderside
;

+ tallTable : TallTable, Heavy 'tall table' 'tall table'
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

+ bob : Person
    desc = "It's finally Bob!"
    name = 'bob'
    isProperName = true
    isHim = true
    vocabWords = 'bob'
    obeyCommand(fromActor, action) 
    { 
        if(action.baseActionClass is in (SitOnAction, GetOffOfAction)) 
            return true; 
        else 
            return inherited(fromActor, action);   
    } 
;

+ bobette : Person
    desc = "It's finally Bobette!"
    name = 'bobette'
    isProperName = true
    isHer = true
    vocabWords = 'bobette'
    obeyCommand(fromActor, action) 
    { 
        if(action.baseActionClass is in (SitOnAction, GetOffOfAction)) 
            return true; 
        else 
            return inherited(fromActor, action);   
    } 
;

+ boberella : Person
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

+ cube : Transformable, Thing 'cube' 'cube'
    "It's a <<script3.run('cube')>>. <<script1.end()>>"
    dobjFor(Examine) {
        action() { inherited(); self.transform(); }
    }
    referenceObj = sphere
;

+ pyramid : Transformable, Thing 'pyramid' 'pyramid'
    "Weird... It seems to shift as you look at it..."
    dobjFor(Examine) {
        action() { inherited(); self.transform(); }
    }
    referenceObj = triangle
;

+ glassObject : Breakable, Thing 'glass object' 'glass object'
    "It's very fragile -- better not drop it."
    dobjFor(Drop) {
        action() { 
            makeBroken(!broken); 
            if(!broken) {
                setMethod(&desc, {: "Crazy!"});
                updateStandardDesc();
            }
            inherited(); 
        }
    }
;

+ ice : Burnable, Thing 'ice cube' 'ice cube'
    "ICE!"
    melted = nil
    dobjFor(Burn) {
        verify() { }
        action() {
            if(!burnt)
                makeBurnt(true);
            else
                melt();
        }
    }
;

triangle : Transformable, Thing 'triangle' 'triangle'
    "Weird... It seems to shift as you look at it..."
    dobjFor(Examine) {
        action() { inherited(); self.transform(); }
    }
    referenceObj = pyramid
;



sphere : Thing 'sphere' 'sphere'
    "It's a sphere. <<script2.run(script2.targetActor, nil)>>"
;

script1 : RunningScript
    run(isDaemon) {
        "Hey!";
        return 'Hey!';
    }
    runEvery = 3
;

/* 
 *   You can make it like a Fuse by using end()
 */
script2 : ActorScript
    run(actor, isDaemon) {
        if(isDaemon)
            actor.name = 'not bob';
        else
            actor.name = 'not not bob';
        end();
    }
    targetActor = bob
    runEvery = 2
;

script3 : RunningScript
    /* 
     *   It's perfectly legal to pass custom parameters into it, as long as you
     *   prevent the daemon from running it. Or else it would try to run it with
     *   the wrong params and you'd get errors/faulty code. Use a seperate
     *   script object to pass whatever params you choose into it.
     */
    run(customParam) {
        return customParam;
    }
    /* This prevents a Daemon from automatically running it. */
    runEvery = nil
;


/* 
 *   They can be as simple as this, though note you can't reference it without a
 *   variable. Is a bit annoying, so I commented it out.
 */
//RunningScript
//    run(isDaemon) {
//        "I'm being run by a RunningScript!";
//    }
//;


