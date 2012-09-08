.. style::
   :font_size: 32
   :align: center
   :layout.valign: center

Useful Namespaces

.. style::
   :font_size: 12

::

Jack Diederich
jackdied@gmail.com
jackdied.blogspot.com

Namespaces
----

.. style::
   :font_size: 30

Namespaces are one honking great idea -- let's do more of those!

.. style::
   :font_size: 20

PEP 20:19  *The Zen of Python*

.. style::
    :font_size: 30

I like Namespaces - It's where I keep my stuff!

.. style::
    :font_size: 20

*The Tick* (paraphrased)

Types of Namespaces
----

.. style::
   :align: left
   :font_size: 30
   :background_color: white
   :literal.background_color: white
   :code_name_class.color: black
   :code_name_function.color: black
   :code_comment.color: blue

* Lexial Scope
* Modules/Packages
* Classes/Objects
* Working Set

Syntactic Sugar Matters
----

.. style::
   :layout.valign: top
   :font_size: 28

- **Function Decorators** 2.4

.. code::

  @functools.wraps
  def my_decorator(func):
    def new_func(): pass
    return new_func

- **Class Decorators** 2.6

.. code::

  @functools.total_ordering
  class MyClass():
    def __lt__(self, other):
       return self.value < other.value

- **Context Managers** 2.5

.. code::

  with Lock()
    pass

- **DecoratorManagers** 3.2

.. code::

  locker = magic(Lock)
  with locker():
    pass
 
  @locker
  def do_work(): pass

- **Monkey Patching** 3.? not yet standard

Fixup Decorators
----

.. code::

  def my_deco(func):
    print(func)
    def new_func():
      return func() + 7
    print(new_func)
    new_func.__doc__ = func.__doc__
    new_func.__name__ = func.__name__
    return new_func
    print(new_func)

  >>> @my_deco
  >>> def hello_ma(): pass
  ...
  <function hello_ma at 0xb744779c>
  <function new_func at 0xb7447ae4>
  <function hello_ma at 0xb7447ae4>

Fixup Decorator Decorator
----

.. code::

  def wraps(deco):
    def inner(func):
      new_func = deco(func)
      new_func.__doc__ = func.__doc__
      new_func.__name__ = func.__name__
      return new_func
    return inner

  from functools import wraps
  @wraps
  def my_deco(func):
    return func() + 7

Fixup Class Decorators
----

.. code::

  from functools import total_ordering
  @total_ordering
  class DoubleInt():
    def __init__(self, val):
      self.val = 2 * val
    def __lt__(self, other):
      return self.val < other.val

  >>> a = DoubleInt(0)
  >>> b = DoubleInt(99)
  >>> print(a < b)
  True
  >>> print(a > b)
  False

Fixup Class Decorators
----

.. code::

  def total_ordering(cls):
    cls.__ge__ = lamba a,b: not a < b
    cls.__eq__ = lamba a,b: (not a < b) and (not b < a)
    cls.__ne__ = lamba a,b: a < b or b < a
    cls.__le__ = lamba a,b: a < b or a == b
    cls.__gt__ = lamba a,b: (not a < b) and (not a == b)
    return cls

Cleaning Up After Yourself
----

.. code::

  >>> from tempfile import NamedTemporaryFile
  >>> with NamedTemporaryFile('w+') as tmp:
  ...  tmp.write('hello\n')
  ...  
  >>> tmp.write('world\n')
  ValueError: I/O operation on closed file
  >>> tmp.name
  /tmp/tmpax1I6Z

Cleaning Up After Yourself 2.3 Edition
----

* Before Context Managers

.. code::

  my_lock = Lock()
  my_lock.aquire()
  try:
    do_thing_A()
    do_thing_B()
    do_thing_C()
  finally:
    my_lock.release()

Cleaning Up After Yourself 2.3 Edition
----

.. code::

  def call_with_lock(func):
    my_lock = Lock()
    my_lock.acquire()
    try:
      return func()
    finally:
      my_lock.release()

  def do_work():
    do_thing_A()
    do_thing_B()
    do_thing_C()
  call_with_lock(do_work)


Cleaning Up After Yourself 2.4 Edition
----

.. code::

  def lock_decorator(func):
    def replacement_func():
      my_lock = Lock()
      my_lock.acquire()
      try:
        return func()
      finall:
        my_lock.release()
    return replacement_func

  @lock_decorator
  def do_work():
    pass

Cleaning Up After Yourself 2.6 Edition
----

.. code::

  with Lock():
    do_thing_A()
    do_thing_B()
    do_thing_C()

  class Locker():
    def __init__(self):
      self.lock = Lock()
    def __enter__(self):
      self.lock.acquire()
    def __exit__(self, \*traceback):
      self.lock_release()

  with Locker():
    do_work()

Monkey Patching Bad
----

  "while sometimes its use is justified those cases are few and far between." --*Ian Bicking*

.. code::

  def slow_original(msg):
    if isinstance(text, Message):
      return len(msg.raw_text)
    elif isinstance(msg, float):
      return len('%4.2f' % msg)
    else:
      return len(msg)

  def fast_str(msg):
    return len(msg)

  def fast_Message(msg):
    return len(msg.raw_text)

Monkey Patching Good
----

- Change the namespace *briefly*

.. code::

  @monkeypatch('parser.slow_original', fast_str)
  def make_message(text):
    logging.log(text)

  def make_message(text):
    with monkeypatch('parser.slow_original', fast_str):
      logging.log(text)

Steup, Cleanup
----

.. code::

  def identity_decorator(func):
    return func

  >>> @identity
  ... def hello(): print("hello")
  ... 
  >>> hello()
  hello

  class IdentityDecorator():
    def __init__(self, func):
      self.func = func
    def __call__(self, func):
      return self.func()
  identity_decorator = IdentityDecorator()

  >>> @IdentityDecorator
  >>> def world(): print("world")
  ...
  >>> world
  <__main__.IdentityDecorator instance at 0xb708eb8c>
  >>> world()
  "world"

Simple Context Managers
----

.. code::

  class MyManager():
    def __enter__(self):
      print("before scope")
    def __exit__(self, *traceback):
      print("after scope")

  >>> with MyManager():
  ...   print("in scope")
  ...
  before scope
  in scoe
  after scope  
  >>>

Really Simple Context Managers
----

.. code::

  class MyManager():
    def __enter__(self):
      print("before scope")
    def __exit__(self, *traceback):
      print("after scope")

.. code::

  @contextlib.contextmanager
  def my_manager():
    print("before scope")
    try:
      yield None # scoped block executes
    finally:
      print("after scope")

Side-by-Side
----

.. code::

  class Decorator():               class ContextManager():
    def __init__(self, func):        def __init__(self):
      self.func = func                 pass
 
    def __call__(self):
      # before call
      self.func()
      # after call

                                   def __enter__(self):
                                     # before scope

                                   def __exit__(self, *tb):
                                     # after scope

Decorators from Genators
----
  def context_to_decorator(context_class):
    def decorator(func):
      def replacement_func():
        with context_class():
          return func()
      return replacement_func
    return decorator

  >>> manager_decorator = context_to_decorator(MyManager)
  >>> @manager_decorator
  >>> def hello(): print("in function")
  before scope
  in function
  after scope
  >>>

Combined
----

.. code::

  class Both():       
    def __init__(self, gen):
      self.gen = gen
 
    def __call__(self, func):
      def decorator():
        with self:
          return func()
      return decorator

    def __enter__(self):
      # setup

    def __exit__(self):
      # cleanup

  def make_both(func_generator):
    gen = func_generator()
    return Both(gen)

Monkey Patching
----

(but don't use this, use mock.patch)

.. code::

  @contextmanager
  def monkey_patch(module, name, replacement):
    original = getattr(module, name)
    setattr(module, name, replacement)
    try:
      yield None
    finally:
      setattr(module, name, original)

Example: Logging Exceptions
----

.. code::

  with partyapi.log('bit.ly'):
      bitly.shorten_url('http://python.org')

  @contextlib.contextmanager
  def log(*args):
    msg = repr(args)
    try:
      yield None
      log.info('OK ' + msg)
    except Exception as e:
      log.info(repr(e) + msg)

Stateful
----
.. style::
   :align: left
   :font_size: 30

.. code::

  class ProcessState():
    def __init__(self, args):
      self.started = time.time()
      self.process = subprocess.Popen(args)
      self.save()

    def save(self):
      # store to database or pickle to disk  

  @contextlib.contextmanager
  def runner(self, *args):
    state = ProcessState(*args)
    try:
      yield state
    finally:
      state.save()  

Stateful
----

.. code::

  with runner("hello_world.sh") as job:
    too_old = job.started + 60
    while True:
      if too_old < time.time():
        job.process.kill()
        break 
      time.sleep(1)
    job.exit_status = job.process.exit_status
