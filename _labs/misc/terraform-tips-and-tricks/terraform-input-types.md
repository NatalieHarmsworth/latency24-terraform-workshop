
# Terraform Input Types

## Primitive Types

### `string`

A sequence of unicode characters. Used all the time.  

``` hcl [2-4]
# variables.tf
variable "lettersandstuff" {
 type = string
}
```

``` hcl[2]
# dev.tfvars
lettersandstuff = "heyyyy"
```

### `number`

A number, can be fractional. Used rarely.  

``` hcl[2-5]
# variables.tf
variable "calc_u_later" {
 type = number
}
```

``` hcl [2]
# dev.tfvars
calc_u_later = 420.69
```

### `bool`

A Boolean value (True or false). Used all the time.  

``` hcl [2-5]
# variables.tf
variable "learning_something" {
 type = bool
}
```

``` hcl [2]
# dev.tfvars
learning_something = true
```

## Collection Types

### `list`

A ordered sequence of primitive types. Used all the time as input.

``` hcl [2-5]
# variables.tf
variable "agoodlist"{
 type = list(string)
}
```

``` hcl[2]
# dev.tfvars
agoodlist = ["this","workshop","is","is","is","great"]
```

### `map`

A unordered collection of values identified by a Key. Not used much as its keys are not strictly set, making it hard to lookup.

```hcl [2-7]
# variables.tf
variable "pirate" {
 type = map(string)
}
```

``` hcl[2-5]
# dev.tfvars
pirate = {
 yarhar     = "fiddle dee dee",
 thisIsAKey = "thisIsAValue"
}
```

### `set`

A unordered sequence of unique values. Very rarely used (on the frontend of TF)

```hcl[2-5]
# variables.tf
variable "agoodpun" {
 type = set(string)
}
```

``` hcl [2]
# dev.tfvars
agoodpun = ["this","workshop","just","keeps","giving"]
```

## Structural Types

### `object`

A collection of named attributes, each with their own type. Used all the time inside of other types.

```hcl [2-7]
# variables.tf
variable "aobject" {
 type = object({
  name = string
  count = number
 })
}
```

```hcl [2-10]
# dev.tfvars
aobject = {
 name = "hellyeah"
 count = 20
}
```

### `tuple`

A ordered sequence of types. Each type declared must have *exactly that*. Hard to work with, not very useful.

``` hcl [2-5]
# variables.tf
variable "tupleware" {
 type = tuple([string, bool, number])
}
```

```hcl[2]
# dev.tfvars
["tupleCheck", false, 001]
```

## The Bread and Butter of Variable Types

Remember String, List, Bool, Object.  
Everything else is rarely used.

``` hcl[2-20]
# variables.tf
variable "listofobject" {
 type = list(object({
  name = string
  sku = string
  poweredon = bool
 }))
}
```

```hcl [2-20]
# dev.tfvars
listofobject = [
 {
  name = "obj1"
  sku = "B1"
  poweredon = true
 },
 {
  name = "obj2"
  sku = "F1"
  poweredon = false
 }
]
```

## The Forbidden Type and Input

```hcl [2-6]
# variables.tf
variable "the_no_noes" {
 type = object({
  thisoneis = any
 })
}
```

``` hcl[2]
# dev.tfvars
thisoneis = null
```
