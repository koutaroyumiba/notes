# Memory and Allocators

## Memory Spaces

In Zig, there are 3 types of memory (or 3 different memory spaces) that we care about. They are:
- Global data register (or the "global data section");
- Stack;
- Heap;

### Compile-time known vs runtime known

"compile-time known" refers to any object that you have in your Zig source code whose value can be identified at compile time.

Function arguments are a classic example of objects whose values are NOT known at compile time.

### Global Data Register

The global data register is a specific section of the executable of your Zig program, that is responsible for storing any value that is known at compile time.

Every constant object whose value is known at compile type that you declare in your source code is stored in the global data register. Also, every literal value that you write in your source code, such as the string `"this is a string"`, or the integer `10`, or a boolean value such as `true`, is also stored in the global data register.

### Stack

In essence, the stack memory is normally used to store values whose length is fixed and known at compile time. Classic stack frame stuff, some amount of space in the stack is reserved for each function call and every local object that you declare inside the function scope is usually stored in this same stack space.

One very important detail about the stack memory is that **it frees itself automatically**. When objects are stored in the stack memory, you don't have the work (or the responsibility) of freeing/destroying these objects. Because they will be automatically destroyed once the stack space is freed at the end of the function scope.

So, once the function call returns, the space that was reserved in the stack is destroyed, and all of the objects that were in that space goes away with it.

One important consequence is that, once the function returns, you can no longer access any memory address that was inside the space in the stack reserved for this particular function, because that space was destroyed. This means that, if this local object is stored in the stack, you cannot make a function that returns a pointer to this object.

### Heap

One important limitation of the stack, is that, only objects whose length/size is known at compile-time can be stored in it. The heap memory is a *dynamic* type of memory space, meaning that, it's used to store values whose length might grow during the execution (runtime) of your program.

Another key difference is that the heap is a type of memory that you have complete control over. This makes the heap a more flexible type of memory, but it also makes it harder to work with. To store an object in the heap, you need to explicitly tell Zig to do so, by using an allocator to allocate some space in the heap. Every memory you allocate in the heap must also be explicitly freed.

The majority of allocators in Zig do allocate memory on the heap. Some exceptions to this rule are `ArenaAllocator()` and `FixedBufferAllocator()`. The `ArenaAllocator` is a special type of allocator that works in conjunction with a second type of allocators (memory arenas). On the other side, `FixedBufferAllocator()` is an allocator that works based on buffer objects created on the stack. This means that the `FixedBufferAllocator()` makes allocations only on the stack.

## Stack Overflows

The stack is limited in size. The size varies from computer to computer but its usually not that big. This is why we normally use the stack to store only temporary and small objects in memory.

If you try to make an allocation on the stack that is so big that exceeds the stack limit, a stack overflow happens, and your program seg faults.

## Allocators

Allocators in Zig are objects that you can use to allocate memory for your program. Zig offers different types of allocators, and they are usually available through the `std.heap` module of the standard library. Furthermore, every allocator object is built on top of the `Allocator` interface in Zig. This means that, every allocator object you find in Zig must have the methods `alloc()`, `create()`, `free()` and `destroy()`.

### Different Types of Allocators

Currently, we have 6 different types of allocators:

- `DebugAllocator`
- `page_allocator`
- `FixedBufferAllocator` and `ThreadSafeFixedBufferAllocator`
- `ArenaAllocator`
- `c_allocator` (requires you to link to libc)

### General-Purpose Allocators

The `DebugAllocator` is a "general purpose" allocator. You can use it for every type of task. (Note: this was deprecated in Zig 0.17.0).

### Page Allocator

The `page_allocator` is an allocator that allocates full pages of memory in the heap. In other words, every time you allocate memory with `page_allocator`, a full page of memory in the heap is allocated, instead of just a small piece of it.

The size of this page depends on the system you are using. Most systems use a page size of 4KB in the heap, so that is amount of memory that is normally allocated in each call by `page_allocator`.

### Buffer Allocators

The `FixedBufferAllocator` and `ThreadSafeFixedBufferAllocator()` are allocator objects that work with a fixed sized buffer objects at the back. In other words, they use a fixed sized buffer object as the basis for the memory. This means that in order to use these allocators, you must first create a buffer object in your code, and then, give this buffer object as an input to these allocators.

### Arena Allocator

The `ArenaAllocator()` is an allocator object that takes a child allocator as input. It's an allocator object that allows you to allocate memory as many times as you want, but free all memory only once.

The allocations you perform with `alloc()` using an `ArenaAllocator` is actually made with the underlying allocator, so any new memory you ask for is allocated by the child allocator. The only thing that an arena allocator really does is help you free all the memory you allocated multiple times with just a single command.

### `alloc()` and `free()` methods

The method `alloc()` of the allocator object is used to allocate objects of defined size. It receives two inputs. The first one is a type that defines what type of values the allocated array will store. In the second argument, we define the size of the allocated array, by specifying how many elements this array will contain.

You **should always** explicitly free any memory that you allocate using an allocator. You do that by using the `free()` method of the same allocator object you used to allocate this memory.

### `create()` and `destroy()` methods

With the `alloc()` and `free()` methods, you can allocate memory to store multiple elements at once. In other words, with these methods, we always allocate an array to store multiple elements at once. In cases when you only need space to store a single item, you should use the `create()` method of the allocator object. Every allocator object offers the `create()` and `destroy()` methods, which are used to allocate and free memory for a single item, respectively.
