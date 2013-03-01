# mode: run
# tag: freelist

cimport cython

@cython.freelist(8)
cdef class ExtTypeNoGC:
    """
    >>> obj = ExtTypeNoGC()
    >>> obj = ExtTypeNoGC()
    >>> obj = ExtTypeNoGC()
    >>> obj = ExtTypeNoGC()
    >>> obj = ExtTypeNoGC()
    >>> obj = ExtTypeNoGC()
    """


@cython.freelist(8)
cdef class ExtTypeWithGC:
    """
    >>> obj = ExtTypeWithGC()
    >>> obj = ExtTypeWithGC()
    >>> obj = ExtTypeWithGC()
    >>> obj = ExtTypeWithGC()
    >>> obj = ExtTypeWithGC()
    >>> obj = ExtTypeWithGC()
    """
    cdef attribute

    def __init__(self):
        self.attribute = object()


def tpnew_ExtTypeWithGC():
    """
    >>> obj = tpnew_ExtTypeWithGC()
    >>> obj = tpnew_ExtTypeWithGC()
    >>> obj = tpnew_ExtTypeWithGC()
    >>> obj = tpnew_ExtTypeWithGC()
    >>> obj = tpnew_ExtTypeWithGC()
    >>> obj = tpnew_ExtTypeWithGC()
    """
    return ExtTypeWithGC.__new__(ExtTypeWithGC)


cdef class ExtSubType(ExtTypeWithGC):
    """
    >>> obj = ExtSubType()
    >>> obj = ExtSubType()
    >>> obj = ExtSubType()
    >>> obj = ExtSubType()
    >>> obj = ExtSubType()
    >>> obj = ExtSubType()
    """


cdef class LargerExtSubType(ExtSubType):
    """
    >>> obj = LargerExtSubType()
    >>> obj = LargerExtSubType()
    >>> obj = LargerExtSubType()
    >>> obj = LargerExtSubType()
    >>> obj = LargerExtSubType()
    >>> obj = LargerExtSubType()
    """
    cdef attribute2

    def __cinit__(self):
        self.attribute2 = object()


@cython.freelist(8)
cdef class ExtTypeWithCAttr:
    """
    >>> obj = ExtTypeWithCAttr()
    >>> obj = ExtTypeWithCAttr()
    >>> obj = ExtTypeWithCAttr()
    >>> obj = ExtTypeWithCAttr()
    >>> obj = ExtTypeWithCAttr()
    >>> obj = ExtTypeWithCAttr()
    """
    cdef int cattr

    def __cinit__(self):
        assert self.cattr == 0
        self.cattr = 1


cdef class ExtSubTypeWithCAttr(ExtTypeWithCAttr):
    """
    >>> obj = ExtSubTypeWithCAttr()
    >>> obj = ExtSubTypeWithCAttr()
    >>> obj = ExtSubTypeWithCAttr()
    >>> obj = ExtSubTypeWithCAttr()
    >>> obj = ExtSubTypeWithCAttr()
    >>> obj = ExtSubTypeWithCAttr()
    """


cdef class ExtTypeWithCAttrNoFreelist:
    """
    For comparison with normal CPython instantiation.

    >>> obj = ExtTypeWithCAttrNoFreelist()
    >>> obj = ExtTypeWithCAttrNoFreelist()
    >>> obj = ExtTypeWithCAttrNoFreelist()
    >>> obj = ExtTypeWithCAttrNoFreelist()
    >>> obj = ExtTypeWithCAttrNoFreelist()
    >>> obj = ExtTypeWithCAttrNoFreelist()
    """
    cdef int cattr

    def __cinit__(self):
        assert self.cattr == 0
        self.cattr = 1


@cython.freelist(4)
cdef class ExtTypeWithCMethods:
    """
    >>> obj = ExtTypeWithCMethods()
    >>> test_cmethods(obj)
    (1, 2)
    >>> obj = ExtTypeWithCMethods()
    >>> test_cmethods(obj)
    (1, 2)
    >>> obj = ExtTypeWithCMethods()
    >>> test_cmethods(obj)
    (1, 2)
    >>> obj = ExtTypeWithCMethods()
    >>> test_cmethods(obj)
    (1, 2)
    >>> obj = ExtTypeWithCMethods()
    >>> test_cmethods(obj)
    (1, 2)
    >>> obj = ExtTypeWithCMethods()
    >>> test_cmethods(obj)
    (1, 2)
    """
    cdef int cattr

    def __cinit__(self):
        assert self.cattr == 0
        self.cattr = 1

    cdef int get_cattr(self):
        return self.cattr

    cdef set_cattr(self, int value):
        self.cattr = value


def test_cmethods(ExtTypeWithCMethods obj not None):
    x = obj.get_cattr()
    obj.set_cattr(2)
    return x, obj.get_cattr()


@cython.freelist(8)
cdef class ExtTypeWithRefCycle:
    """
    >>> obj = first = ExtTypeWithRefCycle()
    >>> obj.attribute is None
    True
    >>> obj = ExtTypeWithRefCycle(obj)
    >>> obj.attribute is first
    True
    >>> obj = ExtTypeWithRefCycle(obj)
    >>> obj = ExtTypeWithRefCycle(obj)
    >>> obj = ExtTypeWithRefCycle(obj)
    >>> obj = ExtTypeWithRefCycle(obj)
    >>> obj.attribute is not None
    True
    >>> first.attribute = obj
    >>> del obj, first
    """
    cdef public attribute

    def __init__(self, obj=None):
        self.attribute = obj