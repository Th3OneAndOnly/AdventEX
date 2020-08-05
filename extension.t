#charset "us-ascii"
#include <adv3.h>
#include <en_us.h>

/* ------------------------------------------------------------------------ */
// FURNITURE CODE



/* 
 *   This next set of classes define the important stuff for GeneralBox. They
 *   are also useful in your own code, if you want to shorten up object
 *   definitions a bit.
 */
class ComplexSurface : ComplexComponent, Surface
    /* 
     *   The PutOn action. We check our allowOn with the object we wanna put in
     *   us, and if it doesn't pass, fail it with our failMsg.
     */
    iobjFor(PutOn) {
        verify() { 
            if(targetObj.allowOn(gDobj)) { 
                logical; }
            else { 
                illogical(targetObj.failOnMsg); }
        }
    }
;
class ComplexUnderside : ComplexComponent, Underside
    /* 
     *   The PutUnder action. We check our allowUnder with the object we wanna
     *   put in us, and if it doesn't pass, fail it with our failMsg.
     */
    iobjFor(PutUnder) {
        verify() { 
            if(targetObj.allowUnder(gDobj)) { 
                logical; }
            else { 
                illogical(targetObj.failUnderMsg); }
        }
    }
;
class ComplexRearContainer : ComplexComponent, RearContainer
    /* 
     *   The PutBehind action. We check our allowBehind with the object we wanna
     *   put in us, and if it doesn't pass, fail it with our failMsg.
     */
    iobjFor(PutBehind) {
        verify() { 
            if(targetObj.allowBehind(gDobj)) {
                logical; }
            else { 
                illogical(targetObj.failBehindMsg); }
        }
    }
;
class ComplexRearSurface : ComplexComponent, RearSurface
    /* 
     *   We do the same as the container up above.
     */
    iobjFor(PutBehind) {
        verify() { 
            if(targetObj.allowBehind(gDobj)) {
                logical; }
            else { 
                illogical(targetObj.failBehindMsg); }
        }
    }
;
/* We don't mess with Containers as they define all things we need anyway. */
class ComplexInnerContainer : ComplexComponent, Container
;
class RestrictInnerContainer : ComplexComponent, RestrictedContainer
;

/* 
 *   We modify the ComplexContainer to include these values so I don't have to
 *   write them -- they won't work in your code unless you use GeneralBox.
 */
modify ComplexContainer
    allowBehind(obj) { return true; }
    allowOn(obj) { return true; }
    allowUnder(obj) { return true; }
    failOnMsg = 'You can\'t put that on there. '
    failBehindMsg = 'You can\'t put that behind there.'
    failUnderMsg = 'You can\'t put that under there.'
;



/*
 *   A basic Table, where you can put stuff on and under.
 */
class Table : ComplexContainer
    /* 
     *   Define our subSurface and subUnderside as perInstance objects
     */
    subSurface = perInstance(new ComplexSurface())
    subUnderside = perInstance(new ComplexUnderside())
    initializeThing() {
        /* 
         *   Move these into ourselves and set the targetObj (which sets their
         *   names to ours) then call our inherited initalizer.
         */
        subSurface.moveInto(self);
        subUnderside.moveInto(self);
        subSurface.targetObj = self;
        subUnderside.targetObj = self;
        inherited();
    }
    /* 
     *   Make sure our contents are not listed, so we don't repeat ourselves in
     *   the transcript.
     */
    contentsListed = nil
;


/* 
 *   A Cabinet is an object where you can put stuff under, behind, or in, but
 *   is generally too high to put stuff on it.
 */
class Cabinet : ComplexContainer
    subRear = perInstance(new ComplexRearContainer())
    subUnderside = perInstance(new ComplexUnderside())
    subContainer = perInstance(new ComplexInnerContainer())
    initializeThing() {
        subRear.moveInto(self);
        subUnderside.moveInto(self);
        subContainer.moveInto(self);
        subContainer.targetObj = self;
        subRear.targetObj = self;
        subUnderside.targetObj = self;
        inherited();
    }
    contentsListed = nil
;

/* 
 *   A TallTable refers to an object where it's too tall (or inaccessible) to
 *   put things on top, but you can place things below or behind.
 */
class TallTable : ComplexContainer
    subRear = perInstance(new ComplexRearContainer())
    subUnderside = perInstance(new ComplexUnderside())
    initializeThing() {
        subRear.moveInto(self);
        subUnderside.moveInto(self);
        subRear.targetObj = self;
        subUnderside.targetObj = self;
        inherited();
    }
    contentsListed = nil
;

/* 
 *   FloorCabinet - An object that allows things in, on, or behind, but not
 *   under.
 */
class FloorCabinet : ComplexContainer
    subRear = perInstance(new ComplexRearContainer())
    subContainer = perInstance(new ComplexInnerContainer())
    subSurface = perInstance(new ComplexSurface())
    initializeThing() {
        subRear.moveInto(self);
        subSurface.moveInto(self);
        subContainer.moveInto(self);
        subContainer.targetObj = self;
        subRear.targetObj = self;
        subSurface.targetObj = self;
        inherited();
    }
    contentsListed = nil
;

/* 
 *   A GeneralBox is a class where the author can define exactly which of it's
 *   containers are active at any given time to any given object. It's very
 *   useful for many situations where you want to define a custom object like a
 *   print scanner, or something else.
 */
class GeneralBox : ComplexContainer
    /* This is standard, like the specialized furniture objects above. */
    subRear = perInstance(new ComplexRearContainer())
    subUnderside = perInstance(new ComplexUnderside())
    subContainer = perInstance(new ComplexInnerContainer())
    subSurface = perInstance(new ComplexSurface())
    initializeThing() {
        subRear.moveInto(self);
        subSurface.moveInto(self);
        subContainer.moveInto(self);
        subUnderside.moveInto(self);
        subContainer.targetObj = self;
        subRear.targetObj = self;
        subSurface.targetObj = self;
        subUnderside.targetObj = self;
        
        
        inherited();
        
    }
    
    
    contentsListed = nil
    /* 
     *   These are just initially set to nil. The other furniture pieces aren't
     *   meant to be messed with (as they exist purely to tidy up and shorten
     *   code) but these are made to be changed. As such, we need messages to
     *   send to the player on fail.
     */
    allowBehind(obj) { return nil; }
    allowOn(obj) { return nil; }
    allowUnder(obj) { return nil; }
    failOnMsg = 'You can\'t put that on there. '
    failBehindMsg = 'You can\'t put that behind there.'
    failUnderMsg = 'You can\'t put that under there.'
;

/* 
 *   A RestrictedBox is a GeneralBox using a RestrictedContainer instead. It's
 *   good to use this to make a completely custom object.
 *
 */
class RestrictedBox : GeneralBox
    subContainer = perInstance(new RestrictInnerContainer())
    contentsListed = nil
;

/* 
 *   A Sofa is a Chair that can hold multiple actors, but only a specified
 *   amount. A little niche, sure. But useful in some cases.
 */
class Sofa : Chair
    maxActors = 3
    tooFullMsg = 'The {the dobj/him} can\'t fit any more people.'
    dobjFor(SitOn) {
        verify() { 
            if(contents.length() + 1 > maxActors && gDobj.ofKind(Actor))
                illogical(tooFullMsg);
            else
                inherited();
        }
    }
    maxSingleBulk = 20
;

/* ---------------------------------------------------------------------- */
// EXTRA CLASSES CODE

/* 
 *   For the Transformable -
 *.      Give everything a self_ tag just in case you want to loop over every
 *.      object, and it may or may not be a Transformable, using obj.self_ still
 *.      works.
 */
modify Object
    self_ = self
;

/* 
 *   A Transformable is a class that allows an object to be transformed - that
 *   is, CHANGED into another type of object. It remains the same object, just
 *   changed. Use referenceObj to specify what object to transform into.
 */
class Transformable : object
    /* 
     *   Are we transformed? Don't change this in your code -- use
     *   obj.transform().
     */
    transformed = nil
    /* 
     *   The reference object is an object that DOES NOT exists in the world, is
     *   moved into nil then replaces this object when transformed. You can use
     *   an anonymous object, or reference another.
     */
    referenceObj = nil
    /* 
     *   The Unthing's notHereMsg and name. This Unthing is left behind when we
     *   transform, in case you're lazy and don't let the player know it got
     *   transformed, and the player asks about it.
     */
    unThingNotHereMsg = '\^<<referenceObj.theName>> used to be that.'
    unThingName = name
    /* 
     *   In our initializer, move our reference object into nil, so it doesn't
     *   exist, and set it's targetObj, if it's a NameAsOther, to us. If we have
     *   an unThing to leave behind, be sure to initialize it properly.
     */
    initializeThing() {
        if(!referenceObj.ofKind(Transformable))
            referenceObj.moveInto(nil);
        referenceObj.targetObj = self;
        if(unThing != nil) {
            unThing.notHereMsg = unThingNotHereMsg;
            unThing.name = unThingName;
            unThing.location = nil;
        }
        inherited();
    }
    /* 
     *   Calling this method moves our reference object here, and if we have an
     *   unThing, move that too, then we move ourselves straight into nil. We
     *   also redefined our self_ prop to our reference object to ease the
     *   process of referring to this object's name, properties, and such.
     */
    transform() {
        referenceObj.moveInto(location);
        if(unThing != nil) {
            unThing.initializeVocabWith(vocabWords);
            unThing.moveInto(location);
        }
        moveInto(nil);
        self_ = referenceObj;
        transformed = true;
    }
    /* 
     *   Set this to nil if you don't want to leave an Unthing behind when we
     *   transform.
     */
    unThing = perInstance(new Unthing())
    /* 
     *   Is the current object us? Use this in your own code as short-hand.
     */
    isMe = (self.self_ == self)
;

/* 
 *   A Breakable object can be broken. For example, a glass jar  will turn into
 *   a (broken) glass jar when glassJar.makeBroken(true) is called. Note this
 *   means an object can be 'unbroken', i.e. by using tape or whatever you
 *   program into there.
 */
class Breakable : object
    /* Should we append to the desc or replace it? */
    replaceDesc = nil
    /* Should we append to the name or replace it? */
    replaceName = nil
    /* 
     *   Are we broken? Never change this directly -- use makeBroken(state) to
     *   do that.
     */
    broken = nil
    /* 
     *   Don't change this, as this stores the original desc property of the 
     *   object.
     */
    standardDesc = nil
    /* 
     *   This is the little bit tacked on the end of the description when
     *   broken. DOUBLE QUOTES! P. S.: If you change your desc property, ALWAYS
     *   call updateStandardDesc() or it will be LOST upon breaking or fixing.
     *   Setting this to a function doesn't work well.
     */
    brokenDesc = "<.p>It\'s broken."
    /* 
     *   This is the prefix that goes on the beginning of the name of the object
     *   when broken. Setting this to a function doesn't work well.
     */
    brokenPrefix = '(broken) '
    /* 
     *   The vocab word added as an adjective when it's broken. Be careful when
     *   changing this, if you do. Setting this to a function doesn't work well.
     */
    brokenVocab = '(broken)'
    /* 
     *   Used for stating stuff like 'the object is broken'. Change this if
     *   you're using broken differently. Setting this to a function doesn't
     *   work well.
     */
    brokenState = 'broken'
    /* Used to store name if needed. */
    oldName_ = nil
    /* Set our standardDesc initially. */
    initializeThing() {
        standardDesc = getMethod(&desc);
        inherited();
    }
    /* 
     *   The standard function for making an object broken or fixed. Use
     *   makeBroken(true) to break it, and makeBroken(nil) to fix it.
     */
    makeBroken(state) {
        /* 
         *   If we are already at this state, do nothing, as we don't want to
         *   affect standardDesc mistakenly.
         */
        if(broken != state) {
            /* 
             *   We are switching states, so first store the name we have now
             *   for future use.
             */
            local nowName = name;
            /* Set our broken state */
            broken = state;
            /* Are we breaking or fixing? */
            if(state) {
                /* 
                 *   We're breaking, so prepend our prefix to our name, and set
                 *   the desc property to the original + our brokenDesc(). We
                 *   also add the (broken) vocab to the object for the player.
                 */
                if(!replaceName)
                    name = brokenPrefix + nowName;
                else
                    oldName_ = name;
                    name = brokenPrefix;
                if(!replaceDesc)
                    setMethod(&desc, {: "<<standardDesc()>><<brokenDesc()>>" });
                else
                    setMethod(&desc, {: "<<brokenDesc()>>"});
                cmdDict.addWord(self, brokenVocab, &adjective);
                
            } else {
                /* 
                 *   We are fixing, so find the first instance of our prefix
                 *   (since it's our prefix, we can assume it would be the first
                 *   one.) Hopefully you didn't change it in between and mess it
                 *   up... Then we reset the desc prop and remove the (broken)
                 *   vocab word.
                 */
                if(!replaceName)
                    name = nowName.findReplace(brokenPrefix, '', ReplaceOnce);
                else
                    name = oldName_;
                setMethod(&desc, standardDesc);
                cmdDict.removeWord(self, brokenVocab, &adjective);
            }
        }
    }
    
    /* 
     *   Simple update our standardDesc, so we can use it while breaking or
     *   fixing.
     */
    updateStandardDesc() {
        setMethod(&standardDesc, getMethod(&desc));
    }
    /* 
     *   By default, we define any action that defines us as the indirect object
     *   as unfit for us to use, as we're broken. Customize this at will!
     */
    iobjFor(All) {
        verify() { if(broken) illogicalNow('It doesn\'t work, as {the iobj/him} is <<brokenState>>.'); }
    }
    
;

/* 
 *   A Freezeable object is more or less an example of defining a custom use for
 *   the Breakable class, so you don't have to use Breakable just for breaking
 *   things.
 */
class Freezeable : Breakable
    /* 
     *   Make sure to set your description, prefix, vocab word to add, and
     *   state.
     */
    brokenDesc = "<.p>It's frozen."
    brokenPrefix = '(frozen) '
    brokenVocab = '(frozen)'
    brokenState = 'frozen'
    /* 
     *   Also make frozen and makeFrozen equivalent to their respective broken
     *   counterparts.
     */
    frozen = broken
    makeFrozen(state) { makeBroken(state); }
;

/* 
 *   A Burnable object is like Freexeable, but if you melt() it, it will become
 *   COMPLETEY unusable, as in melted beyond repair.
 */
class Burnable : Breakable
    /* 
     *   DON'T change this directly, only use this conditionally statements. Use
     *   melt() instead.
     */
    melted = nil
    /* 
     *   Our standard burn props to replace broken. These will be changed to
     *   melted later, upon melting.
     */
    brokenDesc = "<.p>It's melted."
    
    brokenPrefix = '(burnt) '
    
    brokenVocab = '(burnt)'
    
    brokenState = 'burnt'
    /* Set our burnt and makeBurnt() to our counterparts... */
    burnt = broken
    
    makeBurnt(state) { makeBroken(state); }
    
    /* 
     *   We have to redefine makeBroken() to include our melting behavior, so we
     *   always melt when meant to.
     */
    makeBroken(state) {
        /* 
         *   If we are meant to melt, always make sure we're melted, as melting
         *   is intended to be permament.
         */
        local nowName = name;
        if(melted) {
            name = brokenPrefix + nowName;
            setMethod(&desc, {: "<<brokenDesc()>>" });
            cmdDict.addWord(self, brokenVocab, &adjective);
        } else {
            /* We aren't melting so call our inherited biz. */
            inherited(state);
        }
    }
    /* 
     *   If we're melted, and we're invovled with a command, prevent it, as
     *   melted objects are completely useless. If not, treat it as normal.
     */
    beforeAction() {
        if(melted && (gDobj == self || gIobj == self)) { "It's completely melted. Useless!"; exit; }
        inherited();
    }
    /* Use this to melt your object, making it useless. */
    melt() {
        /* We set everything to it's melted variant. */
        melted = true;
        brokenPrefix = '(melted) ';
        brokenVocab = '(melted)';
        brokenState = 'melted';
        /* After we set out variables, reset our vocab and name. */
        name = name.findReplace('(burnt) ', '', ReplaceOnce);
        cmdDict.removeWord(self, '(burnt)', &adjective);
        /* Finally, run our break function. */
        makeBroken(true);
        /* Set our desc AFTER the break function to effectively replace it. */
        setMethod(&desc, {: "It's completely melted, and as such you can't make out any detail."});
    }
;

/* 
 *   This is purely made for RunningScripts, but I guess you can hook into
 *   globalScript and do some stuff.
 */
globalScript : Thing
    /* 
     *   For each RunningScript, if it has a runEvery property, set it's new
     *   Daemon. If not, set it's Daemon to nil.
     */
    initializeThing() {
        forEachInstance(RunningScript, {obj: obj.daemonID = (obj.runEvery ? new Daemon(obj, obj.runProp, obj.runEvery) : nil)});
    }
;

/* 
 *   Wash & repeat! A RunningScript is a script that runs. Override it's run()
 *   property. It does NOT allow parameters passed into it. You CAN set
 *   'runEvery' to something other than nil to make it run every amount of
 *   turns. When running, you usually set it to 'nil' if you run it manually,
 *   because it is not being run by the daemon. Internally, this has no effect.
 *   But it might affect whatever code you write in there.
 */
class RunningScript : object
    /* 
     *   The run action that is run by the daemon. Put whatever you want in here.
     */
    run(isDaemon) { }
    /* Our internal run prop. Don't change these. */
    run_() { run(true); }
    runProp = &run_
    /* The interval in which the daemon runs at. */
    runEvery = 1
    daemonID = nil
    /* Restart the daemon if nessessary. */
    restartDaemon() {
        if(daemonID != nil)
            daemonID = new Daemon(self, runProp, runEvery);
    }
    /* End the daemon -- it's safe to end an ended Daemon. */
    endDaemon() {
        if(daemonID != nil)
            daemonID.removeEvent();
        daemonID = nil;
    }
    /* Shorthand for endDaemon()*/
    end() { endDaemon(); }
;

/* 
 *   An ActorScript is much like a RunningScript except it runs on a
 *   targetActor, so it's easier to run a Daemon on an actor.
 */
class ActorScript : RunningScript
    /* Our target actor to run on. */
    targetActor = nil
    run(actor, isDaemon) { }
    run_() { run(targetActor, true); }
;

/* ---------------------------------------------------------------------- */
// Common Code for Rooms

/* 
 *   isInitialized is a useful conditional statement used to determine whether
 *   something is initialized yet or not. It is set AFTER it is finished initializing.
 */
modify Thing
    isInitialized = nil
    initializeThing() {
        inherited();
        isInitialized = true;
    }
;

modify Room
    /* 
     *   The default east location. Just use east like you normally do --
     *   completely backwards compatible. Don't worry about breaking things at
     *   all. You can even change eastConnector without messing anything up.
     */
    east = nil
    /* 
     *   eastConnector is the connector in which your direction will
     *   point to. Usually we use this for our door, but you can set it to
     *   whatever you want. Be wary, if you set createDoors we won't
     *   automatically connect this for you.
     */
    eastConnector = nil
    /* 
     *   eastDirLoc stands for eastDirectionLocation. It basically
     *   states where your door will point to. By default, we assume you abide
     *   by the rules of physics and an east door lies to the west in it's
     *   adjacent room. If, however, you want to create some weird rooms that
     *   aren't exactly circular, set this to where your linked door will be, so
     *   a door won't be open on one side and closed on the other. (That would
     *   be REALLY trippy!)
     */
    eastDirLoc = 'west'
    
    /* 
     *   Of course, every thing I said up above applies to the other directions
     *   below.
     */
    
    west = nil
    westConnector = nil
    westDirLoc = 'east'
    
    north = nil
    northConnector = nil
    northDirLoc = 'south'
    
    south = nil
    southConnector = nil
    southDirLoc = 'north'
    
    /* 
     *   Our flag to let us know whether or not to create the doors. Setting
     *   eastConnector = nil won't work -- only using this can you
     *   disable auto-door creation.
     */
    createDoors = true
    
    /* 
     *   We need to create our doors BEFORE this room initializes it's position
     *   in space, and only if createDoors is true.
     */
    initializeThing() {
        /* Is our createDoors flag true? */
        if(createDoors == true) {
            /* 
             *   It is, so start by initialize our temporary door, one for each
             *   Room.
             */
            local testDoor = perInstance(new Door());
            /* 
             *   Only create a new door if we aren't already using a connector,
             *   and if we have a location to go to.
             */
            if(eastConnector == nil && east != nil) {
                /* 
                 *   We are using a connector and we have a location, so start
                 *   by seeing whether or not our location is initialized -- if
                 *   so, we must be the second in the chain, so set our
                 *   masterObject to our eastDirLoc. Note it doesn't matter in
                 *   which order it happens -- like Door objects are,
                 *   masterObject is arbitrary.
                 */
                if(east.isInitialized) { 
                    switch(eastDirLoc) {
                        case 'north': testDoor.masterObject = east.northConnector; break; 
                        case 'south': testDoor.masterObject = east.southConnector; break;
                        case 'west': testDoor.masterObject = east.westConnector; break;
                        case 'east': testDoor.masterObject = east.eastConnector; break;
                        default: testDoor.masterObject = east.southConnector;
                    }
                }
                /* Do some standard Door creation stuff. */
                testDoor.name = 'East Door';
                testDoor.initializeVocabWith('east door');
                testDoor.setMethod(&desc, {: "This door lies to the east. <.p>"});
                /* 
                 *   We move the test door into ourselves to make sure ... I'm
                 *   actually not sure why I have to do this. But I do, so...
                 */
                testDoor.moveInto(self);
                /* 
                 *   Finally, set our connector to our door we created and set
                 *   our location to our connector, getting rid of whatever room
                 *   you put in there.
                 */
                eastConnector = testDoor;
            }
            east = eastConnector;
            
            /* Do the same for every other direction. */
            if(westConnector == nil && west != nil) {
                if(west.isInitialized) { 
                    switch(westDirLoc) {
                        case 'north': testDoor.masterObject = west.northConnector; break; 
                        case 'south': testDoor.masterObject = west.southConnector; break;
                        case 'west': testDoor.masterObject = west.westConnector; break;
                        case 'east': testDoor.masterObject = west.eastConnector; break;
                        default: testDoor.masterObject = west.southConnector;
                    }
                }
                testDoor.name = 'West Door';
                testDoor.initializeVocabWith('west door');
                testDoor.setMethod(&desc, {: "This door lies to the west. <.p>"});
                testDoor.moveInto(self);
                westConnector = testDoor;
            }
            west = westConnector;
            
            if(northConnector == nil && north != nil) {
                if(north.isInitialized) { 
                    switch(northDirLoc) {
                        case 'north': testDoor.masterObject = north.northConnector; break; 
                        case 'south': testDoor.masterObject = north.southConnector; break;
                        case 'west': testDoor.masterObject = north.westConnector; break;
                        case 'east': testDoor.masterObject = north.eastConnector; break;
                        default: testDoor.masterObject = north.southConnector;
                    }
                }
                testDoor.name = 'North Door';
                testDoor.initializeVocabWith('north door');
                testDoor.setMethod(&desc, {: "This door lies to the north. <.p>"});
                testDoor.moveInto(self);
                northConnector = testDoor;
            }
            north = northConnector;
            
            if(southConnector == nil && south != nil) {
                if(south.isInitialized) { 
                    switch(southDirLoc) {
                        case 'north': testDoor.masterObject = south.northConnector; break; 
                        case 'south': testDoor.masterObject = south.southConnector; break;
                        case 'west': testDoor.masterObject = south.westConnector; break;
                        case 'east': testDoor.masterObject = south.eastConnector; break;
                        default: testDoor.masterObject = south.southConnector;
                    }
                }
                testDoor.name = 'South Door';
                testDoor.initializeVocabWith('south door');
                testDoor.setMethod(&desc, {: "This door lies to the south. <.p>"});
                testDoor.moveInto(self);
                southConnector = testDoor;
            }
            south = southConnector;
        }
        
        /* Now call our inherited biz */
        inherited();
    }
;
