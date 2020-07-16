Plans for 
               Basic Lib - The simpler, but more powerful TADS.

Minus Signs --

'-' signs -- We should be able to use em'! Get rid of the 'Attachable' Class, 
and replace it with this! The minus signs signify 'attachment', which is 
different then containment.

Containment                          v|s.                          Attachment
--------------------------------------|--------------------------------------
* Location property defined as parent |* Location property is same as it's 
* Uses commands 'put in' & 'take out' |     attached object
* Only works for Containers and such  |* Uses commands like 'attach to' and 
* Containment is limited by           |     'detach from'
     bulkCapacity and maxSingleBulk   |* Works for any object with 
*                                     |     'allowAttachment' enabled
*                                     |* Attachment is limited by surfaceRoom
*                                     |                         & surfaceBulk
*                                     |* ^ larger objs cannot be attached to 
*                                     |      smaller objs

For example:

metalbox : Openable, Container 'metal box' 'metal box'
    "Metal! Box! Metal box!"
;

- redButton : Button 'red button' 'button'
    "It's red, and round."
;

+ circuits : Fixture 'circuits' 'mess of circuits'
    "They're all multi-colored...it kinda hurts your eyes."
;


An example of this can be found in the following dialog:

> X METAL BOX
Metal! Box! Metal box!
Attached to it is a button.
It's closed.

> OPEN IT
Opened.

> X BOX
Metal! Box! Metal box!
Attached to it is a button.
Inside is a mess of circuits.

> TAKE BOX
Taken.

(...move somewhere else...)

> DROP BOX
Dropped.

> X BOX
Metal! Box! Metal box!
Attached to it is a button.
Inside is a mess of circuits.

> ZARVO BOX
The metal box is in the location called 'Room'

> ZARVO BUTTON
The button is in the location called 'Room'

> TAKE BUTTON
You can't take that -- it's attached to the metal box!

> DETATCH BUTTON
Detached.

> TAKE BUTTON
Taken.

See? Simply makes it easier!


Common Classes:

There are many common objects that are unique in the world - why aren't they in adv3?
Such as a table - you should be able to put stuff on and under it, but then you need 
to make an entire Complex Container -- why? Why isn't there a Table class that does this?
Well there is now!

* Table - Can put stuff on and under; by default it's umoveable.
* Sofa - Variant of Chair, specifies an 'actorBulk' property that defines how many actors 
         can sit on it.
* Dresser - Contains an amount of drawers, which are (optionally) detachable containers 
            themselves. Also a surface, and something you can put stuff under and behind.
* Cabinet - Ideally something you can put stuff under, behind, or in, but it's too high to
            put stuff on it.
* TallTable - Refers to an object where it's too tall (or inaccessible) to put things on top,
              but you can place things below or behind.
* FloorCabinet - An object that allows things in, on, or behind, but not under.
* GeneralBox - An object that you can place things in, on, behind, and under. 
               I reccomend using one of the mix-in classes below.
* RestrictedBox - A Box but using RestrictedContainer.
* (mix-in) Thin - Disallows putting things behind either completely or conditionally. 
                  (Without attachment)
* (mix-in) Tall - Disallows putting things on top either completely or conditionally.
* (mix-in) Low - Disallows putting things below either completely or conditionally.
* (mix-in) Burnable - Something that can be burned by fire, either turning into char, or
                      simply being shown as burned, or being too hot to handle. 
     - 'meltable = true' this is set to nil by default, but if enabled the object will
                         melt instead of burn, changing descriptions a little bit and
                         rendering the object completely useless. Careful with this!
* (mix-in) Freezeable - Something that can be frozen (and thus made un-useable)
                        and thawed, presumably.



Note for all of these in which you can put stuff behind, if they are attached to something and 
their 'attachmentSide' property is defined as 'back', you cannot put things behind it.
Also defining 'attachedTo' to 'room.eastWall' can let you attach things to the wall.

Some other classes:

Script - Run all the things!
Set it's 'run()' method, and run it somewhere else to run the Script. There's not much more than that.
Note: You can include parameters to pass into it.

RunningScript - Wash & repeat!
Very similar to a list, but it does NOT allow parameters passed into it. You CAN set 'runEvery' 
to something other than nil to make it run every amount of turns.

ActorScript - For those alive things!
Same as a Script, but it's for actors. Try run(actor), instead.
Well, you can use 'linkActor' to link an Actor to this, and 'runEvery' to run the script, as well.



Materials:
So in adv3, we have SenseConnectors which have a 'material', which defines what senses can be sensed 
through. This works well, but the lack of partial senses and materials availble for Things is shown 
in some cases. So, it's fixed! Material is a modified class in which you can specify a material,
which has a couple properties:
'senseThrough' - the list of senses this material lets through. Ex.: [sight, partialSmell]
'soundHardness' - the extra 'oomph' it gives a sound. Values of 1 mean that the sound is the same as 
                  usual, and values less than 1 mean this object is soft and absorbs sound, while
                  values larger than 1 mean this object is hard and amplifies sounds.

'Partial' senses are senses that are partial - like Occluders in their own right. 
I only assume that smell and sound are senses that can be partial. Partial sight, i.e. a half-drawn 
curtain, is not pratical, or useful enough (or even possible, really!) for me to invest the time and
effort, as IF does not contain a graphical representation of th world -- it's just text.

Partial Smell is when smell might get dampened. desc/hereWithSource is defined as when you 
can both smell and see it -- otherwise, desc/hereWithoutSource is used. A partial smell SenseConnector
allows you to be able to see the source while still only seeing the desc/hereWithoutSource.

Partial Sound could be defined as sound - at a distance. Much similar to Partial Smell.


Common properties - Rooms:

Every room, assumably has a door/passage. If not, it has a sense-connector. 
(realistically it doesn't have to - but then why would you define seperate rooms?)
Then, why do we have to make TWO objects for EVERY single connection between rooms? 
It just sounds like a lot of uneeded work. So, let's do all that work in a class so 
you don't have to.

So, we have a 'eastDoor : Door' or 'eastPassage : Passage' with every direction
of course, and if you don't want to define these, you can use
    eastDoorDesc = "..."
as well as 
    initialize() {
        eastDoor.specialDesc = "";
        eastDoor.travelMessage = "";
    }

if you want.


Common properties - Objects:


Nothing:

Unthing? Really? Should be Nothing. In fact, there's different contexts of nothing. In fact,
there's a slight 'memory' in things the player should have. IN FACT, they should directly
recall the previous room's state. And in fact, they do.

Removal of 'Unthing', but purpose and execution is moved to Nothing class, an ENTIRELY new 
class not based upon 'Thing', as it is NOT a Thing, the very opposite of Thing.

Of Nothing:

Nothing
    Abscence
    Presence
    Knowledge
        Ignorance
    Memory

Nothing - This class is the base class for all.
All verbs with these objects are in 'where was' such as 'where was the golden banana'
or 'recall golden banana' as such they are meant for dobjFor(WhereWas) and dobjFor(Recall).


Abscence - Same funtionality as Unthing
An Abscence is where an object ONCE was, as in if something dissapears, you can leave an
Abscence in it's place, to let the player know it was there.

Prescence - Just as useful; it's an Un-unthing
A Prescence is where an object WILL be, same as Abscence, just opposite. A use for this is
if you, for example, had a port, and a ship would be coming in a few turns, you can use 
this class to let the player examine where to ship would be without returning "'ship' isn't 
used in this context" or whatever.

Knowledge - The brain, that's what!
Mainly to be used for Actors, a Knowledge represents what someone knows in a more fluid way 
than a bunch of hard-to-track variables.

Ignorance - This is Knowledge at it's worst.
This is for Actors, as well, but it's to 'unlearn' things, or represent initially not knowing something.
Not inheritly useful, but good for some edge cases.

Memory - This is like Knowledge, but for YOU!
This is Knowledge, but adapted for the player. Note Memory handles both knowing and unlearning things, 
so keep that in mind.


New classes:

Transformer - A useful object changer
A Transformer is a mix-in class that allows an object to be transformed - that is, CHANGED into 
another type of object. It remains the same object, just changed. It can, however, use a reference
object to transform into.

Breakable - Another useful object changer
A Breakable (mix-in) is an object that can be broken. Much like Transformer, it extends from that. But, it differs
in that you never specify a seperate object - it just displays as 'broken'. For example, a glass jar 
will turn into a (broken) glass jar when (whatever).makeBroken(true) is called. Note this means an object
can be 'unbroken', i.e. by using tape or whatever you program into there.

RestrictedAttachment - Refridgerator magnets!
Another mix-in, and this makes it so you can restrict what kinds of objects can be attached on here.
Note this automatically sets allowAttachment to true, predictably.



