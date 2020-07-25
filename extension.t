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
/* We don't mess with Containers as they define most things we need anyway. */
class ComplexInnerContainer : ComplexComponent, Container
;
class RestrictInnerContainer : ComplexComponent, RestrictedContainer
;

/* 
 *   This is not meant for authors to use in their code -- it's simply a
 *   convenience class I made for the context of this extension.
 */
class ComplexObj_ : ComplexContainer
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
class Table : ComplexObj_
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
 *   it's too high to put stuff on it.
 */
class Cabinet : ComplexObj_
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
class TallTable : ComplexObj_
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
class FloorCabinet : ComplexObj_
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
class GeneralBox : ComplexObj_
    /* This is standard */
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
 *   amount. A little niche, sure.
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
 *   Give everything a self_ tag just in case you want to loop over every
 *   object, and it may or may not be a transformer, using obj.self_ still
 *   works.
 */
modify VocabObject
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
     *   The reference object is an object that DOES NOT exist in the world, is
     *   moved into nil then replaces this object when transformed. 
     */
    referenceObj = nil
    /*   
     *   If the object is a Transformable, make sure to set this property, or else
     *   it might be flung into nil, never to be seen again. That can be useful
     *   if that's what you're going for anyway.
     */
//    baseLocation = location
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
    unThing = perInstance(new Unthing())
    isMe = (self.self_ == self)
;

//class Breakable : object
//    broken = nil
//    standardDesc = desc
//    brokenDesc = '<.p>It\'s broken.'
//    brokenPrefix = '(broken) '
//    makeBroken(state) {
//        local nowName = name;
//        broken = state;
//        if(state) {
//            name = brokenPrefix + nowName;
//            desc = "<<standardDesc()>><<brokenDesc()>>";
//            cmdDict.addWord(self, '(broken)', &adjective);
//            
//        } else {
//            name = nowName.findReplace('(broken)', '', ReplaceOnce);
//            desc = standardDesc;
//            cmdDict.removeWord(self, '(broken)', &adjective);
//        }
//    }
//;

//class TransformableThing : Transformable, Thing;
//
//class Breakable : Transformable
//    referenceObj = perInstance(new TransformableThing())
//    baseLocation_ = location
//    
//    broken = nil
//    brokenDesc = '<.p>It\'s broken.'
//    brokenPrefix = '(broken) '
//    initializeThing() {
//        referenceObj.desc = function() {
//            self.desc();
//            brokenDesc();
//        };
//        referenceObj.name = brokenPrefix + name;
//        referenceObj.initializeVocabWith(vocabWords);
//        referenceObj.referenceObj = self;
//        referenceObj.unThing = nil;
//        referenceObj.initializeThing();
//        inherited();
//        moveInto(baseLocation_);
//    }
//    makeBroken(state) {
//        broken = state;
//        if(state) {
//            if(isMe)
//                transform();
//        } else {
//            if(!isMe)
//                referenceObj.transform();
//        }
//    }
//;
//
/* 
 *   This is purely made for RunningScripts, but I guess you can hook into
 *   globalTurn and do some stuff.
 */
globalTurn : Thing
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
 *   turns. When running, you usually set 'nil' if you run it manually, because
 *   it is not being run by the daemon. Internally, this has no effect. But it
 *   might affect whatever code you write in there.
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
// Knowledge













