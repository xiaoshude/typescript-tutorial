## 高级特性及概念

### 为什么推荐优先使用 interface 定义类型

interface 可以重复定义同一类型，而且下面对上面起增量补充的作用。

尤其写库时，这个特性尤为必要，如果暴露的对象允许外面扩展，意味着类型也要允许外面扩展。当用 interface 定义类型时，很方便外面扩展。

具体的扩展写法参见：

- [Module Augmentation](https://www.typescriptlang.org/docs/handbook/declaration-merging.html#module-augmentation)
- [增强类型以配合插件使用](https://cn.vuejs.org/v2/guide/typescript.html#%E5%A2%9E%E5%BC%BA%E7%B1%BB%E5%9E%8B%E4%BB%A5%E9%85%8D%E5%90%88%E6%8F%92%E4%BB%B6%E4%BD%BF%E7%94%A8)

### 类型检验的诡异之处

上面说到，interface 用来约束对象时，它描述的是形状，被约束对象的所有属性必须不多不少的符合 interface。

然而这种不多不少的约束行为只发生在使用对象字面量赋值时：

```ts
interface Named {
    name: string;
}

let x: Named;

// 这样会报错：因为多了一个 location 属性
// Type '{ name: string; location: string; }' is not assignable to type 'Named'.
x = { name: 'Alice', location: 'Seattle' };
```

但是下面确实可以的，因为这个时候约束行为是：可多不可少。

```ts
interface Named {
    name: string;
}

let x: Named;
// y's inferred type is { name: string; location: string; }
let y = { name: 'Alice', location: 'Seattle' };
// 这时不报错，只要满足 interface 的属性要求，多没关系
x = y;
// 这时不报错，只要满足 interface 的属性要求，多没关系
x = {...y}
```

其他还有一些比如：不同形状的函数类型是否可以互相赋值、不同的枚举类型是否可以相互赋值，不用特别记，按报错提示行事即可。记住一个原则：这些看似的特例都是为了适应 JS 现有的行为。
系统了解参考：[类型兼容性](https://zhongsp.gitbooks.io/typescript-handbook/content/doc/handbook/Type%20Compatibility.html)

### 枚举

- 在对枚举对象的属性初始化值时，想普通对象那样，可以使用表达式：

```ts
enum FileAccess {
    // constant members
    None,
    Read    = 1 << 1,
    Write   = 1 << 2,
    // computed member
    G = "123".length
}
```

- 对 enum 进行修饰：
  - const： 限制枚举对象的属性初始化值时，不能使用表达式

### interface 和 type 的细微差别

详细的解释查看：[interfaces vs type](https://www.typescriptlang.org/docs/handbook/advanced-types.html#interfaces-vs-type-aliases)

### 更多的内置类型计算函数

详细的介绍查看：[内置类型计算函数](https://zhongsp.gitbooks.io/typescript-handbook/content/doc/handbook/Utility%20Types.html)

更多未提及可能在特定情景需要使用的功能：

- 如何书写声明文件
- TS 如何推断 this 的类型，及如何定义 this 类型

### infer 运算符

字面意思：推断

```ts
value infer Type
```

把从 value 推断出来的类型赋值给 Type，等价于：

```ts
type Type = typeof value
```

### 自定义类型守卫

is 逻辑运算符的一种使用场景。这个不细说了，当遇到相应需求时很容易查到。

[参考](https://jkchao.github.io/typescript-book-chinese/typings/typeGuard.html)
