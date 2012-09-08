.. include:: <s5defs.txt>

====================
Stop Writing Classes
====================

  Jack Diederich PyCon 2012

  jackdied@gmail.com

  jackdied.blogspot.com

.. footer:: Jack Diederich - PyCon 2012

Prefer Easy Things
--------------------------------------------------

Zen of Python
=============

* Simple is better than complex.
* Flat is better than nested.
* Readability counts.
* If the implementation is hard to explain, it's a bad idea.
* If the implementation is easy to explain, it may be a good idea.

Prefer Easy Things
------------------

* Don't do hard things in the first place
* Revert complications later

*"I hate code and I want as little of it as possible in our product"*

-me, always

Obfuscated Function Call
------------------------

::

  class Greeting(object):
      def __init__(self, greeting='hello'):
        self.greeting = greeting

      def greet(self, name):
        return '%s! %s' % (self.greeting, name)

  greeting = Greeting('hola')
  print greeting.greet('bob')

De-obfuscated Function Call
---------------------------

::

  def greet(name):
    ob = Greeting('hola')
    ob.greet('bob')
    return

De-obfuscated Function Call
---------------------------

::

  def greet(name):
    ob = Greeting('hola')
    print ob.greet('bob')
    return

::

  def greet(greeting, target):
      return '%s! %s' % (greeting, target)

De-obfuscated Function Call
---------------------------

::

  def greet(name):
    ob = Greeting('hola')
    print ob.greet('bob')
    return

::

  def greet(greeting, target):
      return '%s! %s' % (greeting, target)

::

  import functools
  greet = functools.partial(greet, 'hola')
  greet('bob')

Classes give us lovely things
-----------------------------

* Separation of concerns!
* Decoupling!
* Encapsulation!
* Implementation Hiding!

(in theory)

Evolution of an API: Stage 1
----------------------------

* 1 Package, 22 Modules
* 20 Classes
* 660 Source Lines of Code

MuffinHash.py is a module containing two lines.

Evolution of an API: Stage 1
----------------------------

* 1 Package, 22 Modules
* 20 Classes
* 660 Source Lines of Code

MuffinHash.py is a module containing two lines.

::

  class MuffinHash(dict):
    pass

Evolution of an API: Stage 1
----------------------------

::

  d = MuffinMail.MuffinHash.MuffinHash(foo=3)

  d = dict(foo=3)

  d = {'foo' : 3}

Evolution of an API: Stage 2
----------------------------

::

  class API:
      url = 'https://api.wbsrvc.com/'

      def __init__(self, key):
          self.header = dict(apikey=key)

      def call(self, method, params):
          request = urllib2.Request(
              self.url + method[0] + '/' + method[1],
              urllib.urlencode(params),
              self.header
          )
          try:
              response = json.loads(urllib2.urlopen(request).read())
              return response
          except urllib2.HTTPError as error:
              return dict(Error=str(error))

Evolution of an API
-------------------

::

  MuffinAPI.API(key='SECRET_API_KEY').call(('Mailing', 'stats'), {id:1})

Can be aliased like this

::

  MuffinAPI.request = API(key='SECRET_API_KEY').call

and used like the function it should have been

::

  MuffinAPI.request(('Mailling', 'stats'), {id:1})

Evolution of an API
-------------------

::

  MUFFIN_API = url='https://api.wbsrvc.com/%s/%s/'
  MUFFIN_API_KEY = 'SECRET-API-KEY'

  def request(noun, verb, **params):
      headers = {'apikey' : MUFFIN_API_KEY}
      request = urllib2.Request(MUFFIN_API % (noun, verb),
                                urllib.urlencode(params), headers)
      return json.loads(urllib2.urlopen(request).read())

Evolution of an API
-------------------

* 1 Package + 20 Modules => 1 Module
* 20 Classes => 1 Class => 0 Classes
* 130 methods => 2 methods => 1 function
* 660 SLOC => 15 SLOC => 5 SLOC
* Easier to use!

Namespaces are there to help
----------------------------

* Namespaces are for preventing name collisions
* not for creating taxonomies

Namespaces are there to help
----------------------------

* Namespaces are for preventing name collisions
* not for creating taxonomies

::

  services.crawler.crawlerexceptions.ArticleNotFoundException

* requires typing 'crawler' and 'exception' twice each!
* EmptyBeer or BeerError or BeerNotFound
* but not EmptyBeerNotFoundError
* but why not LookupError?

::

  try:
    get_article()
    raise LookupError() # this raises an exception
  except ArticleNotFound: # this catches an exception
    pass

Python Standard Library
-----------------------

* 200k SLOC
* 200 top level modules
* averages 10 files per package
* defines 165 Exceptions

Sometimes you do want a class
-----------------------------

* Containers are a great use case for classes
* heapq is a stdlib container without a class

Sometimes you do want a class
-----------------------------

* Containers are a great use case for classes
* heapq is a stdlib container without a class

::

  def heapify(data): pass
  def pushleft(data, item): pass
  def popleft(data): pass
  def pushright(data, item): pass
  def popright(data): pass
  # etc

heapq
-----

::

  class Heap(object):
      def __init__(self, data=None, key=lambda x:None):
          self.heap = data or []
          heapq.heapify(self.heap)
          self.key = key

      def pushleft(self, item):
          if self.key:
              item = (self.key(item), item)
          heapq.pushleft(self.heap, item)

      def popleft(self):
          return heapq.popleft(self.heap)[1]

Classes Encourage Atrocities
----------------------------

* Oauth2 implementation

* http://code.google.com/p/google-api-python-client/source/browse/
* 10,000 SLOC, 115 modules, 207 classes
* *"I decline any responsibility for Google API client code."* -- Guido Van Rossum

::

  class Flow(object):
      """Base class for all Flow objects."""
      pass

  class Storage(object):
      def put(self, data): _abstract()
      def get(self): _abstract()

  def _abstract(): raise NotImplementedError

Classes Encourage Atrocities
----------------------------

* python-oauth2 doesn't do oauth2!
* 540 SLOC, 15 classes.

Rewrite to do oauth2 only.

* https://github.com/jackdied/python-foauth2
* 135 SLOC, 3 classes (2 too many!)

Conway's Game of Life
---------------------

Pulsar

.. image:pulsar.gif

Glider

.. image:glider.gif

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

  class Board(object):
    def __init__(self):
       self.cells = {} # { (x, y) : Cell() }

    def advance(self):
      for (x, y), cell in self.cells.items():
        if len(cell.neighbors) > 3:
          cell.next = False

Conway's Really Simple Game of Life
-----------------------------------

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

