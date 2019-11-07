## 实践

这部分汇总实际项目中可能遇到的问题。

### 循环引用

即使不使用 TS 这个问题也存在，但因为使用 TS，频繁交换 interface 让文件依赖更复杂，这个问题愈发凸显出来。

先对循环引用解释下：

```ts
// -- AbstractNode.js --
import { Leaf } from './Leaf'

export class AbstractNode {
  /* as is */ 
}

// -- Leaf.js --
import { AbstractNode } from './AbstractNode'

export class Leaf extends AbstractNode {
  /* as is */
}
```

这时候 `AbstractNode.js` 和 `Leaf.js` 就构成了循环依赖（类似于对象的成环，解决方案也类似）

文件的循环依赖并不一定导致问题，但上面的那个例子会有问题，因为执行 `class Leaf extends AbstractNode` 时 `AbstractNode` 并没有得到定义，如果延迟这行代码得执行，到 `AbstractNode` 定义之后就没问题。

可以这样理解：一开始 import 的时候只是给了一个`坑`，执行的时候会往这个坑里放东西，
放之前什么都拿不到，放之后就可以了。

其实解决循环引入的问题，根本是解决引入顺序（引入顺序决定执行顺序，决定填坑的顺序）。

[How to fix nasty circular dependency issues once and for all in JavaScript & TypeScript](https://medium.com/visual-development/how-to-fix-nasty-circular-dependency-issues-once-and-for-all-in-javascript-typescript-a04c987cf0de) 这篇文章介绍了一个办法，把这种引入顺序通过一个 internal 文件给明确出来。

具体应用可以看 [mobx/src/internal.ts](https://github.com/mobxjs/mobx/blob/master/src/internal.ts)
