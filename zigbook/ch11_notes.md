# Data Structures

## Dynamic Arrays

Dynamic arrays are simply arrays that can grow in size during the runtime of your program. Most low level languages have some implementation of a dynamic array in their standard library (`std.ArrayList` in Zig).

The `std.ArrayList` struct provides a contiguous and growable array for you. It works with any other dynamic array, it allocates a contiguous block of memory, and when this block have no space left, `ArrayList` allocates another contiguous and bigger block of memory, copies the elements to this new location, and erases (or frees) the previous block of memory.

### Creating an `ArrayList` object

In order to use `ArrayList`, you must provide an allocator object to it. When you initialize an `ArrayList` object, you must provide the data type of the elements of the array. In other words, this defines the type of data that this array (or container) will store.

Using the `initCapacity()` is the preferred way to initialize your dynamic array. Because allocations, or, in other words, the process of expanding the capacity of the array, is always a high cost operation. You should take any possible opportunity to avoid reallocations in your array.

```zig
var gpa = std.heap.DebugAllocator(.{}){};
const allocator = gpa.allocator();

var buffer = try std.ArrayList(u8).initCapacity(allocator, 100);
defer buffer.deinit(allocator);
```

### Adding new elements to the array

You can append new values to this array by using the `append()` method. You can also use the `appendSlice()` method to append multiple values at once. You provide a slice to this method, and the method adds all values present in this slice to your dynamic array.

```zig
try buffer.append(allocator, 'H');
try buffer.append(allocator, 'e');
try buffer.append(allocator, 'l');
try buffer.append(allocator, 'l');
try buffer.append(allocator, 'o');
try buffer.appendSlice(allocator, " World!");
```

### Removing elements from the array

You can use the `pop()` method to "pop" or remove the last element in the array. It's worth nothing that this method do not change the capacity of the array. It just deletes or erases the last value stored in the array.

If you want to remove specific elements from specific positions of the array, you can use the `orderedRemove(index: usize)` method from your `ArrayList` object. One key characteristic about `orderedRemove()` is that it preserves the order of the values in the array. So, it deletes the value that you asked it to remove, but it also makes sure that the order of the values that remain in the array stay the same as before.

### Inserting elements at specific indexes

When you need to insert values in the middle of your array, instead of just appending them to the end of the array, you need to use the `insert()` and `insertSlice()` methods.

## Maps or Hash Tables

A hashtable is a data structure based on key-value pairs. You provide a key and a value to this structure, then, the hashtable will store the input value at a location that can be identified by the input key that you provided. It does that by using an underlying array and a hash function.

### Hashtables in Zig

The Zig Standard Library provides different implementations of a hashtable. Each implementation have its own pros and cons and all of them are available through the `std.hash_map` module.

We can create a hashtable easily by using the `AutoHashMap()` function which essentially creates a hashtable objet that uses the default settings. It automatically chooses a context object, and, therefore, a hash function implementation, for you. The function receives two data types as input, the first input is the data type of the keys that will be used in this hashtable, while the second input is the data type of the data that will be stored inside the hashtable, that is, the data type of the values to be stored.

You can add/put new values into the hashtable by using the `put()` method. The first argument is the key to be used, and the second argument is the actual value that you want to store inside the hashtable. We can also use the method `count()` to see how many values are currently stored in the hashtable. We can also use the `get()` method to access (or look) at the value stored where the `key` points to (it returns an optional). We can remove (or delete) values from the hashtable by using the `remove()` method. You provide the key that identifies the value that you want to delete, then, the method will delete this value and return a `true` value as output.

### Iterating through the hashtable

Iterating through the keys and values that are currently being stored in the hashtable is a very common necessity. You can do that in Zig by using an iterator object that can iterate through the elements of your hashtable object.

The iterator object works like any other iterator that you would find in languages such as cpp and rust. It's basically a pointer object that points to some value in the container, and has a `next()` method that you can use to navigate through the values in the container.

You can create such iterator object by using the `iterator()` method of the hashtable object. This method returns an iterator object, from which you can use the `next()` method in conjunction with a while loop to iterate through the elements of your hashtable. The `next()` method returns an optional `Entry` value, and therefore, you must unwrap this optional value to get the actual `Entry` value from which you can access the key and also the value identified by this key.

Key iterators are created from the `keyIterator()` method of your hashtable object, while value iterators are created from the `valueIterator()` method. All you have to do is unwrap the value from the `next()` method and dereference it directly to access the key or the value that you are iterating over.

```zig
var kit = hash_table.keyIterator();
while (kit.next()) |key| {
    std.debug.print("Key: {d}\n", .{key.*});
}
```

### The `ArrayHashMap` hashtable

If you need to iterate through the elements of your hashtable constantly, you might want to use the `ArrayHashMap` struct, instead of going with the usual and general purpose `HashMap` struct.

The `ArrayHashMap` struct creates a hashtable that is faster to iterate over. Some other properties of a `ArrayHashMap` hashtable are:

- the order of insertion is preserved, i.e., the order of the values that you find while iterating through this hashtable is actually the order in which these values were inserted in the hashtable.
- the key-value pairs are stored sequentially, one after another

### The `StringHashMap` hashtable

Neither of the two types of hashtables that are covered above accepts a slice data type in their keys. This means that you cannot use a slice value to represent a key in these types of hashtables (but the pattern of using strings as keys is super common).

So, the Zig Standard Library offers a specific type of hashtable for this purpose, which is created through the `StringHashMap()` function. This function creates a hashtable that uses strings as keys. The only input of this function creates a hashtable that uses strings as keys; hence the only input of this function is the data type of the values that will be stored into this hashtable.

Note: there's also an `StringArrayHashMap` :D

## Linked Lists

The Zig Standard Library provides an implementation for both singly and doubly linked lists. More specifically, through the structs `SinglyLinkedList` and `DoublyLinkedList`.

### How to use a singly linked list

```zig
const std = @import("std");
const NodeU32 = struct {
    data: u32,
    node: std.SinglyLinkedList.Node = .{},
};

// then we define the list
var list: std.SinglyLinkedList = .{};
// and the nodes
var one: NodeU32 = .{ .data = 1 };
var two: NodeU32 = .{ .data = 2 };
var three: NodeU32 = .{ .data = 3 };
var five: NodeU32 = .{ .data = 5 };
```

You can use the `prepend()` method from the linked list object to insert the first node in the list, which is the "head" of the linked list. After we added the "head node" of the list, we can start to add the "next nodes" in the list by using the `insertAfter()` method from the `SinglyLinkedList.Node` type.

```zig
list.prepend(&two.node);            // {2}
two.node.insertAfter(&five.node);   // {2, 5}
two.node.insertAfter(&three.node);  // {2, 3, 5}

list.prepend(&one.node);            // {1, 2, 3, 5}
```

There are other methods available from the singly linked list object:

- `remove()` to remove a specific node from the linked list
- `len()` to count how many nodes there is in the linked list
- `popFirst()` to remove the first node from the linked list

### How to use a doubly linked list

If you want to use a doubly linked list instead, you will face a similar workflow compared to the singly linked list:

1. You first create a "custom node type" that can store the specific data type that you want
2. Create an empty doubly linked list object
3. Create the nodes of linked list
4. Start to insert the nodes inside the list

### Iterating through the linked list

If you want to iterate over the elements of the linked list, all you need to do is to follow the trail created by the "pointer to next node". We can use the `@fieldParentPtr()` build-in function to get access to a pointer that points to the parent instance of the `node` object.

```zig
var it = list.first;
while (it) |node| : (it = node.next) {
    const l: *NodeU32 = @fieldParentPtr("node", node);
    try stdout.print("Current value: {}", .{l.data});
}
```

## Multi Array Structure

Zig introduces a new data structure called `MultiArrayList()`. This one's super cool (struct of arrays). You can easily access each of the arrays separately, and iterate over the values of each array. For that, you will need to call the `items()` method from the object, and provide as input to this method, the name of the field that you want to iterate over.

```zig
for (people.items(.age)) |*age| {
    try stdout.print("Age: {d}\n", .{age.*});
}
```

However, in most situations, it's recommended to call this `items()` method from a "slice object", which you can create from the `slice()` method. The reason for this is that calling `items()` multipel times have better performance if you use a slice object.

```zig
var slice = people.slice();

for (slice.items(.age)) |*age| {
    age.* += 10;
}
```
