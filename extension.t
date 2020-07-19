#charset "us-ascii"
#include <adv3.h>
#include <en_us.h>

class ComplexSurface : ComplexComponent, Surface
;
class ComplexUnderside : ComplexComponent, Underside
;
class ComplexRearContainer : ComplexComponent, RearContainer
;
class ComplexRearSurface : ComplexComponent, RearSurface
;
class ComplexInnerContainer : ComplexComponent, Container
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
;


