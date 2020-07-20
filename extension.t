#charset "us-ascii"
#include <adv3.h>
#include <en_us.h>

class ComplexSurface : ComplexComponent, Surface
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
    iobjFor(PutBehind) {
        verify() { 
            if(targetObj.allowBehind(gDobj)) {
                logical; }
            else { 
                illogical(targetObj.failBehindMsg); }
        }
    }
;
class ComplexInnerContainer : ComplexComponent, Container
;
class RestrictInnerContainer : ComplexComponent, RestrictedContainer
;


/*
 *   A basic Table, where you can put stuff on and under, and by default it's
 *   umoveable.
 */
class Table : ComplexContainer, Heavy
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
    
    allowBehind(obj) { return true; }
    allowOn(obj) { return true; }
    allowUnder(obj) { return true; }
;


/* 
 *   A Cabinet is an object where you can put stuff under, behind, or in, but
 *   it's too high to put stuff on it.
 */
class Cabinet : ComplexContainer, Heavy
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
    
    allowBehind(obj) { return true; }
    allowOn(obj) { return true; }
    allowUnder(obj) { return true; }
;

/* 
 *   A TallTable refers to an object where it's too tall (or inaccessible) to
 *   put things on top, but you can place things below or behind.
 */
class TallTable : ComplexContainer, Heavy
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
    
    allowBehind(obj) { return true; }
    allowOn(obj) { return true; }
    allowUnder(obj) { return true; }
;

/* 
 *   FloorCabinet - An object that allows things in, on, or behind, but not
 *   under.
 */
class FloorCabinet : ComplexContainer, Heavy
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
    
    allowBehind(obj) { return true; }
    allowOn(obj) { return true; }
    allowUnder(obj) { return true; }
;


class GeneralBox : ComplexContainer, Heavy
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
