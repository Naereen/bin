#! /usr/bin/env python3
# -*- coding: utf8 -*-
"""
Hand written implementation of a very naive hash table data structure.

About:
- *Date:* 23/09/2017.
- *Author:* Lilian Besson, (C) 2017
- *Licence:* MIT Licence (http://lbesson.mit-license.org).
- *Web*: https://bitbucket.org/lbesson/bin/
"""


def small_hash(x, nb_bits=3):
    return abs(hash(x)) % (1 << nb_bits)


NB_BITS = 4
DEFAULT_SIZE = 1 << NB_BITS


class hashtable(object):
    """Manual implementation of a naive hash table.

    - Can only store hashable values.
    - Uses a non cryptographic hash function.
    - Very not resistant to collision!
    """

    def __init__(self, map_values=None, nb_bits=NB_BITS):
        self._nb_bits = nb_bits
        self._size = 1 << nb_bits
        self._nb = 0
        self._array = [None] * self._size
        # Naive way of inserting
        if map_values is not None:
            for key, value in map_values:
                self.insert(key, value)

    # convenient methods

    def __len__(self):
        return self._nb

    def __str__(self):
        return "{" + ", ".join(["{}: {}".format(kv[0], kv[1]) for kv in self]) + "}"

    __repr__ = __str__

    def insert(self, key, value):
        """Insert a new (key, value) pair in the hash table."""
        self._nb += 1
        h = small_hash(key, nb_bits=self._nb_bits)
        # FIXME implement chained hashing!
        if self._array[h] is not None:
            raise IndexError
        if self._nb >= self._size:
            self._double_size()
        self._array[h] = (key, value)

    # internal double method

    def _double_size(self):
        """If needed, double the size of the hash table."""
        self._array += [None] * self._size
        self._nb_bits += 1
        self._size *= 2
        print("Doubling the size of the hash table...\nUsing now {} bits for the addressing, and able to store up to {} values. Currently {} are used.".format(self._nb_bits, self._size, self._nb))  # DEBUG

    # read, write, delete methods

    def read(self, key):
        """Read the value stored with this key."""
        h = small_hash(key, nb_bits=self._nb_bits)
        v = self._array[h]
        if v is None:
            raise IndexError
        else:
            return v[1]

    def delete(self, key):
        """Delete the value stored with this key."""
        h = small_hash(key, nb_bits=self._nb_bits)
        if self._array[h] is None:
            raise IndexError
        else:
            self._nb -= 1
            self._array[h] = None

    def write(self, key, value):
        """Set the value stored with this key."""
        h = small_hash(key, nb_bits=self._nb_bits)
        if self._array[h] is None:
            raise IndexError
        else:
            self._array[h] = (key, value)

    # dictionary like methods

    def keys(self):
        """Return iterator of keys."""
        return (kv[0] for kv in self)

    def items(self):
        """Return iterator of items."""
        return (kv[1] for kv in self)

    # Methods to make it an iterator

    def iter(self):
        return (kv for kv in self._array if kv is not None)

    def __getitem__(self, index):
        """Return the index-th value stored in the hash table. Order is random!"""
        n, nb = -1, -1
        if index >= self._nb:
            raise IndexError
        while nb < index:
            i = n + 1
            while i < self._size and self._array[i] is None:
                i += 1
            if i >= self._size:
                raise IndexError
            elif self._array[i] is not None:
                nb += 1
                n = i
        return self._array[n]


# --- Testing

def test():
    print("Creating empty hash table ...")
    H = hashtable()
    print(H)
    print("Inserting i**2 for i = 0..9 ...")
    for i in range(10):
        H.insert(i, i**2)
    print(H)
    print("Reading i**2 for i = 0..9 ...")
    for i in range(10):
        print(i, H.read(i))
    print("Writing in place i**3 ...")
    for i in range(10):
        H.write(i, i**3)
    print(H)
    print("Deleting even values ...")
    for i in range(0, 10, 2):
        H.delete(i)
    print(H)
    print("len(H) =", len(H))
    print("Trying to __getitem__:")
    for k in range(len(H)):
        print("H.__getitem__({}) = {}".format(k, H.__getitem__(k)))

if __name__ == '__main__':
    test()
