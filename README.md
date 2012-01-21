"libros non legendos sed lectitandos", Plin. Ep. 2, 17, 8:
        Books must not be read but read eagerly.

1) an edition has title/author/publisher, and a editions_works
joins table to link to ther editions of the same work.  and 
a find_by_isbn

2) a book references an edition

3) we dispense with all the complex 'find or create an edition'
model logic.  If the user fills in isbn only when adding a book,
we look up the edition or barf.  If e fills in the whole thing, 
we create an edition

4) if we don't have an edition locally, we do the google books or
whatever search and cache results

5) the model objects have allowed_actions, which accepts a user object
and some other stuff.  Actions may coincidentally have the same name
as controller actions but are not necessarily the same, which suggests
to us that 'action' is maybe the wrong name.  (The command pattern
might be relevant here, but seems a bit overkill when the whole
actioncontroller thing is basically a command pattern itself)

6) edition.blurb is being dropped: publisher blurb is a special case
of review, so we will do this as a review instead

