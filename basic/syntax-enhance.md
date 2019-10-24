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
