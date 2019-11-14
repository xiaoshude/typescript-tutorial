### 语法增强

#### 声明

在 JS 中声明（变量声明/函数声明/类声明）只会创建一种实体：值。

TS 中声明可以创建三种实体：命名空间(namespace)，类型(type)或值(value)。

- 命名空间: Namespace-creating declarations create a namespace, which contains names that are accessed using a dotted notation.
- 类型: Type-creating declarations do just that: they create a type that is visible with the declared shape and bound to the given name.
- 值: value-creating declarations create values that are visible in the output JavaScript.

##### 为什么要区分不同实体

因为不同实体是不能互相运算的，应该放值的地方不能放类型。

##### 声明 -> 实体

一个声明有时会生成两个实体，下面是对应表：

Declaration Type | Namespace | Type | Value
---------|----------|---------|---------
 Namespace | X |  | X
 Class |  | X | X
 Enum |  | X | X
 Interface |  | X |
 Type Alias |  | X |
 Function |  |  | X
 Variable |  |  | X


 更详细的内容参考：[Declaration Merging](https://www.typescriptlang.org/docs/handbook/declaration-merging.html#basic-concepts)

#### 对类的增强

放在面向对象通用知识中一块说

#### readonly

- 可以用在 class限制属性不可修改
- 可以用在类型定义中，限制对象属性不可修改：

```ts
// 保持类型相同，但每个属性是只读的。
type Readonly<T> = {
    readonly [P in keyof T]: T[P];
};
```

readonly 可以类比为 const， 为变量使用 const，为属性使用 readonly

#### typeof

JS 通过 typeof 运算符得到值类型：

```js
typeof 1 // "number"
typeof {} //"object"

typeof (() => {}) // "function"
```

因为 JS 的弱类型，typeof 只能得到一个范围很大的类，无法得到确切的形状。比如：

```js
typeof {a: 1, b: 2} // "object"
```

得到的依然是 object。

令人兴奋的是，TS 增强了 typeof，可以得到确切的形状，比如：

```TS
type T = typeof {a: 1, b: 2}

// T 等价于

interface T {
    a: number,
    b: number
}
```

`T` 保存了对象的类型（完整形状）。

##### 应用

前面我们知道，enum 可以同时声明一个对象及类型。但这个类型并不是对象的类型。如果要获取对象的类型需要使用 `typeof`（有没有感觉似曾相识：class 也会声明同名类型，但是这个类型时实例的类型，如果要想获取类的类型，也是得使用 typeof className）。

```ts
enum LogLevel {
    ERROR, WARN
}

type T = typeof LogLevel

// 然后就可以愉快的

interface A extends T {
    INFO: number
}

let a: A = {
    ERROR: LogLevel.ERROR,
    WARN: LogLevel.WARN,
    INFO: 1
}
```

使用 interface extends 一个枚举对象的类型。
