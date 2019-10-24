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
