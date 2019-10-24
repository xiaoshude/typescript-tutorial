### 类型系统

有段时间在推进项目的测试，忽然意识到：如果测试都写了，为什么不加入类型呢？
从提高代码质量减少 bug 的角度看：类型断言应该是最有效且比写测试更容易的办法。
并且可以获得额外的收益：开发体验的提升 —— 更智能的编辑器代码提示。

这是我决定引入类型的初衷。

#### 什么是类型

类型（type），这个词并不陌生，比如：
- 基数数据类型
- typeof 操作符等。

这时说类型时实际在描述关系或者说来源，可以把类型和类等价，类用来定义新类型。这也是大多数静态语言中类型的含义。

TS 中不是这样。要把类型理解为形状（shape），只要符合这个形状就是这个类型。白猫黑猫抓着老鼠就是好猫，而不是说好猫生的就是好猫。

明确了类型就是形状，接下来还要看一个概念：接口（Interfaces）。

一般对接口的印象可能这样：接口就像最低要求（约束），我只要满足了这个要求（至于有没有超额完成不管），就说实现了接口。

但在 TS, 接口不仅这个含义：
- 当接口用来约束类时，就是这样意思，只要类包含接口要求的属性方法就行
- 接口还可以用来约束对象，约束对象时，就和上面的类型一个意思，用来表示形状

有了上面的准备，下面进入正题。

#### 哪些类型可以直接用（内置类型）

##### JavaScript 的内置类型

- 原始数据类型：`Boolean Null Undefined Number BigInt String Symbol` 
- Object: `Array Map Error Date RegExp` 等

JS 中有个包装对象的概念，就是解释 `1` 和 和 `new Number(1)` 区别的。

在 TS 中，原始数据的类型都用首字母小写的表示、原始数据的包装对象用大写表示：

```ts

let a: number = 1
let b: Number = new Number(1)
```

需要特别提示的是：null 、undefined 除了是各自的类型外，undefined 和 null 是所有类型的子类型。可以理解为‘无形’，所有类型都符合这个 ‘万能形’。

这样处理是有现实意义：

```js
let num: number
```

允许这样的写法继续存在，不然初始化为 undefined 时会报错

##### DOM 和 BOM 的内置对象

DOM 和 BOM 提供的内置对象有：
Document、HTMLElement、Event、NodeList 等。

##### TS 引入的内置类型

void: JS 没有空值的概念，没有任何返回值的函数，返回的类型为 void。
其实 void 是个联合类型（类型运算里会提到），相当于 `null | undefined`。因为太常用，就内置了。

any: 任意类型，声明为 any 的变量，可以赋任何类型的值。所有未声明类型的变量，都被隐式声明为 any。

注意：Node.js 不是内置对象的一部分，用 TS 写 Node.js时，则需要引入第三方声明文件

```bash
npm install @types/node --save-dev
```

#### 如何自定义类型

##### 定义对象的形状

```ts
interface Animal {
    color: string;
    age: number;
}

let dog: Animal = {
    color: 'black',
    age: 1
};
```

或者：

```js
type Animal = {
    color: string;
    age: number;
}

let dog: Animal = {
    color: 'black',
    age: 1
};
```

这两种方式在描述形状方面是等价的，但有一点重要区别：

```ts
interface Animal {
    color: string;
    age: number;
}

interface Animal {
    size: number;
}
```

这是允许的，而且两个描述会合并，下面的相当于对上面的补充（增量描述）

但是：

```ts
type Animal = {
    color: string;
    age: number;
}
type Animal = {
    size: number;
}
```

会报错，不允许重复声明一个类型。

怎么理解 type 和 interface 的区别呢：

- interface 是形状声明关键字，就像 function，允许重复声明，但是重复声明的结果不同，interface 执行合并，function 执行覆盖。
- type 可以类比到 const 的行为（只允许赋值一次），并且约束变量，只允许被 interface 赋值。

###### 定义不确定属性名的对象类型

```ts
interface Obj {
    [propName: string]: any;
}
```

注意：`propName` 这个属性名是随意的，有意义的时候后面的类型声明 —— string。

数组也是对象，描述数组时可以在这样：

```ts
interface StringArray {
  [index: number]: string;
}
```

##### 定义数组的形状

- 类型[] 语法

```ts
let fibonacci: number[] = [1, 1, 2, 3, 5];
```

数组的项中必须同一类型。

（下面这段先跳过，看完全部再回过来看）

这种情况下也可以使用内置类型定义函数： `Array<number>` 等价于 number[]

- 用接口表示数组

```ts
interface NumberArray {
    [index: number]: number;
}
let fibonacci: NumberArray = [1, 1, 2, 3, 5];
```

NumberArray 表示：只要索引的类型是数字时，那么值的类型必须是数字。

这种写法只用在类数组的类型定义中，因为类数组本质时对象，使用数组类型约束会报错。比如函数的 arguments：

```ts
function sum() {
    let args: number[] = arguments;
}

// Type 'IArguments' is missing the following properties from type 'number[]': pop, push, concat, join, and 24 more.
```

正确的类型描述应该是：

```ts
function sum() {
    let args: {
        [index: number]: number;
        length: number;
        callee: Function;
    } = arguments;
}
```

##### 通过定义对象来定义类型

当定义一个对象，它的所以属性的值都是原始数据类型时，那么这个对象的类型就可以被推断出来。如果我们想给这个推断出来的类型命名以便之后引用，那么就要用到 enum 关键字：

`enum 对象名 {key = value}`

```ts
enum E1 {
    A = 1, B, C
}
```

这样就会同时生成一个 E1 对象，及由此推断出来的同名类型 E1。很方便有没有！
这个类型也叫枚举类型，因为它的属性有限，且值都是原始数据类型。(如果数组，类似的，值都是原始数据类型时，还有另一个名字：元组 Tuple)

既然讲到了枚举类型，这里就归纳下枚举类型的行为：

- 缺省值的填充：全部缺省，会从0开始递增填充。其他情况根据提示行事即可。

##### 通过引用对象的 属性、方法，来引用其已定义的类型

看例子：

```ts
// 直接引用 string 上的 charAt 方法来引用该函数的类型定义
type P3 = string["charAt"];  // (pos: number => string
type P4 = string[]["push"];  // (...items: string[]) => number
type P5 = string[][0];  // string
```

##### 定义函数的形状

函数形状由参数和返回值的类型决定

```ts
(x: number, y: number) => number
```

很像箭头函数的定义，也可以给这个类型定义起个名字：

```ts
type Func = (x: number, y: number) => number
```

使用 interface 定义：

```ts
interface SearchFunc {
    (source: string, subString: string): boolean;
}

let mySearch: SearchFunc;
mySearch = function(source: string, subString: string) {
    return source.search(subString) !== -1;
}
```

使用 function 定义：

```ts
function reverse(x: number): number;
```

这里定义了 reverse 函数的类型，后面要紧跟着同名函数的实现：

```ts
function reverse(x: number): number;
function reverse(x: number) {
    return Number(x.toString().split('').reverse().join(''))
}
```

和重复声明 interface会进行类型合并一样，也可以通过 function 重复声明函数类型，来进行合并：

```ts
function reverse(x: number): number;
function reverse(x: string): string;
function reverse(x: number | string): number | string {
    if (typeof x === 'number') {
        return Number(x.toString().split('').reverse().join(''));
    } else if (typeof x === 'string') {
        return x.split('').reverse().join('');
    }
}
```

通过合并定义，实现了这样的类型约束：输入为数字的时候，输出也应该为数字，输入为字符串的时候，输出也应该为字符串。

TS会从最前面的函数类型定义开始匹配。

###### 几种特殊参数的类型声明

- 可选参数:

TS 中输入多余的（或者少于要求的）参数，是不允许的。但提供了可选参数语法：与接口中的可选属性类似，用 ? 表示可选的参数

```ts
function buildName(firstName: string, lastName?: string) {
    if (lastName) {
        return firstName + ' ' + lastName;
    } else {
        return firstName;
    }
}
let tomcat = buildName('Tom', 'Cat');
let tom = buildName('Tom');
```

注意：可选参数后面不允许再出现必需参数了，这个很容易理解

- 参数默认值

ES6 支持给函数的参数添加默认值，TS 会将添加了默认值的参数识别为可选参数：

```ts
function buildName(firstName: string, lastName: string = 'Cat') {
    return firstName + ' ' + lastName;
}
let tomcat = buildName('Tom', 'Cat');
let tom = buildName('Tom');
```

- 剩余参数

ES6 中，可以使用 ...rest 的方式获取函数中的剩余参数（rest 参数），rest 其实是一个数组，可以用数组的类型来定义它：

```ts
function push(array: any[], ...items: any[]) {
    items.forEach(function(item) {
        array.push(item);
    });
}

let a = [];
push(a, 1, 2, 3);
```

##### 字面量类型（literal Type）

```ts
type A = 'a'
type S = string
```

注意： `type A = 'a'`，这个类型限定的不在是类似 string 的一个范围，而是具体的单值，这种类型还一个名字：单例类型（Singleton Type）。

##### 修饰符

通过这些修饰符，可以修改类型验证时的行为。

- ?: 看例子

```ts
interface Person {
    name: string;
    age: number;
    location: string;
}
// Person的可选属性类型将是这样：
interface PartialPerson {
    name?: string;
    age?: number;
    location?: string;
}
```

#### 类型缺失时的行为

当没有指定类型时，TS 依据一套规则推断出一个类型。

这套规则是：

- 根据初始化变量时的值类型，注意只根据初始化时执行一次推断，未初始化，就被推断为 any。

```ts
let a = 1
```

等价于

```ts
let a: number = 1
```

```ts
let a;
a = 1
```

等价于

```ts
let a: any;
a = 1
```

- 基于控制流的类型分析（Control Flow Based Type Analysis）以及typeof等类型哨兵（Type Guard）推断每个if else 分支中的变量类型。直接看例子比较好说：

```ts
function triple(input: number | string): number | string {
  if (typeof input === 'number') {
    return input * 3;
  } else {
    return (new Array(4)).join(input);
  }
}
```

TS 可以分析出上述示例中 if 分支中的input一定是 number 类型，else 分支input只能是其余的类型，即 string。

知道 TS 有这个推断能力即可，名字无所谓。

#### 可以对类型进行编程吗（类型运算）

换句话说，是否允许对类型进行操作得到一个新的类型。

##### 即时运算

- &: 看到这个运算符，想 interface 重复声明就好了（新类型包含两个类型中全部属性）。
  
    ```ts
    type Point = {
      x: number;
      y: number;
    };

    type A = {
      a: number
    }

    type C = Point & A

    const test: C = {
      x: 1,
      y: 2,
      a: 1
    }
    ```

- extends:

interface 定义接口时支持继承一个或多个其他已定义的接口或者类：

```ts
interface Shape {
    color: string;
}

interface PenStroke {
    penWidth: number;
}

interface Square extends Shape, PenStroke {
    sideLength: number;
}

let square = <Square>{};
square.color = "blue";
square.sideLength = 10;
square.penWidth = 5.0;
```

看到 extends，当做 `Shape & PenStroke`，和 interface 重复声明一样的效果，只不过每次声明给了不同的名字。

```ts
class Control {
    private state: any;
}

interface SelectableControl extends Control {
    select(): void;
}

```

当 extends 类时，当做 extends 类的类型定义。

- |: 看到这个运算符，应该进行如下等价转换：比如 `A | B => A || B || A & B`, | 到逻辑运算符 || 的转换。
- keyof T: 先看例子
  
  ```ts
  interface Person {
    name: string;
    age: number;
    location: string;
  }

  type K1 = keyof Person; // "name" | "age" | "location"
  type K2 = keyof Person[];  // "length" | "push" | "pop" | "concat" | ...
  type K3 = keyof { [x: string]: Person };  // string
  ```

  可以看出返回的是字面量类型 —— 通过 `|` 连接所有的key。

  - in keyof T: 看例子
  
  ```ts
  interface Person {
      name: string;
      age: number;
      location: string;
  }
  type Partial<T> = {
    [P in keyof T]?: T[P];
  }

  type PartialPerson = Partial<Person>
  ```

  PartialPerson 是：

  ```ts
  {
    name?: string;
    age?: number;
    location?: string;
  }
  ```

  由此可以得到 `[P in keyof T]` 的运算结果，是在类型中产生新属性。（就像Python中的列表推导式，但不是在列表中产生新的元素，而是在类型中产生新的属性。）

- 三目运算符 和 T extends U: T extends U 断言 T 是否为 U 的值类型，一般用在三目运算中 或者 对类型参数进行约束。

  ```ts
  // 对类型参数进行约束
  function getProperty<T, K extends keyof T>(obj: T, key: K) {
    return obj[key];
  }
  ```

  `T extends U ? X : Y`: 意思是，若T能够赋值给U(子类型)，那么类型是X，否则为Y。

##### 定义类型运算过程（类型计算函数）

类比函数定义：

```ts
const identity = x => x; // 值计算
type Identity<T> = T; // 类型计算函数

const pair = (x, y) => [x, y]; // 值计算
type Pair<T, U> = [T, U]; // 类型计算函数
```

当类型定义函数和普通函数结合时，TS 提供了一种定义匿名类型函数的语法 - 伴随函数去定义：

```ts
function identity<T>(x: T): T {
  return x;
}

const outputString = identity<string>('foo');
const outputNumber = identity<number>(666);
```

是不是很溜，而且可以把【类型函数的参数：T】和 【函数参数：x】的类型进行关联。

###### 内置类型计算函数

- Array<T>: 等价于 `T[]`
- Partial<T>: 等价于： 
  
  ```ts
  type Partial<T> = {
    [P in keyof T]?: T[P];
  }
  ```

#### 如何用这些类型对变量进行约束

##### 初始化一个变量时指定类型

###### 变量类型约束

- 直接使用内置类型或者已定义类型名字：

```ts
let name: string;
```

- 调用类型定义函数
  
```ts
let name: Array<string>
```

- 即时定义匿名类型

```ts
let name: string | number;
```

###### 函数类型约束

函数类型定义往往和函数实现结合在一起。
JS 中有两种函数定义方式，以此分类进行介绍。

####### 函数声明（Function Declaration）

- function 类型声明 + 实现

```ts
function reverse(x: number): number;
```

这是函数的类型定义，后面可以紧接实现：

```ts
function reverse(x: number): number {
  return -x
}
```

- 函数类型的‘增量定义’

```ts
function reverse(x: number): number;
function reverse(x: number) {
    return Number(x.toString().split('').reverse().join(''))
}
```

函数类型定义说过，function 可以重复定义函数类型，不断对类型的描述进行补充。

####### 函数表达式（Function Expression）: 把一个匿名函数赋值给一个变量

```ts
// 函数声明（Function Declaration）
function sum(x, y) {
    return x + y;
}


// 函数表达式（Function Expression）
let sum = function (x, y) {
    return x + y;
};
```

可以看到函数表达式本质是把一个匿名函数赋值给一个变量，这个就分为两部分：

- 对匿名函数类型定义：上面已经说过。
- 对变量类型定义：这里可以省略，由右侧的函数声明推断出来。

##### 断言一个已定义变量的类型

语法

```
<类型>值
```

或

```
值 as 类型
```

第二种只用在 tsx 中。

这种需求仅发生在，变量初始化时是多种类型的集合类型，而且 TS 在某一刻推断不出具体类型时：

```ts
function getLength(something: string | number): number {
    if ((<string>something).length) {
        return (<string>something).length; // 如果不断言，变量只能使用 string 、number 共有的属性，所以就会报错
    } else {
        return something.toString().length;
    }
}
```
