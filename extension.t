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
 *   A basic Table, where you can put stuff on and under, and by default it's
 *   umoveable.
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

class RestrictedBox : GeneralBox
    subContainer = perInstance(new RestrictInnerContainer())
    contentsListed = nil
;

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

// Hopefully won't break everything
modify Thing
    self_ = self
;


class Transformer : Thing
    self_ = self
    referenceObj = nil
    initializeThing() {
        referenceObj.moveInto(nil);
        referenceObj.targetObj = self;
        if(unThing != nil) {
            unThing.notHereMsg = '<<referenceObj.theName>> used to be that.';
            unThing.name = name;
            unThing.location = nil;
        }
        inherited();
    }
    transform() {
        referenceObj.moveInto(location);
        if(unThing != nil) {
            unThing.initializeVocabWith(vocabWords);
            unThing.moveInto(location);
        }
        moveInto(nil);
        self_ = referenceObj;
    }
    unThing = perInstance(new Unthing())
;

class RunningScript : object
    run() { }
    runEvery = 1
    daemonID = nil
    beforeAction() {
        if(daemonID == nil)
            daemonID = perInstance(new Daemon(self, &run, runEvery));
    }
    endDaemon() {
        if(daemonID != nil)
            daemonID.removeEvent();
        daemonID = nil;
    }
;


/* ---------------------------------------------------------------------- */
// Knowledge














