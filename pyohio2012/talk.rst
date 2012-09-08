.. include:: <s5defs.txt>

==========================================
Deleting Code Is Hard and You Should Do It
==========================================

  Jack Diederich PyOhio 2012

  Lead Engineer, Curata Inc
  @jackdied
  jackdied@gmail.com
  jackdied.blogspot.com

.. footer:: Jack Diederich - PyOhio 2012

Hating Code is Good
--------------------------------------------------


*"I hate code and I want as little of it as possible in our product"*

-me, always

Seen and Unseen
---------------

* External and Visible
* External and Invisible
* Internal and Invisible

Seen and Unseen
---------------

* External and Visible   (Customers)
* External and Invisible (Company)
* Internal and Invisible (Engineering)

Bad Reasons Not to Delete
---------------------------------

* NIH - Not Invented Here
* It might be used ... somewhere
* I might need it later

It might be used somewhere
------------------------------

* flake8, pep8, pyflakes, pylint
* grep, ack-grep
* coverage.py

  * webserver
  * cron jobs
  * backend backend
  * migrations

It is used ... in Unit Tests
----------------------------

* nose + coverage + unit tests
* false positives

  ::

    .bashrc

    alias agp ack-grep --python --ignore-dir=test

Dynamic Languages
-----------------

::

  grep -r "hello" *

  def hello(self, name): pass
  ob.hello('Alice')
  getattr(ob, "hello")('Bob')
  getattr(ob, "hel" +  "lo")('Steve')

Dynamic Languages
-----------------

* keep getattrs local to the module/class

::

  class Hello():
    def greet(self, name):
      print(getattr(self, name), name)

    john = 'Hello'
    jacques = 'Bonjour'
    jose = 'Hola'


Fewer False Positives
---------------------

* avoid being clever

  * metaclasses
  * getattr
  * magic

* delete relentlessly

  * avoid cycles
  * test your imports


Test Your Imports
-----------------

::

  find ./ -name '*.py' |\
  sed 's^\./\(.*\)\.py^\1^' |\
  sed 's^/^.^g' |\
  xargs -I fname python -c 'import fname'

I might need it later
---------------------

* You won't
* revision control

  * archive of content
  * archive of purpose

  ::

    git annotate|blame|praise file.py

* disk is cheap

  ::

    cp -a myrepo/ 2012/Q2

Build a Culture That Deletes
----------------------------

* Friday is "Trash Day"
* No Metrics (for individuals)

Source Lines of Code
--------------------

::

              Q1        Q2 
  Python      45%       60%
  Javascript  15%       30%
  HTML        10%       10%
  C           15%        0
  Java+XML    10%        0
  C++          5%        0


Write Less Code
---------------

* http://code.google.com/p/google-api-python-client/source/browse/
* 10,000 SLOC, 115 modules, 207 classes

* python-oauth2 (doesn't do oauth2!)
* 540 SLOC, 15 classes.

Rewrite to do oauth2 only.

* https://github.com/jackdied/python-foauth2
* 135 SLOC, 3 classes (2 too many!)

Conway's Game of Life
---------------------

::

  class Cell(object):
    def __init__(self, x, y, alive=True):
       self.x = x
       self.y = y
       self.alive = alive
       self.next = None

    def neighbors(self):
       yield (self.x + 1, self.y)
       yield (self.x + 1, self.y + 1)
       # ...
       yield (self.x + 1, self.y)

Conway's Game of Life
---------------------

::

  class Board(object):
    def __init__(self):
       self.cells = {} # { (x, y) : Cell() }

    def advance(self):
      for (x, y), cell in self.cells.items():
        if len(cell.neighbors) > 3:
          cell.next = False

Simpler Game of Life
--------------------

::

  def neighbors(point):
      x, y = point
      yield x + 1, y
      yield x - 1, y
      yield x, y + 1
      yield x, y - 1
      yield x + 1, y + 1
      yield x + 1, y - 1
      yield x - 1, y + 1
      yield x - 1, y - 1

Simpler Game of Life
--------------------

::

  def advance(board):
      newstate = set()
      recalc = board | set(itertools.chain(*map(neighbors, board)))
      for point in recalc:
          count = sum((neigh in board) for neigh in neighbors(point))
          if count == 3 or (count == 2 and point in board):
              newstate.add(point)
      return newstate

  glider = set([(0, 0), (1, 0), (2, 0), (0, 1), (1, 2)])
    for i in range(1000):
      glider = advance(glider)
  print glider
