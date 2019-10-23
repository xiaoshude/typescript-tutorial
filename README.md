# 写给大家看的 TypeScript 教程

## 说在前面的话

### 为什么还需要另外一份 TS 教程

专家盲区：就像小孩不会按照你说的做，却愿意听从同龄人的建议。熟练者会认为很多理所当然 —— 其实对初学者很困难，而我有初学者的新鲜观点。
联系：基于这样的背景 —— 熟悉JS，可能了解点其他静态语言，我会把 TS 中新概念或特性类比之前的东西并建立联系。

教程大纲：

1. 最少必要知识：

分三类整理出来：

- 类型
- 面向对象通用知识
- TS 对 JS 的语法增强

这部分务必做到熟稔，就像 26个英文字母。嵌入到你的知识结构中。

2. 试验上面的最少知识，犯错并修正你的理解。

3. 速览高级特性及概念。

这一步的任务是：
- 了解 TS 的全部能力，知道它能干什么。
- 掌握原理。它会很简洁优雅，是你推导纷繁复杂表现的基础。这里没有“惯用法”，每个都有它的道理。

4. 可以开始真实项目的实践了。


开始享用！

## 最少必要知识

TypeScript 是 JavaScript 的一个超集，所有 JS 语法在 TS 中都是合法的。
对 JS 的补集是：类型系统、语法增强。

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

### 面向对象通用知识

面向对象 —— 这个词里主角是对象，所以一切都围绕对象展开（而不是类，虽然难点在这...）。

#### 对象

是一种把数据及操作数据的函数放在一起组织的办法。

你可以分开（通常说的函数式），但不可否认的是，同一职责的放在一块确实提高了对外的易读性。就像一个项目组的产品、前端、后端、QA 通常坐在一块一样。回到前端，把一个区块相关的 CSS、HTML、JS 放在一起形成一个组件，也是这个意思。

#### 批量创造对象

我们往往不满足一个一个手写对象，而是要批量创造对象。

原因很容易理解，这些对象有很多相似的地方，你不想每写个对象就重复下这些相同的东西。得有一种机制，帮你在创造一个对象时，复用这些通用的东西。

##### 先来看一个真实案例

产品并没有在 PRD 中要求按钮点击时高亮反馈，所以新来的同学没做。
如果其他页面都有，而且也都是你做的，那按照惯例，你会加这个交互，这需要长时间合作的默契。

你会发现，每个产品都有一套自己认为不言而喻的交互，因为出现的地方太多，他们懒得到处啰嗦一遍。危险的是，不同的人，‘这套不言而喻’可能并不相通。

所以问题在哪呢？

PRD 没有共享机制，让他们集中描述通用交互。
后来我建议他们维护一个通用交互文档：

- 适用这些通用交互时在 PRD 中引用这份文档就行
- 当和通用交互不符时，只需要在 PRD 中明确不符点即可

目前为止，上面就够用了。

假想，日后随着通用交互越来越多，PRD 中描述的不符点越来越多，某些不符点重复出现的几率很高，但因为和通用交互相斥，无法被融入通用交互，怎么办？

我们缺少一种组合通用交互的能力：

- 首先需要对通用交互分类（拆分成一个个更小的通用交互块：关于按钮得、关于表格的...）
- 对每一个分类：允许有多套实现

组合自己需要的那套通用交互。

假想，慢慢的你发现 ‘关于表格’ 的几套通用交互有相同点，你不想每套里重复描述一遍，怎么办？

第一种办法：把通用的部分提出来，就放在 ‘关于表格’ 这分类下，每套交互和这相同的不必描述，只描述不同点或补充描述。
第二种办法：把 ‘关于表格’ 拆分成更小的分类，把重复的归到一个更小的分类，再去组合。

最后你发现，你的 PRD 成功消除了‘啰嗦’（重复），没有一句话是重复两遍的。

朝着相同的目的 —— 消除重复，我们看看对象怎么做的。

##### 回到对象

消除对象重复的办法：

使用函数构造对象，并关联通用属性和方法

构造函数、通用属性、通用方法使用类组织。

所以：

- 类(Class)：包含了一类对象的通用属性、方法，及构造对象的过程。
- 对象（Object）：类的实例，通过 new 生成
- 对象的特点：封装（Encapsulation） —— 将对数据的操作细节隐藏起来，只暴露对外的接口。外界调用端不需要（也不可能）知道细节，就能通过对外提供的接口来访问该对象，同时也保证了外界无法任意更改对象内部的数据。

插句话：对象应该有隐藏某些属性的能力，但是 JS 未提供支持，TS 支持了这个特性

- 存取器（getter & setter）：用以改变属性的读取和赋值行为
- 修饰符（Modifiers）：修饰符是一些关键字，用于限定成员或类型的性质。比如 public 表示公有属性或方法
- 类的复用：
  - 继承（Inheritance）—— 子类继承父类，子类除了拥有父类的所有特性外，还有一些更具体的特性
    - 多态（Polymorphism）：由继承而产生了相关的不同的类，对同一个方法可以有不同的响应。比如 Cat 和 Dog 都继承自 Animal，但是分别实现了自己的 eat 方法。此时针对某一个实例，我们无需了解它是 Cat 还是 Dog，就可以直接调用 eat 方法，程序会自动判断出来应该如何执行 eat
  - 接口（Interfaces）：不同类之间公有的属性或方法，可以抽象成一个接口。接口可以被类实现（implements）。一个类只能继承自另一个类，但是可以实现多个接口
  - 抽象类（Abstract Class）：抽象类是供其他类继承的基类，抽象类不允许被实例化。抽象类中的抽象方法必须在子类中被实现

- 静态属性、静态方法：它们不需要实例化，而是直接通过类来访问

熟悉这些名词的意思。

TS 中这些特性的使用方法：

###### ES6 中类的用法

####### 属性和方法

使用 class 定义类，使用 constructor 定义构造对象过程，通过 new 生成新实例的时候，会自动调用构造函数。

```js
class Animal {
    constructor(name) {
        this.name = name;
    }
    sayHi() {
        return `My name is ${this.name}`;
    }
}

let a = new Animal('Jack');
console.log(a.sayHi()); // My name is Jack
```

####### 类的复用：继承

使用 extends 关键字实现继承，子类中使用 super 关键字来调用父类的构造函数和方法。

```js
class Cat extends Animal {
    constructor(name) {
        super(name); // 调用父类的 constructor(name)
        console.log(this.name);
    }
    sayHi() {
        return 'Meow, ' + super.sayHi(); // 调用父类的 sayHi()
    }
}

let c = new Cat('Tom'); // Tom
console.log(c.sayHi()); // Meow, My name is Tom
```

####### 存取器

使用 getter 和 setter 可以改变属性的赋值和读取行为：

```js
class Animal {
    constructor(name) {
        this.name = name;
    }
    get name() {
        return 'Jack';
    }
    set name(value) {
        console.log('setter: ' + value);
    }
}

let a = new Animal('Kitty'); // setter: Kitty
a.name = 'Tom'; // setter: Tom
console.log(a.name); // Jack
```

####### 静态方法

使用 static 修饰符修饰的方法为静态方法。

```js
class Animal {
    static isAnimal(a) {
        return a instanceof Animal;
    }
}

let a = new Animal('Jack');
Animal.isAnimal(a); // true
a.isAnimal(a); // TypeError: a.isAnimal is not a function
```

###### ES7 中类的用法

####### 实例属性

ES6 中实例的属性只能通过构造函数中的 this.xxx 来定义，ES7 提案中可以直接在类里面定义：

```js
class Animal {
    name = 'Jack';

    constructor() {
        // ...
    }
}

let a = new Animal();
console.log(a.name); // Jack
```

####### 静态属性

和静态方法一样： static 定义一个静态属性。

```js
class Animal {
    static num = 42;

    constructor() {
        // ...
    }
}

console.log(Animal.num); // 42
```

###### TS 增强的用法

####### 修饰符: public、private、protected、readonly

TS 可以使用三种访问修饰符（Access Modifiers），分别是 public、private 和 protected。

- public 修饰的属性或方法是公有的，可以在任何地方被访问到，默认所有的属性和方法都是 public 的
- private 修饰的属性或方法是私有的，不能在声明它的类的外部访问
- protected 修饰的属性或方法是受保护的，它和 private 类似，区别是它在子类中也是允许被访问的

```ts
class Animal {
    public name;
    public constructor(name) {
        this.name = name;
    }
}

let a = new Animal('Jack');
console.log(a.name); // Jack
a.name = 'Tom';
console.log(a.name); // Tom
```

很多时候，我们希望有的属性是无法直接存取的，这时候就可以用 private 了：

```ts
class Animal {
    private name;
    public constructor(name) {
        this.name = name;
    }
}

let a = new Animal('Jack');
console.log(a.name); // Jack
a.name = 'Tom';

// index.ts(9,13): error TS2341: Property 'name' is private and only accessible within class 'Animal'.
// index.ts(10,1): error TS2341: Property 'name' is private and only accessible within class 'Animal'.
```

这种访问限制只在编译阶段校验。

只读修饰符：readonly，只允许出现在属性声明。

```ts
class Animal {
    readonly name;
    public constructor(name) {
        this.name = name;
    }
}

let a = new Animal('Jack');
console.log(a.name); // Jack
a.name = 'Tom';

// index.ts(10,3): TS2540: Cannot assign to 'name' because it is a read-only property.
```

注意如果 readonly 和其他访问修饰符同时存在的话，需要写在其后面。

```ts
class Animal {
    // public readonly name;
    public constructor(public readonly name) {
        this.name = name;
    }
}
```

使用任何一个修饰符修饰构造函数的参数，都会在实例上附加同名属性：

```ts
class Animal {
    constructor(readonly name) {
    }
}

// 编译后为
class Animal {
    constructor(name) {
        this.name = name;
    }
}

```

### 语法增强

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

## 高级特性及概念

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

参考：

- [TypeScript 入门教程](https://ts.xcatliu.com/advanced/class)
- [Typescript: Interfaces vs Types](https://stackoverflow.com/questions/37233735/typescript-interfaces-vs-types)
- [Typescript 中文文档](https://zhongsp.gitbooks.io/typescript-handbook/)
https://zhuanlan.zhihu.com/p/64446259
- [Typescript 官方文档](https://www.typescriptlang.org/docs/handbook/)
- [浅谈 TypeScript 类型系统](https://zhuanlan.zhihu.com/p/64446259)
- [孩子为什么不能按照你说的去做？（小议专家盲区）](https://zhuanlan.zhihu.com/p/34067857)
